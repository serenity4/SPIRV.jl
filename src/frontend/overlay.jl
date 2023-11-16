@MethodTable INTRINSICS_METHOD_TABLE

"""
Declare a new method as part of the intrinsics method table.

This new method declaration should override a method from `Base`,
typically one that would call core intrinsics. Its body typically
consists of one or more calls to declared intrinsic functions (see [`@intrinsic`](@ref)).

The method will always be inlined.
"""
macro override(ex)
  esc(:(SPIRV.@overlay SPIRV.INTRINSICS_METHOD_TABLE @inline $ex))
end
