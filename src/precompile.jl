@precompile_all_calls begin
  pmod = PhysicalModule(joinpath(dirname(@__DIR__), "test", "resources", "comp.spv"))
  ir = IR(Module(pmod))
  assemble(ir)

  SUPPORTED_FEATURES = SupportedFeatures(
    [
      "SPV_KHR_vulkan_memory_model",
      "SPV_EXT_physical_storage_buffer",
    ],
    [
      CapabilityVulkanMemoryModel,
      CapabilityShader,
      CapabilityInt64,
      CapabilityPhysicalStorageBufferAddresses,
    ],
  )

  @static if VERSION ≥ v"1.8"
    struct PRECOMPILE_DrawData
      camera::UInt64
      vbuffer::UInt64
      material::UInt64
    end

    struct PRECOMPILE_VertexData
      pos::Vec{2,Float32}
      color::NTuple{3,Float32}
    end

    function PRECOMPILE_vert_shader(frag_color, position, index, dd)
      vd = Pointer{Vector{PRECOMPILE_VertexData}}(dd.vbuffer)[index]
      (; pos, color) = vd
      position[] = Vec(pos.x, pos.y, 0F, 1F)
      frag_color[] = Vec(color[1U], color[2U], color[3U], 1F)
    end

    target = @target PRECOMPILE_vert_shader(::Vec{4,Float32}, ::Vec{4,Float32}, ::UInt32, ::PRECOMPILE_DrawData)
    interface = ShaderInterface(
      storage_classes = [StorageClassOutput, StorageClassOutput, StorageClassInput, StorageClassPushConstant],
      variable_decorations = dictionary([
        1 => Decorations(DecorationLocation, 0U),
        2 => Decorations(DecorationBuiltIn, BuiltInPosition),
        3 => Decorations(DecorationBuiltIn, BuiltInVertexIndex),
      ]),
      type_metadata = dictionary([
        PRECOMPILE_DrawData => Metadata().decorate!(DecorationBlock),
      ]),
      features = SUPPORTED_FEATURES,
    )
    ir = Shader(target, interface)
    assemble(ir)

    empty!(DEFAULT_CI_CACHE.dict)
    empty!(VULKAN_CI_CACHE.dict)
  end
end
