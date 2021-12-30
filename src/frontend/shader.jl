"""
Declare an entry point named `:main` that calls the provided method instance.
"""
function FunctionDefinition(ir::IR, name::Symbol)
    for (id, val) in pairs(ir.debug.names)
        if val == name && haskey(ir.fdefs, id)
            return ir.fdefs[id]
        end
    end
    error("No function named '$name' could be found.")
end

FunctionDefinition(ir::IR, mi::MethodInstance) = FunctionDefinition(ir, make_name(mi))

function make_shader!(ir::IR, mi::MethodInstance, execution_model::ExecutionModel = ExecutionModelVertex)
    fdef = FunctionDefinition(ir, mi)
    main_t = FunctionType(VoidType(), [])
    main = FunctionDefinition(main_t, FunctionControlNone, [], SSADict())
    ep = EntryPoint(:main, emit!(ir, main), execution_model, [], [])
    insert!(ir.entry_points, ep.func, ep)

    (; rettype, argtypes) = fdef.type
    input_vars = SSAValue[]
    for (i, (param, t)) in enumerate(zip(fdef.args, argtypes))
        var_t = promote_to_pointer(t, StorageClassInput)
        var = Variable(var_t, StorageClassInput, nothing)
        #TODO: Compute location based on type size.
        decorations = dictionary([DecorationLocation => [UInt32(i - 1)]])
        push!(input_vars, emit!(ir, var, decorations))
    end
    append!(ep.interfaces, input_vars)

    # Fill function body.
    blk = new_block!(main, next!(ir.ssacounter))
    load_insts = map(zip(input_vars, argtypes)) do (var_id, var_t)
        @inst next!(ir.ssacounter) = OpLoad(var_id)::ir.types[var_t]
    end
    append!(blk.insts, load_insts)
    rt_id = emit!(ir, rettype)

    # The dictionary loses some of its elements to #undef values.
    #TODO: fix this hack in Dictionaries.jl
    fid = findfirst(==(fdef), ir.fdefs.forward)

    if rettype ≠ VoidType()
        var_out_t = promote_to_pointer(rettype, StorageClassOutput)
        var_out = Variable(var_out_t, StorageClassOutput, nothing)
        var_out_id = emit!(ir, var_out, dictionary([DecorationLocation => [UInt32(0)]]))
        push!(ep.interfaces, var_out_id)
        rid = next!(ir.ssacounter)
        push!(blk.insts, @inst rid = OpFunctionCall(fid, getproperty.(load_insts, :result_id)...)::rt_id)
        push!(blk.insts, @inst OpStore(var_out_id, rid))
    else
        push!(blk.insts, @inst next!(ir.ssacounter) = OpFunctionCall(fid, getproperty.(load_insts, :result_id)...)::rt_id)
    end
    push!(blk.insts, @inst OpReturn())
    satisfy_requirements!(ir)
end

function make_shader(cfg::CFG)
    ir = compile(cfg)
    make_shader!(ir, cfg.mi)
end

promote_to_pointer(t::SPIRType, storage_class) = PointerType(storage_class, t)
promote_to_pointer(t::PointerType, storage_class) = @set t.storage_class = storage_class
