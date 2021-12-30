function compile(@nospecialize(f), @nospecialize(argtypes = Tuple{}))
    compile(CFG(f, argtypes))
end

function compile(cfg::CFG)
    # TODO: restructure CFG
    inferred = infer(cfg)
    ir = IR()
    fid = emit!(ir, inferred)
    satisfy_requirements!(ir)
end

struct IRMapping
    args::Dictionary{Core.Argument,SSAValue}
    "SPIR-V SSA values for basic blocks from Julia IR."
    bbs::Dictionary{Int,SSAValue}
    "SPIR-V SSA values for each `Core.SSAValue` that implicitly represents a basic block."
    bb_ssavals::Dictionary{Core.SSAValue,SSAValue}
    "SPIR-V SSA values that correspond semantically to `Core.SSAValue`s."
    ssavals::Dictionary{Core.SSAValue,SSAValue}
    types::Dictionary{Type,SSAValue}
end

IRMapping() = IRMapping(Dictionary(), Dictionary(), Dictionary(), Dictionary(), Dictionary())

SSAValue(arg::Core.Argument, irmap::IRMapping) = irmap.args[arg]
SSAValue(bb::Int, irmap::IRMapping) = irmap.bbs[bb]
SSAValue(ssaval::Core.SSAValue, irmap::IRMapping) = irmap.ssavals[ssaval]

function emit!(ir::IR, cfg::CFG)
    # Declare a new function.
    ftype = FunctionType(cfg.mi)
    fdef = FunctionDefinition(ftype, FunctionControlNone, [], SSADict())
    fid = emit!(ir, fdef)
    insert!(ir.debug.names, fid, make_name(cfg.mi))
    irmap = IRMapping()
    for (i, argid) in enumerate(fdef.args)
        insert!(irmap.args, Core.Argument(i + 1), argid)
        insert!(ir.debug.names, argid, cfg.code.slotnames[i + 1])
    end

    # Fill it with instructions using the CFG.
    try
        emit!(fdef, ir, irmap, cfg)
    catch
        println("Internal compilation error for method instance $(cfg.mi)")
        rethrow()
    end
    fid
end

function make_name(mi::MethodInstance)
    Symbol(replace(string(mi.def.name, '_', Base.tuple_type_tail(mi.specTypes)), ' ' => ""))
end

function FunctionType(mi::MethodInstance)
    argtypes = map(SPIRType, Base.tuple_type_tail(mi.specTypes).types)
    ci = GLOBAL_CI_CACHE[mi]
    FunctionType(SPIRType(ci.rettype), argtypes)
end

function emit!(ir::IR, fdef::FunctionDefinition)
    emit!(ir, fdef.type)
    fid = next!(ir.ssacounter)
    for n in eachindex(fdef.type.argtypes)
        id = next!(ir.ssacounter)
        push!(fdef.args, id)
    end
    insert!(ir.fdefs, fid, fdef)
    fid
end

emit!(ir::IR, irmap::IRMapping, c::Constant) = emit!(ir, c)
emit!(ir::IR, irmap::IRMapping, @nospecialize(type::SPIRType)) = emit!(ir, type)

function emit!(ir::IR, @nospecialize(type::SPIRType))
    haskey(ir.types, type) && return ir.types[type]
    @switch type begin
        @case ::PointerType
            emit!(ir, type.type)
        @case (::ArrayType && GuardBy(isnothing ∘ Base.Fix2(getproperty, :size))) || ::VectorType || ::MatrixType
            emit!(ir, type.eltype)
        @case ::ArrayType
            emit!(ir, type.eltype)
            emit!(ir, type.size)
        @case ::StructType
            for t in type.members
                emit!(ir, t)
            end
        @case ::ImageType
            emit!(ir, type.sampled_type)
        @case ::SampledImageType
            emit!(ir, type.image_type)
        @case ::VoidType || ::IntegerType || ::FloatType || ::BooleanType || ::OpaqueType
            next!(ir.ssacounter)
        @case ::FunctionType
            emit!(ir, type.rettype)
            for t in type.argtypes
                emit!(ir, t)
            end
    end

    id = next!(ir.ssacounter)
    insert!(ir.types, id, type)
    id
end

function emit!(ir::IR, c::Constant)
    haskey(ir.constants, c) && return ir.constants[c]
    emit!(ir, SPIRType(c))
    id = next!(ir.ssacounter)
    insert!(ir.constants, id, c)
    id
end

function emit!(ir::IR, var::Variable, decorations = DecorationData())
    emit!(ir, var.type)
    id = next!(ir.ssacounter)
    insert!(ir.global_vars, id, var)
    insert!(ir.decorations, id, decorations)
    id
end

function emit!(fdef::FunctionDefinition, ir::IR, irmap::IRMapping, cfg::CFG)
    ranges = block_ranges(cfg)
    nodelist = topological_sort_by_dfs(bfs_tree(cfg.graph, 1))
    for node in nodelist
        id = next!(ir.ssacounter)
        insert!(irmap.bbs, node, id)
        insert!(irmap.bb_ssavals, Core.SSAValue(first(ranges[node])), id)
    end
    for node in nodelist
        emit!(fdef, ir, irmap, cfg, ranges[node], node)
    end
    for block in fdef.blocks
        for inst in block.insts
            for (i, arg) in enumerate(inst.arguments)
                if isa(arg, Core.SSAValue)
                    inst.arguments[i] = SSAValue(arg, irmap)
                end
            end
        end
    end
end

function emit!(fdef::FunctionDefinition, ir::IR, irmap::IRMapping, cfg::CFG, range::UnitRange, node::Integer)
    (; code, ssavaluetypes, slottypes) = cfg.code
    blk = new_block!(fdef, SSAValue(node, irmap))
    i = first(range)
    n = last(range)
    while i ≤ n
        inst = code[i]
        jtype = ssavaluetypes[i]
        @assert !(jtype <: Core.IntrinsicFunction) "Encountered illegal core intrinsic $inst."
        @switch inst begin
            # Termination instructions.
            @case ::Core.GotoIfNot || ::Core.GotoNode || ::Core.ReturnNode
                break
            @case _
                ret = emit_inst!(ir, irmap, cfg, inst, jtype)
                if isa(ret, Instruction)
                    push!(blk, irmap, ret, i)
                elseif isa(ret, SSAValue)
                    insert!(irmap.ssavals, Core.SSAValue(i), ret)
                end
        end
        i += 1
    end

    # Implicit `goto` to the next block.
    if i > n
        spv_inst = @inst OpBranch(SSAValue(node + 1, irmap))
        push!(blk, irmap, spv_inst)
        return
    end

    # Process termination instructions.
    for inst in code[i:n]
        @switch inst begin
            @case ::Core.ReturnNode
                spv_inst = @match inst.val begin
                    ::Nothing => @inst OpReturn()
                    id::Core.SSAValue => @inst OpReturnValue(SSAValue(id, irmap))
                    # Assume returned value is a literal.
                    _ => begin
                        c = Constant(inst.val)
                        @inst OpReturnValue(emit!(ir, irmap, c))
                    end
                end
                push!(blk, irmap, spv_inst, n)
            @case ::Core.GotoNode
                dest = irmap.bb_ssavals[Core.SSAValue(inst.label)]
                spv_inst = @inst OpBranch(dest)
                push!(blk, irmap, spv_inst, n)
            @case ::Core.GotoIfNot
                # Core.GotoIfNot uses the SSA value of the first instruction of the target
                # block as its `dest`.
                dest = irmap.bb_ssavals[Core.SSAValue(inst.dest)]
                spv_inst = @inst OpBranchConditional(SSAValue(inst.cond, irmap), SSAValue(node + 1, irmap), dest)
                push!(blk, irmap, spv_inst, n)
        end
    end
end

function Base.push!(block::Block, irmap::IRMapping, inst::Instruction, i::Optional{Int} = nothing)
    if !isnothing(inst.result_id)
        insert!(irmap.ssavals, Core.SSAValue(i::Int), inst.result_id)
    end
    push!(block.insts, inst)
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
    haskey(ir.extinst_imports, extinst) && return ir.extinst_imports[extinst]
    id = next!(ir.ssacounter)
    insert!(ir.extinst_imports, id, extinst)
    id
end

macro compile(ex)
    compile_args = map(esc, get_signature(ex))
    :(compile($(compile_args...)))
end
