F32 = TypeFloat(32)
U32 = TypeInt(32, false)
c_U32_2 = Constant(2U)::U32
ArrayF32_2 = TypeArray(F32, c_U32_2)
PtrF32 = TypePointer(SPIRV.StorageClassFunction, F32)
PtrArrayF32_2 = TypePointer(SPIRV.StorageClassFunction, ArrayF32_2)

@function f(arr::ArrayF32_2, index::U32)::F32 begin
  _ = Label()
  var = Variable(SPIRV.StorageClassFunction)::PtrArrayF32_2
  Store(var, arr)
  ptr = AccessChain(var, index)::PtrF32
  x = Load(ptr)::F32
  ReturnValue(x)
end
