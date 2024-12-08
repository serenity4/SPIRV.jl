Int32 = TypeInt(32, true)
Float32 = TypeFloat(32)
c_1f0 = Constant(1f0)::Float32

@function f(x::Int32, y::Int32)::Float32 begin
  b = Label()
  x_plus_y = IAdd(x, y)::Int32
  x_plus_y_minus_y = FunctionCall(sub, x, y)::Int32
  x_float = ConvertSToF(x_plus_y_minus_y)::Float32
  z = FAdd(x_float, c_1f0)::Float32
  ReturnValue(z)
end

@function sub(x::Int32, y::Int32)::Int32 begin
  b = Label()
  z = ISub(x, y)::Int32
  ReturnValue(z)
end
