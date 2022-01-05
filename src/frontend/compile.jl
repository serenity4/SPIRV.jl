function compile(@nospecialize(f), @nospecialize(argtypes = Tuple{}))
    compile(CFG(f, argtypes))
end

function compile(cfg::CFG, variables = Dictionary{Int,Variable}())
    # TODO: restructure CFG
    inferred = infer(cfg)
    ir = IR()
    fid = emit!(ir, inferred, variables)
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
    "Intermediate results that correspond to SPIR-V `Variable`s. Typically, these results have a mutable Julia type."
    variables::Dictionary{Core.SSAValue,Variable}
    types::Dictionary{Type,SSAValue}
end

IRMapping() = IRMapping(Dictionary(), Dictionary(), Dictionary(), Dictionary(), Dictionary(), Dictionary())

SSAValue(arg::Core.Argument, irmap::IRMapping) = irmap.args[arg]
SSAValue(bb::Int, irmap::IRMapping) = irmap.bbs[bb]
SSAValue(ssaval::Core.SSAValue, irmap::IRMapping) = irmap.ssavals[ssaval]

mutable struct CompilationError <: Exception
    msg::String
    mi::MethodInstance
    jinst::Any
    jtype::Type
    inst::Instruction
    CompilationError(msg::AbstractString) = (err = new(); err.msg = msg; err)
end

function throw_compilation_error(exc::Exception, fields::NamedTuple, msg = "Internal compilation error")
    if isa(exc, CompilationError)
        for (prop, val) in pairs(fields)
            setproperty!(exc, prop, val)
        end
        rethrow()
    else
        err = CompilationError(msg)
        for (prop, val) in pairs(fields)
            setproperty!(err, prop, val)
        end
        throw(err)
    end
end

error_field(field) = string(Base.text_colors[:cyan], field, Base.text_colors[:default], ": ")

function Base.showerror(io::IO, err::CompilationError)
    print(io, "CompilationError")
    if isdefined(err, :mi)
        print(io, " (", err.mi, ")")
    end
    print(io, ": ", err.msg)
    if isdefined(err, :jinst)
        print(io, "\n", error_field("Julia instruction"), err.jinst, Base.text_colors[:yellow], "::", err.jtype, Base.text_colors[:default])
    end
    if isdefined(err, :inst)
        print(io, "\n", error_field("Wrapped SPIR-V instruction"))
        emit(io, err.inst)
    end
    println(io)
end

function emit!(ir::IR, cfg::CFG, variables = Dictionary{Int,Variable}())
    # Declare a new function.
    fdef = define_function!(ir, cfg.mi, variables)
    fid = emit!(ir, fdef)
    insert!(ir.debug.names, fid, make_name(cfg.mi))
    irmap = IRMapping()
    arg_idx = 0
    gvar_idx = 0
    for i in 1:(cfg.mi.def.nargs - 1)
        argid = haskey(variables, i) ? fdef.global_vars[gvar_idx += 1] : fdef.args[arg_idx += 1]
        insert!(irmap.args, Core.Argument(i + 1), argid)
        insert!(ir.debug.names, argid, cfg.code.slotnames[i + 1])
    end

    try
        # Fill it with instructions using the CFG.
        emit!(fdef, ir, irmap, cfg)
    catch e
        throw_compilation_error(e, (; cfg.mi), )
    end
    fid
end

function make_name(mi::MethodInstance)
    Symbol(replace(string(mi.def.name, '_', Base.tuple_type_tail(mi.specTypes)), ' ' => ""))
end

function define_function!(ir::IR, mi::MethodInstance, variables::Dictionary{Int,Variable})
    argtypes = SPIRType[]
    global_vars = SSAValue[]

    for (i, t) in enumerate(mi.specTypes.types[2:end])
        type = SPIRType(t, true)
        var = get(variables, i, nothing)
        @switch var begin
            @case ::Nothing
                push!(argtypes, type)
            @case ::Variable
                @switch var.storage_class begin
                    @case &StorageClassFunction
                        push!(argtypes, type)
                    @case ::StorageClass
                        push!(global_vars, emit!(ir, var))
                end
        end
    end
    ci = GLOBAL_CI_CACHE[mi]
    ftype = FunctionType(SPIRType(ci.rettype), argtypes)
    FunctionDefinition(ftype, FunctionControlNone, [], [], SSADict(), global_vars)
end

function emit!(ir::IR, fdef::FunctionDefinition)
    emit!(ir, fdef.type)
    fid = next!(ir.ssacounter)
    append!(fdef.args, next!(ir.ssacounter) for _ in 1:length(fdef.type.argtypes))
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
    haskey(ir.global_vars, var) && return ir.global_vars[var]
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
    for i in range
        jinst = code[i]
        jtype = ssavaluetypes[i]
        core_ssaval = Core.SSAValue(i)
        spv_inst = nothing
        @assert !(jtype <: Core.IntrinsicFunction) "Encountered illegal core intrinsic $jinst."
        try
            @switch jinst begin
                @case ::Core.ReturnNode
                    spv_inst = @match jinst.val begin
                        ::Nothing => @inst OpReturn()
                        id::Core.SSAValue => @inst OpReturnValue(load_if_variable!(blk, ir, irmap, id))
                        # Assume returned value is a literal.
                        _ => begin
                            c = Constant(jinst.val)
                            @inst OpReturnValue(emit!(ir, irmap, c))
                        end
                    end
                    push!(blk, irmap, spv_inst, core_ssaval)
                @case ::Core.GotoNode
                    dest = irmap.bb_ssavals[Core.SSAValue(jinst.label)]
                    spv_inst = @inst OpBranch(dest)
                    push!(blk, irmap, spv_inst, core_ssaval)
                @case ::Core.GotoIfNot
                    # Core.GotoIfNot uses the SSA value of the first instruction of the target
                    # block as its `dest`.
                    dest = irmap.bb_ssavals[Core.SSAValue(jinst.dest)]
                    spv_inst = @inst OpBranchConditional(SSAValue(jinst.cond, irmap), SSAValue(node + 1, irmap), dest)
                    push!(blk, irmap, spv_inst, core_ssaval)
                @case _
                    check_isvalid(jtype)
                    if ismutabletype(jtype)
                        allocate_variable!(ir, irmap, fdef, jtype, core_ssaval)
                    end
                    ret = emit_inst!(ir, irmap, cfg, fdef, jinst, jtype, blk)
                    if isa(ret, Instruction)
                        if ismutabletype(jtype)
                            # The current core SSAValue has already been assigned (to the variable).
                            push!(blk, irmap, ret, nothing)
                            # Store to the new variable.
                            push!(blk, irmap, @inst OpStore(irmap.ssavals[core_ssaval], ret.result_id::SSAValue))
                        else
                            push!(blk, irmap, ret, core_ssaval)
                        end
                    elseif isa(ret, SSAValue)
                        # The value is a SPIR-V global (possibly a constant),
                        # so no need to push a new function instruction.
                        # Just map the current SSA value to the global.
                        insert!(irmap.ssavals, core_ssaval, ret)
                    end
            end
        catch e
            fields = (; jinst, jtype)
            !isnothing(spv_inst) && (fields = (; fields..., inst = spv_inst))
            throw_compilation_error(e, fields)
        end
    end

    # Implicit `goto` to the next block.
    if !is_termination_instruction(last(blk.insts))
        spv_inst = @inst OpBranch(SSAValue(node + 1, irmap))
        push!(blk, irmap, spv_inst)
    end
end

const termination_instructions = Set([
    OpBranch, OpBranchConditional,
    OpReturn, OpReturnValue,
    OpUnreachable,
    OpKill, OpTerminateInvocation,
])

is_termination_instruction(inst::Instruction) = inst.opcode in termination_instructions

function allocate_variable!(ir::IR, irmap::IRMapping, fdef::FunctionDefinition, jtype::Type, core_ssaval::Core.SSAValue)
    # Create a SPIR-V variable to allow for future mutations.
    id = next!(ir.ssacounter)
    type = PointerType(StorageClassFunction, SPIRType(jtype))
    var = Variable(type)
    emit!(ir, type)
    insert!(irmap.variables, core_ssaval, var)
    insert!(irmap.ssavals, core_ssaval, id)
    push!(fdef.local_vars, Instruction(var, id, ir.types))
end

function Base.push!(block::Block, irmap::IRMapping, inst::Instruction, core_ssaval::Optional{Core.SSAValue} = nothing)
    if !isnothing(inst.result_id) && !isnothing(core_ssaval)
        insert!(irmap.ssavals, core_ssaval, inst.result_id)
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

function check_isvalid(jtype::Type)
    if !in(jtype, spirv_types)
        if isabstracttype(jtype)
            throw(CompilationError("Found abstract type '$jtype' after type inference. All types must be concrete."))
        elseif !isconcretetype(jtype)
            throw(CompilationError("Found non-concrete type '$jtype' after type inference. All types must be concrete."))
        end
    end
end

macro compile(ex)
    compile_args = map(esc, get_signature(ex))
    :(compile($(compile_args...)))
end
