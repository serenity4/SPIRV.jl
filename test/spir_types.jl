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

@enum TestEnum::UInt32 TEST_A = 1 TEST_B = 2
primitive type TestPrimitiveTypeAllowed 32 end
SPIRV.primitive_type_to_spirv(::Type{TestPrimitiveTypeAllowed}) = UInt32
primitive type TestPrimitiveTypeDisallowed 32 end

@testset "Mapping Julia types to SPIR-V types" begin
  tmap = TypeMap()

  @testset "Tuples" begin
    # 1-element tuples are treated as structs.
    @test isa(spir_type(Tuple{Int64}, tmap), StructType)

    # Heterogeneous tuples are treated as structs.
    t = spir_type(Tuple{Int64,Float64}, tmap)
    @test isa(t, StructType)
    @test t === spir_type(Tuple{Int64,Float64}, tmap)

    # Homogeneous tuples are treated as arrays.
    @test spir_type(Tuple{Int64,Int64}, tmap) == ArrayType(IntegerType(64, true), Constant(2U))
  end

  @testset "Pointers" begin
    t = spir_type(Tuple{Int64,Float64}, tmap)
    pt = spir_type(Pointer{Tuple{Int64,Float64}}, tmap)
    @test pt.type === t

    # Mutable objects will give immutable SPIR-V types, unless `wrap_mutable` is set to true,
    # in which case a pointer type (which is the only way to express mutability in SPIR-V) will be returned.
    rt = spir_type(Base.RefValue{Tuple{Int64,Float64}}, tmap)
    @test isa(rt, StructType)
    @test rt.members == [t]
    @test rt.members[1] === t
    pt = spir_type(Base.RefValue{Tuple{Int64,Float64}}, tmap; wrap_mutable = true)
    @test isa(pt, PointerType)
    @test pt.type === rt
  end

  @testset "Primitive types" begin
    @test spir_type(TestEnum) == IntegerType(32, false)
    @test spir_type(TestPrimitiveTypeAllowed) == IntegerType(32, false)
  end

  @test spir_type(Union{}, tmap) == OpaqueType(Symbol("Union{}"))

  @testset "Disallowed types" begin
    @test_throws "Abstract types" spir_type(Ref{Tuple{Int64,Float64}}, tmap)
    @test_throws "Non-concrete types" spir_type(NTuple{3}, tmap)
    @test_throws "Primitive type" spir_type(TestPrimitiveTypeDisallowed, tmap)
    @test_throws "unions are not supported" spir_type(Union{Int64,Float64}, tmap)
  end
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
