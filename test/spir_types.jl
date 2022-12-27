using SPIRV, Test
using SPIRV: Constant, TypeMap

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

@testset "TypeMap" begin
  tmap = TypeMap()
  t = spir_type(Tuple{Int,Int}, tmap)
  @test t === spir_type(Tuple{Int,Int}, tmap)
  pt = spir_type(Pointer{Tuple{Int,Int}}, tmap)
  @test t === pt.type
  @test_throws "Abstract types" spir_type(Ref{Tuple{Int,Int}}, tmap; wrap_mutable = true)
  pt = spir_type(Base.RefValue{Tuple{Int,Int}}, tmap; wrap_mutable = true)
  ref_t = pt.type
  @test t === only(ref_t.members)
  @test_throws "Bottom type" spir_type(Union{}, tmap)
end;
