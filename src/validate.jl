const spirv_types = Set([
    String;
    Int8; Int16; Int32; Int64;
    UInt8; UInt16; UInt32; UInt64;
    Float16; Float32; Float64;
    SSAValue;
    collect(enum_types);
    OpCode; OpCodeGLSL;
])

function validate(mod::Module)
    validate_types(mod) && validate_khronos(mod)
end

function validate_types(mod::Module)
    for inst in mod
        for arg in [inst.arguments; filter(!isnothing, [inst.type_id, inst.result_id])]
            T = typeof(arg)
            T in spirv_types || throw(ValidationError("""
                Argument $(repr(arg)) of type $(repr(T)) is not a SPIR-V type.
                Offending instruction: $(sprint(emit, inst; context = :color => true))
                """))
        end
    end
    true
end

"""
Validate a SPIR-V module using [Khronos' reference validator](https://github.com/KhronosGroup/SPIRV-Tools#validator).
"""
function validate_khronos(mod::Module)
    input = IOBuffer()
    write(input, mod)
    seekstart(input)
    err = IOBuffer()

    try
        run(pipeline(`$spirv_val -`, stdin=input, stderr=err))
    catch e
        if e isa ProcessFailedException
            err_str = String(take!(err))
            rethrow(ValidationError(err_str))
        else
            rethrow(e)
        end
    end

    true
end

function validate(ir::IR; check_entrypoint = true)
    if !check_entrypoint
        # Insert Linkage capability to get around the related validation error.
        ir = @set ir.capabilities = union(ir.capabilities, [SPIRV.CapabilityLinkage])
    end
    validate(Module(ir))
end

struct ValidationError <: Exception
    msg::String
end

Base.showerror(io::IO, err::ValidationError) = print(io, "ValidationError:\n\n$(err.msg)")
