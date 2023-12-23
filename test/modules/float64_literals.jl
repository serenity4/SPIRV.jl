Float64 = TypeFloat(64)
cf4_65 = Constant(0x9999999a, 0x40129999)::Float64

@function f()::Float64 begin
  _ = Label()
  ReturnValue(cf4_65)
end
