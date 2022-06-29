Int32 = TypeInt(32, 1)
Float32 = TypeFloat(32)
c_1f0 = Constant(1f0)::Float32

@function f(x::Int32, y::Int32)::Float32 begin
  b = Label()
  x_plus_y = IAdd(x, y)::Int32
  x_plus_y_float = ConvertSToF(x_plus_y)::Float32
  z = FAdd(x_plus_y_float, c_1f0)::Float32
  ReturnValue(z)
end
