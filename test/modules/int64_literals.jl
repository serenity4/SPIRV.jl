Int64 = TypeInt(64, true)
c1 = Constant(0x00000001, 0x00000000)::Int64

@function f()::Int64 begin
  _ = Label()
  ReturnValue(c1)
end
