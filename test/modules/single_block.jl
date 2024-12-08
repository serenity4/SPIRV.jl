Capability(SPIRV.CapabilityInt16)
Int16 = TypeInt(16, true)
Float16 = TypeFloat(16)
c_1f0 = Constant(Float16(1))::Float16

@function f(x::Int16, y::Int16)::Float16 begin
  b = Label()
  x_plus_y = IAdd(x, y)::Int16
  x_plus_y_float = ConvertSToF(x_plus_y)::Float16
  z = FAdd(x_plus_y_float, c_1f0)::Float16
  ReturnValue(z)
end
