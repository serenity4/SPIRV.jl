Float32 = TypeFloat(32)
PtrFloat32 = TypePointer(SPIRV.StorageClassFunction, Float32)
@function f(ptr::PtrFloat32)::Float32 begin
  _ = Label()
  value = Load(ptr, SPIRV.MemoryAccessAligned, 0x00000008)::Float32
  ReturnValue(value)
end
