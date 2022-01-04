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

struct ShaderInterface
    decorations::Dictionary{Int,DecorationData}
    execution_model::ExecutionModel
end

ShaderInterface() = ShaderInterface(Dictionary(), ExecutionModelVertex)

"""
Wrap a given method instance for use in a shader.

All function arguments from the given method instance will be filled with global variables.
The provided interface describes storage locations and decorations for those global variables.

It is assumed that the function arguments are typed to use same storage classes.
"""
function make_shader!(ir::IR, mi::MethodInstance, interface::ShaderInterface)
    fdef = FunctionDefinition(ir, mi)
    main_t = FunctionType(VoidType(), [])
    main = FunctionDefinition(main_t)
    ep = EntryPoint(:main, emit!(ir, main), interface.execution_model, [], [])
    insert!(ir.entry_points, ep.func, ep)

    (; rettype, argtypes) = fdef.type
    input_vars = SSAValue[]
    for (i, t) in enumerate(argtypes)
        decorations = get(DecorationData, interface.decorations, i)
        push!(input_vars, emit!(ir, Variable(t), decorations))
    end
    append!(ep.interfaces, input_vars)

    # Fill function body.
    blk = new_block!(main, next!(ir.ssacounter))

    # The dictionary loses some of its elements to #undef values.
    #TODO: fix this hack in Dictionaries.jl
    fid = findfirst(==(fdef), ir.fdefs.forward)

    push!(blk.insts, @inst next!(ir.ssacounter) = OpFunctionCall(fid, input_vars...)::ir.types[rettype])
    push!(blk.insts, @inst OpReturn())
    satisfy_requirements!(ir)
end

function make_shader(cfg::CFG, interface::ShaderInterface = ShaderInterface(); storage_classes = Dictionary{Int,StorageClass}())
    ir = compile(cfg, storage_classes)
    make_shader!(ir, cfg.mi, interface)
end
