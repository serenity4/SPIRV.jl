macro forward(ex, fs)
    T, prop = @match ex begin
        :($T.$prop) => (T, prop)
        _ => error("Invalid expression $ex, expected <Type>.<prop>")
    end

    fs = @match fs begin
        :(($(fs...),)) => fs
        _ => error("Expected a tuple of functions, got $fs")
    end

    defs = map(fs) do f
        esc(:($f(x::$T, args...; kwargs...) = $f(x.$prop, args...; kwargs...)))
    end

    Expr(:block, defs...)
end

macro inst(ex)
    result_id, inst = @match ex begin
        :($result_id = $inst) => (result_id, inst)
        _ => (nothing, ex)
    end

    type_id, call = @match inst begin
        :($call::$T) => (T, call)
        _ => (nothing, inst)
    end

    opcode, args = @match call begin
        :($opcode($(args...))) => (esc(opcode), esc.(args))
        _ => error("Invalid call $call")
    end

    :(Instruction($opcode, $(esc(type_id)), $(esc(result_id)), $(args...)))
end

macro broadcastref(ex)
    T = @match ex begin
        :(struct $T; $(fields...); end) => T
    end

    T = @match T begin
        ::Symbol => T
        :($T{$(params...)}) => T
    end

    quote
        $(esc(ex))
        Base.broadcastable(x::$(esc(T))) = Ref(x)
    end
end
