function validate(mod::Module)
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

validate(ir::IR) = validate(Module(ir))

struct ValidationError <: Exception
    msg::String
end

Base.showerror(io::IO, err::ValidationError) = print(io, "ValidationError:\n\n$(err.msg)")
