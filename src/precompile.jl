while true
  pmod = PhysicalModule(joinpath(dirname(@__DIR__), "test", "resources", "comp.spv"))
  ir = IR(Module(pmod))
  assemble(ir)

  #TODO: Precompile the following when it does not segfault during deserialization.

  # SUPPORTED_FEATURES = SupportedFeatures(
  #   [
  #     "SPV_KHR_vulkan_memory_model",
  #     "SPV_EXT_physical_storage_buffer",
  #   ],
  #   [
  #     CapabilityVulkanMemoryModel,
  #     CapabilityShader,
  #     CapabilityInt64,
  #     CapabilityPhysicalStorageBufferAddresses,
  #   ],
  # )

  # struct PRECOMPILE_DrawData
  #   camera::UInt64
  #   vbuffer::UInt64
  #   material::UInt64
  # end

  # struct PRECOMPILE_VertexData
  #   pos::Vec{2,Float32}
  #   color::NTuple{3,Float32}
  # end


  # function PRECOMPILE_vert_shader(frag_color, position, index, dd)
  #   vd = Pointer{Vector{PRECOMPILE_VertexData}}(dd.vbuffer)[index]
  #   (; pos, color) = vd
  #   position[] = Vec(pos.x, pos.y, 0F, 1F)
  #   frag_color[] = Vec(color[1U], color[2U], color[3U], 1F)
  # end

  # target = @target PRECOMPILE_vert_shader(::Vec{4,Float32}, ::Vec{4,Float32}, ::UInt32, ::PRECOMPILE_DrawData)
  # interface = ShaderInterface(
  #   storage_classes = [StorageClassOutput, StorageClassOutput, StorageClassInput, StorageClassPushConstant],
  #   variable_decorations = dictionary([
  #     1 => dictionary([DecorationLocation => [0U]]),
  #     2 => dictionary([DecorationBuiltIn => [BuiltInPosition]]),
  #     3 => dictionary([DecorationBuiltIn => [BuiltInVertexIndex]]),
  #   ]),
  #   type_metadata = dictionary([
  #     PRECOMPILE_DrawData => dictionary([DecorationBlock => []]),
  #   ]),
  #   features = SUPPORTED_FEATURES,
  # )
  # ir = make_shader(target, interface)
  # assemble(ir)
  break
end
