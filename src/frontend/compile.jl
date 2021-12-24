function compile(@nospecialize(f), @nospecialize(argtypes = Tuple{}))
    compile(CFG(f, argtypes))
end

function compile(cfg::CFG)
    # TODO: restructure CFG
    inferred = infer(cfg)
    IR(inferred)
end

function IR(cfg::CFG)
    ir = IR()
    emit!(ir, cfg)
    satisfy_requirements!(ir)
    ir
end

struct IRMapping
    args::Dictionary{Core.Argument,SSAValue}
    "SPIR-V SSA values for basic blocks from Julia IR."
    bbs::Dictionary{Int,SSAValue}
    "SPIR-V SSA values that correspond semantically to `Core.SSAValue`s."
    ssavals::Dictionary{Core.SSAValue,SSAValue}
    types::Dictionary{Type,SSAValue}
end

IRMapping() = IRMapping(Dictionary(), Dictionary(), Dictionary(), Dictionary())

SSAValue(arg::Core.Argument, irmap::IRMapping) = irmap.args[arg]
SSAValue(bb::Int, irmap::IRMapping) = irmap.bbs[bb]
SSAValue(ssaval::Core.SSAValue, irmap::IRMapping) = irmap.ssavals[ssaval]

function emit!(ir::IR, cfg::CFG)
    ftype = FunctionType(cfg.mi)
    fdef = FunctionDefinition(ftype, FunctionControlNone, [], SSADict())
    irmap = IRMapping()
    emit!(ir, irmap, ftype)
    id = next!(ir.ssacounter)
    insert!(ir.fdefs, id, fdef)
    for n in eachindex(ftype.argtypes)
        id = next!(ir.ssacounter)
        insert!(irmap.args, Core.Argument(n + 1), id)
        push!(fdef.args, id)
    end
    emit!(fdef, ir, irmap, cfg)
    id
end

function FunctionType(mi::MethodInstance)
    argtypes = map(SPIRType, Base.tuple_type_tail(mi.specTypes).types)
    ci = GLOBAL_CI_CACHE[mi]
    FunctionType(SPIRType(ci.rettype), argtypes)
end

function emit!(ir::IR, irmap::IRMapping, type::FunctionType)
    !haskey(ir.types.backward, type) || return ir.types[type]
    emit!(ir, irmap, type.rettype)
    for t in type.argtypes
        emit!(ir, irmap, t)
    end
    insert!(ir.types, next!(ir.ssacounter), type)
end

function emit!(ir::IR, irmap::IRMapping, @nospecialize(type::SPIRType))
    !haskey(ir.types.backward, type) || return ir.types[type]

    @switch type begin
        @case ::PointerType
            emit!(ir, irmap, type.type)
        @case (::ArrayType && GuardBy(isnothing ∘ Base.Fix2(getproperty, :size))) || ::VectorType || ::MatrixType
            emit!(ir, irmap, type.eltype)
        @case ::ArrayType
            emit!(ir, irmap, type.eltype)
            emit!(ir, irmap, type.size)
        @case ::StructType
            for t in type.members
                emit!(ir, irmap, t)
            end
        @case ::ImageType
            emit!(ir, irmap, type.sampled_type)
        @case ::SampledImageType
            emit!(ir, irmap, type.image_type)
        @case ::VoidType || ::IntegerType || ::FloatType || ::BooleanType || ::OpaqueType
            next!(ir.ssacounter)
    end

    id = next!(ir.ssacounter)
    insert!(ir.types, id, type)
    id
end

function emit!(ir::IR, irmap::IRMapping, c::Constant)
    @switch c.value begin
        @case (::Nothing, type::SPIRType) || (::Vector{SSAValue}, type::SPIRType)
            emit!(ir, irmap, type)
        @case ::Bool
            emit!(ir, irmap, BooleanType())
        @case val
            emit!(ir, irmap, SPIRType(typeof(val)))
    end
    id = next!(ir.ssacounter)
    insert!(ir.constants, id, c)
    id
end

function emit!(fdef::FunctionDefinition, ir::IR, irmap::IRMapping, cfg::CFG)
    ranges = block_ranges(cfg)
    for node in topological_sort_by_dfs(bfs_tree(cfg.graph, 1))
        emit!(fdef, ir, irmap, cfg, ranges[node])
    end
end

function emit!(fdef::FunctionDefinition, ir::IR, irmap::IRMapping, cfg::CFG, range::UnitRange)
    (; code) = cfg
    blk = Block(next!(ir.ssacounter))
    push!(blk.insts, @inst blk.id = OpLabel())
    insert!(fdef.blocks, blk.id, blk)
    i = first(range)
    n = last(range)
    while i ≤ n
        inst = code.code[i]
        jtype = code.ssavaluetypes[i]
        @switch inst begin
            # Termination instructions.
            @case ::Core.GotoIfNot || ::Core.GotoNode || ::Core.ReturnNode
                break
            @case _
                spv_inst = emit!(blk, ir, irmap, i, inst, jtype)
        end
        i += 1
    end

    # Process termination instructions.
    i ≤ n || error("No termination instruction found. Last instruction: :($(code.code[n]))")
    for inst in code.code[i:n]
        @switch inst begin
            @case ::Core.ReturnNode
                spv_inst = @match inst.val begin
                    ::Nothing => @inst OpReturn()
                    id::Core.SSAValue => @inst OpReturnValue(irmap.ssavals[id])
                    # Assume returned value is a literal.
                    _ => begin
                        c = Constant(inst.val)
                        c_inst = emit!(ir, irmap, c)::Instruction
                        @inst OpReturnValue(c_inst.result_id::SSAValue)
                    end
                end
                emit!(blk, ir, irmap, n, spv_inst)
            @case ::Core.GotoNode
                emit!(blk, ir, irmap, n)
            @case ::Core.GotoIfNot
                nothing
        end
    end
end

function emit!(block::Block, ir::IR, irmap::IRMapping, i::Integer, args...)
    emit!(block, ir, irmap, i, emit!(ir, irmap, args...))
end

function emit!(block::Block, ir::IR, irmap::IRMapping, i::Integer, inst::Instruction)
    push!(block.insts, inst)
    if !isnothing(inst.result_id)
        insert!(irmap.ssavals, Core.SSAValue(i), inst.result_id)
    end
    inst
end

function julia_type(@nospecialize(t::SPIRType), ir::IR)
    @match t begin
        &(IntegerType(8, false)) => UInt8
        &(IntegerType(16, false)) => UInt16
        &(IntegerType(32, false)) => UInt32
        &(IntegerType(64, false)) => UInt64
        &(IntegerType(8, true)) => Int8
        &(IntegerType(16, true)) => Int16
        &(IntegerType(32, true)) => Int32
        &(IntegerType(64, true)) => Int64
        &(FloatType(16)) => Float16
        &(FloatType(32)) => Float32
        &(FloatType(64)) => Float64
    end
end

function emit_extinst!(ir::IR, extinst)
    haskey(ir.extinst_imports.backward, extinst) && return ir.extinst_imports[extinst]
    insert!(ir.extinst_imports, next!(ir.ssacounter), extinst)
end

macro compile(ex)
    compile_args = map(esc, get_signature(ex))
    :(compile($(compile_args...)))
end
