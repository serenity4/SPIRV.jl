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
    execution_model::ExecutionModel
    storage_classes::Vector{StorageClass}
    decorations::Dictionary{Int,DecorationData}
    ShaderInterface(execution_model::ExecutionModel, storage_classes = [], decorations = Dictionary()) = new(execution_model, storage_classes, decorations)
end


"""
Wrap a given method instance for use in a shader.

All function arguments from the given method instance will be filled with global variables.
The provided interface describes storage locations and decorations for those global variables.

It is assumed that the function arguments are typed to use same storage classes.
"""
function make_shader!(ir::IR, mi::MethodInstance, interface::ShaderInterface, variables)
    fdef = FunctionDefinition(ir, mi)
    main_t = FunctionType(VoidType(), [])
    main = FunctionDefinition(main_t)
    ep = EntryPoint(:main, emit!(ir, main), interface.execution_model, [], fdef.global_vars)
    insert!(ir.entry_points, ep.func, ep)

    for (i, dec) in enumerate(interface.decorations)
        merge!(ir.decorations[ir.global_vars[variables[i]]], dec)
    end

    # Fill function body.
    blk = new_block!(main, next!(ir.ssacounter))

    # The dictionary loses some of its elements to #undef values.
    #TODO: fix this hack in Dictionaries.jl
    fid = findfirst(==(fdef), ir.fdefs.forward)

    push!(blk.insts, @inst next!(ir.ssacounter) = OpFunctionCall(fid)::ir.types[fdef.type.rettype])
    push!(blk.insts, @inst OpReturn())
    satisfy_requirements!(ir)
end

function make_shader(cfg::CFG, interface::ShaderInterface)
    variables = Dictionary{Int,Variable}()
    for (i, sc) in enumerate(interface.storage_classes)
        if sc ≠ StorageClassFunction
            var = Variable(PointerType(sc, SPIRType(cfg.mi.specTypes.parameters[i+1], false)))
            insert!(variables, i, var)
        end
    end
    ir = compile(cfg, variables)
    make_shader!(ir, cfg.mi, interface, variables)
end
