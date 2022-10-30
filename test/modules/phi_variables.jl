Float32 = TypeFloat(32)
Ptr_Float32 = TypePointer(SPIRV.StorageClassFunction, Float32)
Nothing = TypeVoid()
one = Constant(1f0)::Float32
Bool = TypeBool()
@function f()::Nothing begin
  b1 = Label()
  v1 = Variable(SPIRV.StorageClassFunction)::Ptr_Float32
  v2 = Variable(SPIRV.StorageClassFunction)::Ptr_Float32
  two = FAdd(one, one)::Float32
  Store(v1, one)
  Store(v2, one)
  v2_val = Load(v2)::Float32
  cond = FOrdLessThan(v2_val, one)::Bool
  SelectionMerge(b3, SPIRV.SelectionControlNone)
  BranchConditional(cond, b2, b3)
  b2 = Label()
  Branch(b3)
  b3 = Label()
  res = Phi(v1, b1, v2, b2)::Ptr_Float32
  res2 = Load(res)::Float32
  Return()
end
