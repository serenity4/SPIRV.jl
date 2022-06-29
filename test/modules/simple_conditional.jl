Bool = TypeBool()
Int32 = TypeInt(32, 1)
Float32 = TypeFloat(32)
c_1f0 = Constant(1f0)::Float32
c_1 = Constant(Int32(1))::Int32

@function f(x::Int32, y::Int32)::Float32 begin
  b1 = Label()
  x_plus_y = IAdd(x, y)::Int32
  to_b3 = SLessThan(x_plus_y, c_1)::Bool
  BranchConditional(to_b3, b3, b2)

  b2 = Label()
  x_plus_y_float = ConvertSToF(x_plus_y)::Float32
  z = FAdd(x_plus_y_float, c_1f0)::Float32
  ReturnValue(z)

  b3 = Label()
  ReturnValue(c_1f0)
end
