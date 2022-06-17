using SPIRV, Test, Dictionaries
using SPIRV: emit!, spir_type, PointerType
using SPIRV:
  StorageClassStorageBuffer, StorageClassUniform, StorageClassPhysicalStorageBuffer, StorageClassPushConstant, DecorationBlock, DecorationData

function test_has_offset(ir, T, field, offset)
  decs = ir.typerefs[T].member_decorations[field]
  @test haskey(decs, SPIRV.DecorationOffset)
  @test only(decs[SPIRV.DecorationOffset]) === UInt32(offset)
end

function test_has_stride(ir, T, stride)
  decs = get(DecorationData, ir.decorations, ir.types[ir.typerefs[T]])
  dec = something(get(decs, SPIRV.DecorationArrayStride, nothing), get(decs, SPIRV.DecorationMatrixStride, nothing), Some(nothing))
  @test !isnothing(dec)
  @test only(dec) === UInt32(stride)
end

function ir_with_layouts(T; layout = VulkanLayout(), storage_classes = [], decorations = [])
  ir = IR()
  type = spir_type(T, ir)
  emit!(ir, type)
  merge!(get!(DecorationData, ir.decorations, ir.types[type]), dictionary(decorations))
  for sc in storage_classes
    emit!(ir, PointerType(sc, type))
  end
  SPIRV.add_type_layouts!(ir, layout)
  ir
end

@testset "Structure layouts" begin
  @testset "Alignments" begin
    struct Align1
      x::Int64
      y::Int64
    end

    ir = ir_with_layouts(Align1)
    test_has_offset(ir, Align1, 1, 0)
    test_has_offset(ir, Align1, 2, 8)

    struct Align2
      x::Int32
      y::Int64
    end

    ir = ir_with_layouts(Align2)
    test_has_offset(ir, Align2, 1, 0)
    test_has_offset(ir, Align2, 2, 8)

    struct Align3
      x::Int64
      y::Int32
      z::Int32
    end

    ir = ir_with_layouts(Align3)
    test_has_offset(ir, Align3, 1, 0)
    test_has_offset(ir, Align3, 2, 8)
    test_has_offset(ir, Align3, 3, 12)

    struct Align4
      x::Int64
      y::Int8
      z::Vec{2,Int16}
    end

    ir = ir_with_layouts(Align4)
    test_has_offset(ir, Align4, 1, 0)
    test_has_offset(ir, Align4, 2, 8)
    test_has_offset(ir, Align4, 3, 10)
    @test size(Align4, ir, VulkanLayout()) == 14

    struct Align5
      x::Int64
      y::Align4
      z::Int8
    end

    ir = ir_with_layouts(Align5)
    test_has_offset(ir, Align5, 1, 0)
    test_has_offset(ir, Align5, 2, 8)
    test_has_offset(ir, Align5, 3, 22)
    @test size(Align5, ir, VulkanLayout()) == 23

    ir = ir_with_layouts(Align5; storage_classes = [StorageClassUniform], decorations = [DecorationBlock => []])
    test_has_offset(ir, Align5, 1, 0)
    test_has_offset(ir, Align5, 2, 16)
    test_has_offset(ir, Align5, 3, 30)
    @test size(Align5, ir, VulkanLayout()) == 31
  end

  @testset "Array/Matrix layouts" begin
    T = Arr{4, Tuple{Float64, Float64}}
    ir = ir_with_layouts(T)
    test_has_stride(ir, T, 16)

    T = Mat{4, 4, Float64}
    ir = ir_with_layouts(T)
    test_has_stride(ir, T, 8)
  end
end
