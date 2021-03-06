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

isline(x) = false
isline(x::LineNumberNode) = true

function rmlines(ex)
    @match ex begin
        Expr(:macrocall, m, _...) => Expr(:macrocall, m, nothing, filter(x -> !isline(x), ex.args[3:end])...)
        ::Expr                    => Expr(ex.head, filter(!isline, ex.args)...)
        a                         => a
    end
end

macro broadcastref(ex)
    T = @match ex begin
        :(struct $T; $(fields...); end) => T
        :(abstract type $T end) => T
    end

    T = @match T begin
        ::Symbol => T
        :($T{$(_...)}) => T
    end

    quote
        Base.@__doc__ $(esc(ex))
        Base.broadcastable(x::$(esc(T))) = Ref(x)
    end
end

function source_version(language::SourceLanguage, version::Integer)
    @match language begin
        &SourceLanguageGLSL => begin
            major = version ÷ 100
            minor = (version - 100 * major) ÷ 10
            VersionNumber(major, minor)
        end
    end
end

function source_version(language::SourceLanguage, version::VersionNumber)
    @match language begin
        &SourceLanguageGLSL => begin
            @unpack major, minor = version
            10 * minor + 100 * major
        end
    end
end
