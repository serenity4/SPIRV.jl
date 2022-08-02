using SPIRV, Test
using SPIRV: Constant

@testset "SPIR-V types" begin
  i32 = IntegerType(32, true)
  f64 = FloatType(64)
  i32_arr_4 = ArrayType(i32, Constant(4))
  t = StructType([i32, f64, i32_arr_4])
  t2 = StructType([i32, f64, i32_arr_4])
  @test t ≠ t2
  @test t ≈ t2
  t_ptr = PointerType(SPIRV.StorageClassFunction, t)
  t2_ptr = PointerType(SPIRV.StorageClassFunction, t2)
  @test t_ptr ≈ t2_ptr
end
