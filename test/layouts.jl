using SPIRV, Test, Dictionaries
using SPIRV: emit!, spir_type, PointerType, add_type_layouts!, StorageClassStorageBuffer, StorageClassUniform, StorageClassPhysicalStorageBuffer, StorageClassPushConstant, DecorationBlock, DecorationData

function test_has_offset(ir, T, field, offset)
  decs = decorations(ir, T, field)
  @test has_decoration(decs, SPIRV.DecorationOffset)
  @test decs.offset == offset
end

function test_has_stride(ir, T, stride)
  decs = decorations(ir, T)
  @test !isnothing(decs)
  @test has_decoration(decs, SPIRV.DecorationArrayStride) || has_decoration(decs, SPIRV.DecorationMatrixStride)
  dec = has_decoration(decs, SPIRV.DecorationArrayStride) ? decs.array_stride : decs.matrix_stride
  @test dec == stride
end

function ir_with_type(T; storage_classes = [])
  ir = IR()
  type = spir_type(T, ir)
  emit!(ir, type)
  for sc in storage_classes
    emit!(ir, PointerType(sc, type))
  end
  ir
end

@testset "Structure layouts" begin
  layout = VulkanLayout()

  @testset "Alignments" begin
    struct Align1
      x::Int64
      y::Int64
    end

    ir = ir_with_type(Align1)
    add_type_layouts!(ir, layout)
    test_has_offset(ir, Align1, 1, 0)
    test_has_offset(ir, Align1, 2, 8)

    struct Align2
      x::Int32
      y::Int64
    end

    ir = ir_with_type(Align2)
    add_type_layouts!(ir, layout)
    test_has_offset(ir, Align2, 1, 0)
    test_has_offset(ir, Align2, 2, 8)

    struct Align3
      x::Int64
      y::Int32
      z::Int32
    end

    ir = ir_with_type(Align3)
    add_type_layouts!(ir, layout)
    test_has_offset(ir, Align3, 1, 0)
    test_has_offset(ir, Align3, 2, 8)
    test_has_offset(ir, Align3, 3, 12)

    struct Align4
      x::Int64
      y::Int8
      z::Vec{2,Int16}
    end

    ir = ir_with_type(Align4)
    add_type_layouts!(ir, layout)
    test_has_offset(ir, Align4, 1, 0)
    test_has_offset(ir, Align4, 2, 8)
    test_has_offset(ir, Align4, 3, 10)
    @test size(Align4, ir, VulkanLayout()) == 14

    struct Align5
      x::Int64
      y::Align4
      z::Int8
    end

    ir = ir_with_type(Align5)
    add_type_layouts!(ir, layout)
    test_has_offset(ir, Align5, 1, 0)
    test_has_offset(ir, Align5, 2, 8)
    test_has_offset(ir, Align5, 3, 22)
    @test size(Align5, ir, VulkanLayout()) == 23

    ir = ir_with_type(Align5; storage_classes = [StorageClassUniform])
    decorate!(ir, Align5, DecorationBlock)
    add_type_layouts!(ir, layout)
    test_has_offset(ir, Align5, 1, 0)
    test_has_offset(ir, Align5, 2, 16)
    test_has_offset(ir, Align5, 3, 30)
    @test size(Align5, ir, VulkanLayout()) == 31
  end

  @testset "Array/Matrix layouts" begin
    T = Arr{4, Tuple{Float64, Float64}}
    ir = ir_with_type(T)
    add_type_layouts!(ir, layout)
    test_has_stride(ir, T, 16)

    T = Mat{4, 4, Float64}
    ir = ir_with_type(T)
    add_type_layouts!(ir, layout)
    test_has_stride(ir, T, 8)
  end
end
