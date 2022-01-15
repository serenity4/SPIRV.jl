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
    variable_decorations::Dictionary{Int,DecorationData}
    type_decorations::Dictionary #= {Union{DataType,Pair{DataType,Symbol}},DecorationData} =#
    ShaderInterface(execution_model::ExecutionModel, storage_classes = [], variable_decorations = Dictionary(), type_decorations = Dictionary()) = new(execution_model, storage_classes, variable_decorations, type_decorations)
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

    add_variable_decorations!(ir, variables, interface)
    add_type_decorations!(ir, interface)

    # Fill function body.
    blk = new_block!(main, next!(ir.ssacounter))

    # The dictionary loses some of its elements to #undef values.
    #TODO: fix this hack in Dictionaries.jl
    fid = findfirst(==(fdef), ir.fdefs.forward)

    push!(blk.insts, @inst next!(ir.ssacounter) = OpFunctionCall(fid)::ir.types[fdef.type.rettype])
    push!(blk.insts, @inst OpReturn())
    satisfy_requirements!(ir)
end

function add_variable_decorations!(ir::IR, variables, interface::ShaderInterface)
    for (i, decs) in enumerate(interface.variable_decorations)
        merge!(ir.decorations[ir.global_vars[variables[i]]], decs)
    end
end

function add_type_decorations!(ir::IR, interface::ShaderInterface)
    for (target, decs) in pairs(interface.type_decorations)
        @switch target begin
            @case ::DataType
                spv_t = ir.typerefs[target]
                merge!(get!(DecorationData, ir.decorations, ir.types[spv_t]), decs)
            @case ::Pair{DataType, Symbol}
                (T, field) = target
                spv_t = ir.typerefs[T]
                idx = findfirst(==(field), fieldnames(T))
                if isnothing(idx)
                    error("Field $(repr(field)) is not a fieldname of $T")
                end
                if !isa(spv_t, StructType)
                    error("Type $T is mapped to a non-aggregate type $spv_t")
                end
                merge!(get!(DecorationData, spv_t.member_decorations, idx), decs)
        end
    end
end

function make_shader(cfg::CFG, interface::ShaderInterface)
    ir = IR()
    variables = Dictionary{Int,Variable}()
    for (i, sc) in enumerate(interface.storage_classes)
        if sc ≠ StorageClassFunction
            var = Variable(PointerType(sc, spir_type!(ir, cfg.mi.specTypes.parameters[i+1], false)))
            insert!(variables, i, var)
        end
    end
    compile!(ir, cfg, variables)
    make_shader!(ir, cfg.mi, interface, variables)
end
