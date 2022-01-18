using SPIRV, Test, Dictionaries
using SPIRV: emit!, spir_type!, PointerType
using SPIRV: StorageClassStorageBuffer, StorageClassUniform, StorageClassPhysicalStorageBuffer, StorageClassPushConstant, DecorationBlock, DecorationData

function test_has_offset(ir, T, field, offset)
  decs = ir.typerefs[T].member_decorations[field]
  @test haskey(decs, SPIRV.DecorationOffset)
  @test decs[SPIRV.DecorationOffset] == [offset]
end

function ir_with_offsets(T; alg = VulkanAlignment(), storage_classes = [], decorations = [])
  ir = IR()
  type = spir_type!(ir, T)
  emit!(ir, type)
  merge!(get!(DecorationData, ir.decorations, ir.types[type]), dictionary(decorations))
  for sc in storage_classes
    emit!(ir, PointerType(sc, type))
  end
  SPIRV.add_field_offsets!(ir, alg)
  ir
end

@testset "Alignment" begin
  struct Align1
    x::Int64
    y::Int64
  end
  ir = ir_with_offsets(Align1)
  test_has_offset(ir, Align1, 1, 0)
  test_has_offset(ir, Align1, 2, 8)

  struct Align2
    x::Int32
    y::Int64
  end

  ir = ir_with_offsets(Align2)
  test_has_offset(ir, Align2, 1, 0)
  test_has_offset(ir, Align2, 2, 8)

  struct Align3
    x::Int64
    y::Int32
    z::Int32
  end

  ir = ir_with_offsets(Align3)
  test_has_offset(ir, Align3, 1, 0)
  test_has_offset(ir, Align3, 2, 8)
  test_has_offset(ir, Align3, 3, 12)

  struct Align4
    x::Int64
    y::Int8
    z::SVec{Int16,2}
  end

  ir = ir_with_offsets(Align4)
  test_has_offset(ir, Align4, 1, 0)
  test_has_offset(ir, Align4, 2, 8)
  test_has_offset(ir, Align4, 3, 10)
  @test size(Align4, ir, VulkanAlignment()) == 14

  struct Align5
    x::Int64
    y::Align4
    z::Int8
  end

  ir = ir_with_offsets(Align5)
  test_has_offset(ir, Align5, 1, 0)
  test_has_offset(ir, Align5, 2, 8)
  test_has_offset(ir, Align5, 3, 22)
  @test size(Align5, ir, VulkanAlignment()) == 23

  ir = ir_with_offsets(Align5; storage_classes = [StorageClassUniform], decorations = [DecorationBlock => []])
  test_has_offset(ir, Align5, 1, 0)
  test_has_offset(ir, Align5, 2, 16)
  test_has_offset(ir, Align5, 3, 30)
  @test size(Align5, ir, VulkanAlignment()) == 31
end
