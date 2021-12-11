"""
Expression similar to `Base.Expr`, but with different semantics regarding the meaning of `head` symbols.
"""
struct Expr
    head::Symbol
    args::Vector{Any}
end

Expr(head::Symbol, args::AbstractVector) = Expr(head, convert(Vector{Any}, args))
Expr(head::Symbol, args...) = Expr(head, collect(args))

#=

Expr(:for, iter_spec, body)
Expr(:while, cond, body)
Expr(:new, PrimitiveType, value) # new primitive
Expr(:new, CompositeType, fields...) # new struct
Expr(:call, f_symbol, type) # function call yet to be resolved
Expr(:call, function, type) # dynamic dispatch
Expr(:invoke, method_instance, type) # static dispatch
Expr(:=, var_name, value)

=#


function some_code(x)
    j = 0
    for i in 1:x
        i < 5 * (x - 1) && break
        j = i + x
    end
    j > 5 ? nothing : j
end
