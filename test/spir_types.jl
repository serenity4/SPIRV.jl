using SPIRV, Test
using SPIRV: Constant, TypeMap, Translation, ModuleTarget, emit_constant!, ResultID, spir_type

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
end

@testset "Constants" begin
  mt = ModuleTarget()
  tr = Translation()
  value = (6.0, (3U, Int64(1)))
  id = emit_constant!(mt, tr, value)
  # 5 types and 5 elements (3 leaves and 2 composites) make up for 10 ids.
  @test length(mt.types) == length(mt.constants) == 5
  @test mt.idcounter[] === id === ResultID(10)
  c = mt.constants[id]
  @test c.type === spir_type(typeof(value), tr.tmap)
  @test c.value == ResultID[2, 8]
end;
