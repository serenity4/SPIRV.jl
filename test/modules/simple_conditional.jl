Bool = TypeBool()
Float32 = TypeFloat(32)
c_0f0 = Constant(0f0)::Float32
c_1f0 = Constant(1f0)::Float32

@function f(x::Bool)::Float32 begin
  b1 = Label()
  BranchConditional(x, b3, b2)

  b2 = Label()
  ReturnValue(c_1f0)

  b3 = Label()
  ReturnValue(c_0f0)
end
