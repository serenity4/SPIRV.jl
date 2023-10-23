const enum_infos = EnumInfos(
  Dict(
    ImageOperands => EnumInfo(
      ImageOperands,
      Dict(
        ImageOperandsNone * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        ImageOperandsBias * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), [OperandInfo(IdRef, nothing, nothing)]),
        ImageOperandsLod * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), [OperandInfo(IdRef, nothing, nothing)]),
        ImageOperandsGrad * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
          [OperandInfo(IdRef, nothing, nothing), OperandInfo(IdRef, nothing, nothing)],
        ),
        ImageOperandsConstOffset * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), [OperandInfo(IdRef, nothing, nothing)]),
        ImageOperandsOffset * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityImageGatherExtended]),
          [OperandInfo(IdRef, nothing, nothing)],
        ),
        ImageOperandsConstOffsets * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityImageGatherExtended]),
          [OperandInfo(IdRef, nothing, nothing)],
        ),
        ImageOperandsSample * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), [OperandInfo(IdRef, nothing, nothing)]),
        ImageOperandsMinLod * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMinLod]), [OperandInfo(IdRef, nothing, nothing)]),
        ImageOperandsMakeTexelAvailableKHR * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityVulkanMemoryModel]),
          [OperandInfo(IdScope, nothing, nothing)],
        ),
        ImageOperandsMakeTexelVisibleKHR * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityVulkanMemoryModel]),
          [OperandInfo(IdScope, nothing, nothing)],
        ),
        ImageOperandsNonPrivateTexelKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityVulkanMemoryModel]), []),
        ImageOperandsVolatileTexelKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityVulkanMemoryModel]), []),
        ImageOperandsSignExtend * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, nothing), []),
        ImageOperandsZeroExtend * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, nothing), []),
        ImageOperandsNontemporal * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, nothing), []),
        ImageOperandsOffsets * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), [OperandInfo(IdRef, nothing, nothing)]),
      ),
    ),
    FPFastMathMode => EnumInfo(
      FPFastMathMode,
      Dict(
        FPFastMathModeNone * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FPFastMathModeNotNaN * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FPFastMathModeNotInf * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FPFastMathModeNSZ * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FPFastMathModeAllowRecip * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FPFastMathModeFast * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FPFastMathModeAllowContractFastINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPFastMathModeINTEL]), []),
        FPFastMathModeAllowReassocINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPFastMathModeINTEL]), []),
      ),
    ),
    SelectionControl => EnumInfo(
      SelectionControl,
      Dict(
        SelectionControlNone * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        SelectionControlFlatten * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        SelectionControlDontFlatten * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
      ),
    ),
    LoopControl => EnumInfo(
      LoopControl,
      Dict(
        LoopControlNone * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        LoopControlUnroll * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        LoopControlDontUnroll * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        LoopControlDependencyInfinite * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, nothing), []),
        LoopControlDependencyLength * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, nothing), [OperandInfo(LiteralInteger, nothing, nothing)]),
        LoopControlMinIterations * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, nothing), [OperandInfo(LiteralInteger, nothing, nothing)]),
        LoopControlMaxIterations * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, nothing), [OperandInfo(LiteralInteger, nothing, nothing)]),
        LoopControlIterationMultiple * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, nothing), [OperandInfo(LiteralInteger, nothing, nothing)]),
        LoopControlPeelCount * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, nothing), [OperandInfo(LiteralInteger, nothing, nothing)]),
        LoopControlPartialCount * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, nothing), [OperandInfo(LiteralInteger, nothing, nothing)]),
        LoopControlInitiationIntervalINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGALoopControlsINTEL]),
          [OperandInfo(LiteralInteger, nothing, nothing)],
        ),
        LoopControlMaxConcurrencyINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGALoopControlsINTEL]),
          [OperandInfo(LiteralInteger, nothing, nothing)],
        ),
        LoopControlDependencyArrayINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGALoopControlsINTEL]),
          [OperandInfo(LiteralInteger, nothing, nothing)],
        ),
        LoopControlPipelineEnableINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGALoopControlsINTEL]),
          [OperandInfo(LiteralInteger, nothing, nothing)],
        ),
        LoopControlLoopCoalesceINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGALoopControlsINTEL]),
          [OperandInfo(LiteralInteger, nothing, nothing)],
        ),
        LoopControlMaxInterleavingINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGALoopControlsINTEL]),
          [OperandInfo(LiteralInteger, nothing, nothing)],
        ),
        LoopControlSpeculatedIterationsINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGALoopControlsINTEL]),
          [OperandInfo(LiteralInteger, nothing, nothing)],
        ),
        LoopControlNoFusionINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGALoopControlsINTEL]), []),
        LoopControlLoopCountINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGALoopControlsINTEL]),
          [OperandInfo(LiteralInteger, nothing, nothing)],
        ),
        LoopControlMaxReinvocationDelayINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGALoopControlsINTEL]),
          [OperandInfo(LiteralInteger, nothing, nothing)],
        ),
      ),
    ),
    FunctionControl => EnumInfo(
      FunctionControl,
      Dict(
        FunctionControlNone * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FunctionControlInline * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FunctionControlDontInline * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FunctionControlPure * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FunctionControlConst * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FunctionControlOptNoneINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityOptNoneINTEL]), []),
      ),
    ),
    MemorySemantics => EnumInfo(
      MemorySemantics,
      Dict(
        MemorySemanticsNone * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        MemorySemanticsAcquire * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        MemorySemanticsRelease * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        MemorySemanticsAcquireRelease * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        MemorySemanticsSequentiallyConsistent * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        MemorySemanticsUniformMemory * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        MemorySemanticsSubgroupMemory * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        MemorySemanticsWorkgroupMemory * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        MemorySemanticsCrossWorkgroupMemory * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        MemorySemanticsAtomicCounterMemory * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAtomicStorage]), []),
        MemorySemanticsImageMemory * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        MemorySemanticsOutputMemoryKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityVulkanMemoryModel]), []),
        MemorySemanticsMakeAvailableKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityVulkanMemoryModel]), []),
        MemorySemanticsMakeVisibleKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityVulkanMemoryModel]), []),
        MemorySemanticsVolatile * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), ["SPV_KHR_vulkan_memory_model"], [CapabilityVulkanMemoryModel]), []),
      ),
    ),
    MemoryAccess => EnumInfo(
      MemoryAccess,
      Dict(
        MemoryAccessNone * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        MemoryAccessVolatile * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        MemoryAccessAligned * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), [OperandInfo(LiteralInteger, nothing, nothing)]),
        MemoryAccessNontemporal * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        MemoryAccessMakePointerAvailableKHR * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityVulkanMemoryModel]),
          [OperandInfo(IdScope, nothing, nothing)],
        ),
        MemoryAccessMakePointerVisibleKHR * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityVulkanMemoryModel]),
          [OperandInfo(IdScope, nothing, nothing)],
        ),
        MemoryAccessNonPrivatePointerKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityVulkanMemoryModel]), []),
        MemoryAccessAliasScopeINTELMask * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_memory_access_aliasing"], [CapabilityMemoryAccessAliasingINTEL]),
          [OperandInfo(IdRef, nothing, nothing)],
        ),
        MemoryAccessNoAliasINTELMask * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_memory_access_aliasing"], [CapabilityMemoryAccessAliasingINTEL]),
          [OperandInfo(IdRef, nothing, nothing)],
        ),
      ),
    ),
    KernelProfilingInfo => EnumInfo(
      KernelProfilingInfo,
      Dict(
        KernelProfilingInfoNone * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        KernelProfilingInfoCmdExecTime * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
      ),
    ),
    RayFlags => EnumInfo(
      RayFlags,
      Dict(
        RayFlagsNoneKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR, CapabilityRayTracingKHR]), []),
        RayFlagsOpaqueKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR, CapabilityRayTracingKHR]), []),
        RayFlagsNoOpaqueKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR, CapabilityRayTracingKHR]), []),
        RayFlagsTerminateOnFirstHitKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR, CapabilityRayTracingKHR]), []),
        RayFlagsSkipClosestHitShaderKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR, CapabilityRayTracingKHR]), []),
        RayFlagsCullBackFacingTrianglesKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR, CapabilityRayTracingKHR]), []),
        RayFlagsCullFrontFacingTrianglesKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR, CapabilityRayTracingKHR]), []),
        RayFlagsCullOpaqueKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR, CapabilityRayTracingKHR]), []),
        RayFlagsCullNoOpaqueKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR, CapabilityRayTracingKHR]), []),
        RayFlagsSkipTrianglesKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayTraversalPrimitiveCullingKHR]), []),
        RayFlagsSkipAABBsKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayTraversalPrimitiveCullingKHR]), []),
        RayFlagsForceOpacityMicromap2StateEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayTracingOpacityMicromapEXT]), []),
      ),
    ),
    FragmentShadingRate => EnumInfo(
      FragmentShadingRate,
      Dict(
        FragmentShadingRateVertical2Pixels * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFragmentShadingRateKHR]), []),
        FragmentShadingRateVertical4Pixels * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFragmentShadingRateKHR]), []),
        FragmentShadingRateHorizontal2Pixels * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFragmentShadingRateKHR]), []),
        FragmentShadingRateHorizontal4Pixels * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFragmentShadingRateKHR]), []),
      ),
    ),
    SourceLanguage => EnumInfo(
      SourceLanguage,
      Dict(
        SourceLanguageUnknown * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        SourceLanguageESSL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        SourceLanguageGLSL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        SourceLanguageOpenCL_C * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        SourceLanguageOpenCL_CPP * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        SourceLanguageHLSL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        SourceLanguageCPP_for_OpenCL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        SourceLanguageSYCL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
      ),
    ),
    ExecutionModel => EnumInfo(
      ExecutionModel,
      Dict(
        ExecutionModelVertex * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ExecutionModelTessellationControl * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        ExecutionModelTessellationEvaluation * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        ExecutionModelGeometry * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry]), []),
        ExecutionModelFragment * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ExecutionModelGLCompute * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ExecutionModelKernel * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ExecutionModelTaskNV * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMeshShadingNV]), []),
        ExecutionModelMeshNV * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMeshShadingNV]), []),
        ExecutionModelRayGenerationKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayTracingNV, CapabilityRayTracingKHR]), []),
        ExecutionModelIntersectionKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayTracingNV, CapabilityRayTracingKHR]), []),
        ExecutionModelAnyHitKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayTracingNV, CapabilityRayTracingKHR]), []),
        ExecutionModelClosestHitKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayTracingNV, CapabilityRayTracingKHR]), []),
        ExecutionModelMissKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayTracingNV, CapabilityRayTracingKHR]), []),
        ExecutionModelCallableKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayTracingNV, CapabilityRayTracingKHR]), []),
        ExecutionModelTaskEXT * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMeshShadingEXT]), []),
        ExecutionModelMeshEXT * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMeshShadingEXT]), []),
      ),
    ),
    AddressingModel => EnumInfo(
      AddressingModel,
      Dict(
        AddressingModelLogical * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        AddressingModelPhysical32 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAddresses]), []),
        AddressingModelPhysical64 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAddresses]), []),
        AddressingModelPhysicalStorageBuffer64EXT * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"1.5.0", v"∞"),
            ["SPV_EXT_physical_storage_buffer", "SPV_KHR_physical_storage_buffer"],
            [CapabilityPhysicalStorageBufferAddresses],
          ),
          [],
        ),
      ),
    ),
    MemoryModel => EnumInfo(
      MemoryModel,
      Dict(
        MemoryModelSimple * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        MemoryModelGLSL450 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        MemoryModelOpenCL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        MemoryModelVulkanKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityVulkanMemoryModel]), []),
      ),
    ),
    ExecutionMode => EnumInfo(
      ExecutionMode,
      Dict(
        ExecutionModeInvocations * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry]),
          [OperandInfo(LiteralInteger, "'Number of <<Invocation,invocations>>'", nothing)],
        ),
        ExecutionModeSpacingEqual * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        ExecutionModeSpacingFractionalEven * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        ExecutionModeSpacingFractionalOdd * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        ExecutionModeVertexOrderCw * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        ExecutionModeVertexOrderCcw * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        ExecutionModePixelCenterInteger * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ExecutionModeOriginUpperLeft * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ExecutionModeOriginLowerLeft * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ExecutionModeEarlyFragmentTests * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ExecutionModePointMode * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        ExecutionModeXfb * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTransformFeedback]), []),
        ExecutionModeDepthReplacing * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ExecutionModeDepthGreater * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ExecutionModeDepthLess * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ExecutionModeDepthUnchanged * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ExecutionModeLocalSize * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
          [
            OperandInfo(LiteralInteger, "'x size'", nothing),
            OperandInfo(LiteralInteger, "'y size'", nothing),
            OperandInfo(LiteralInteger, "'z size'", nothing),
          ],
        ),
        ExecutionModeLocalSizeHint * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
          [
            OperandInfo(LiteralInteger, "'x size'", nothing),
            OperandInfo(LiteralInteger, "'y size'", nothing),
            OperandInfo(LiteralInteger, "'z size'", nothing),
          ],
        ),
        ExecutionModeInputPoints * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry]), []),
        ExecutionModeInputLines * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry]), []),
        ExecutionModeInputLinesAdjacency * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry]), []),
        ExecutionModeTriangles * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry, CapabilityTessellation]), []),
        ExecutionModeInputTrianglesAdjacency * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry]), []),
        ExecutionModeQuads * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        ExecutionModeIsolines * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        ExecutionModeOutputVertices * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            nothing,
            [CapabilityGeometry, CapabilityTessellation, CapabilityMeshShadingNV, CapabilityMeshShadingEXT],
          ),
          [OperandInfo(LiteralInteger, "'Vertex count'", nothing)],
        ),
        ExecutionModeOutputPoints * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry, CapabilityMeshShadingNV, CapabilityMeshShadingEXT]),
          [],
        ),
        ExecutionModeOutputLineStrip * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry]), []),
        ExecutionModeOutputTriangleStrip * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry]), []),
        ExecutionModeVecTypeHint * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
          [OperandInfo(LiteralInteger, "'Vector type'", nothing)],
        ),
        ExecutionModeContractionOff * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ExecutionModeInitializer * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityKernel]), []),
        ExecutionModeFinalizer * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityKernel]), []),
        ExecutionModeSubgroupSize * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilitySubgroupDispatch]),
          [OperandInfo(LiteralInteger, "'Subgroup Size'", nothing)],
        ),
        ExecutionModeSubgroupsPerWorkgroup * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilitySubgroupDispatch]),
          [OperandInfo(LiteralInteger, "'Subgroups Per Workgroup'", nothing)],
        ),
        ExecutionModeSubgroupsPerWorkgroupId * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.2.0", v"∞"), nothing, [CapabilitySubgroupDispatch]),
          [OperandInfo(IdRef, "'Subgroups Per Workgroup'", nothing)],
        ),
        ExecutionModeLocalSizeId * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.2.0", v"∞"), nothing, nothing),
          [OperandInfo(IdRef, "'x size'", nothing), OperandInfo(IdRef, "'y size'", nothing), OperandInfo(IdRef, "'z size'", nothing)],
        ),
        ExecutionModeLocalSizeHintId * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.2.0", v"∞"), nothing, [CapabilityKernel]),
          [OperandInfo(IdRef, "'x size hint'", nothing), OperandInfo(IdRef, "'y size hint'", nothing), OperandInfo(IdRef, "'z size hint'", nothing)],
        ),
        ExecutionModeSubgroupUniformControlFlowKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_subgroup_uniform_control_flow"], [CapabilityShader]), []),
        ExecutionModePostDepthCoverage * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_post_depth_coverage"], [CapabilitySampleMaskPostDepthCoverage]),
          [],
        ),
        ExecutionModeDenormPreserve * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_KHR_float_controls"], [CapabilityDenormPreserve]),
          [OperandInfo(LiteralInteger, "'Target Width'", nothing)],
        ),
        ExecutionModeDenormFlushToZero * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_KHR_float_controls"], [CapabilityDenormFlushToZero]),
          [OperandInfo(LiteralInteger, "'Target Width'", nothing)],
        ),
        ExecutionModeSignedZeroInfNanPreserve * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_KHR_float_controls"], [CapabilitySignedZeroInfNanPreserve]),
          [OperandInfo(LiteralInteger, "'Target Width'", nothing)],
        ),
        ExecutionModeRoundingModeRTE * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_KHR_float_controls"], [CapabilityRoundingModeRTE]),
          [OperandInfo(LiteralInteger, "'Target Width'", nothing)],
        ),
        ExecutionModeRoundingModeRTZ * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_KHR_float_controls"], [CapabilityRoundingModeRTZ]),
          [OperandInfo(LiteralInteger, "'Target Width'", nothing)],
        ),
        ExecutionModeEarlyAndLateFragmentTestsAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_early_and_late_fragment_tests"], [CapabilityShader]), []),
        ExecutionModeStencilRefReplacingEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_shader_stencil_export"], [CapabilityStencilExportEXT]), []),
        ExecutionModeStencilRefUnchangedFrontAMD * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_AMD_shader_early_and_late_fragment_tests", "SPV_EXT_shader_stencil_export"],
            [CapabilityStencilExportEXT],
          ),
          [],
        ),
        ExecutionModeStencilRefGreaterFrontAMD * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_AMD_shader_early_and_late_fragment_tests", "SPV_EXT_shader_stencil_export"],
            [CapabilityStencilExportEXT],
          ),
          [],
        ),
        ExecutionModeStencilRefLessFrontAMD * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_AMD_shader_early_and_late_fragment_tests", "SPV_EXT_shader_stencil_export"],
            [CapabilityStencilExportEXT],
          ),
          [],
        ),
        ExecutionModeStencilRefUnchangedBackAMD * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_AMD_shader_early_and_late_fragment_tests", "SPV_EXT_shader_stencil_export"],
            [CapabilityStencilExportEXT],
          ),
          [],
        ),
        ExecutionModeStencilRefGreaterBackAMD * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_AMD_shader_early_and_late_fragment_tests", "SPV_EXT_shader_stencil_export"],
            [CapabilityStencilExportEXT],
          ),
          [],
        ),
        ExecutionModeStencilRefLessBackAMD * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_AMD_shader_early_and_late_fragment_tests", "SPV_EXT_shader_stencil_export"],
            [CapabilityStencilExportEXT],
          ),
          [],
        ),
        ExecutionModeOutputLinesEXT * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_mesh_shader", "SPV_EXT_mesh_shader"],
            [CapabilityMeshShadingNV, CapabilityMeshShadingEXT],
          ),
          [],
        ),
        ExecutionModeOutputPrimitivesEXT * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_mesh_shader", "SPV_EXT_mesh_shader"],
            [CapabilityMeshShadingNV, CapabilityMeshShadingEXT],
          ),
          [OperandInfo(LiteralInteger, "'Primitive count'", nothing)],
        ),
        ExecutionModeDerivativeGroupQuadsNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_compute_shader_derivatives"], [CapabilityComputeDerivativeGroupQuadsNV]),
          [],
        ),
        ExecutionModeDerivativeGroupLinearNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_compute_shader_derivatives"], [CapabilityComputeDerivativeGroupLinearNV]),
          [],
        ),
        ExecutionModeOutputTrianglesEXT * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_mesh_shader", "SPV_EXT_mesh_shader"],
            [CapabilityMeshShadingNV, CapabilityMeshShadingEXT],
          ),
          [],
        ),
        ExecutionModePixelInterlockOrderedEXT * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_fragment_shader_interlock"], [CapabilityFragmentShaderPixelInterlockEXT]),
          [],
        ),
        ExecutionModePixelInterlockUnorderedEXT * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_fragment_shader_interlock"], [CapabilityFragmentShaderPixelInterlockEXT]),
          [],
        ),
        ExecutionModeSampleInterlockOrderedEXT * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_fragment_shader_interlock"], [CapabilityFragmentShaderSampleInterlockEXT]),
          [],
        ),
        ExecutionModeSampleInterlockUnorderedEXT * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_fragment_shader_interlock"], [CapabilityFragmentShaderSampleInterlockEXT]),
          [],
        ),
        ExecutionModeShadingRateInterlockOrderedEXT * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_fragment_shader_interlock"], [CapabilityFragmentShaderShadingRateInterlockEXT]),
          [],
        ),
        ExecutionModeShadingRateInterlockUnorderedEXT * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_fragment_shader_interlock"], [CapabilityFragmentShaderShadingRateInterlockEXT]),
          [],
        ),
        ExecutionModeSharedLocalMemorySizeINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVectorComputeINTEL]),
          [OperandInfo(LiteralInteger, "'Size'", nothing)],
        ),
        ExecutionModeRoundingModeRTPINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRoundToInfinityINTEL]),
          [OperandInfo(LiteralInteger, "'Target Width'", nothing)],
        ),
        ExecutionModeRoundingModeRTNINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRoundToInfinityINTEL]),
          [OperandInfo(LiteralInteger, "'Target Width'", nothing)],
        ),
        ExecutionModeFloatingPointModeALTINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRoundToInfinityINTEL]),
          [OperandInfo(LiteralInteger, "'Target Width'", nothing)],
        ),
        ExecutionModeFloatingPointModeIEEEINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRoundToInfinityINTEL]),
          [OperandInfo(LiteralInteger, "'Target Width'", nothing)],
        ),
        ExecutionModeMaxWorkgroupSizeINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_kernel_attributes"], [CapabilityKernelAttributesINTEL]),
          [
            OperandInfo(LiteralInteger, "'max_x_size'", nothing),
            OperandInfo(LiteralInteger, "'max_y_size'", nothing),
            OperandInfo(LiteralInteger, "'max_z_size'", nothing),
          ],
        ),
        ExecutionModeMaxWorkDimINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_kernel_attributes"], [CapabilityKernelAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'max_dimensions'", nothing)],
        ),
        ExecutionModeNoGlobalOffsetINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_kernel_attributes"], [CapabilityKernelAttributesINTEL]), []),
        ExecutionModeNumSIMDWorkitemsINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_kernel_attributes"], [CapabilityFPGAKernelAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'vector_width'", nothing)],
        ),
        ExecutionModeSchedulerTargetFmaxMhzINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAKernelAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'target_fmax'", nothing)],
        ),
        ExecutionModeStreamingInterfaceINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAKernelAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'StallFreeReturn'", nothing)],
        ),
        ExecutionModeNamedBarrierCountINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVectorComputeINTEL]),
          [OperandInfo(LiteralInteger, "'Barrier Count'", nothing)],
        ),
      ),
    ),
    StorageClass => EnumInfo(
      StorageClass,
      Dict(
        StorageClassUniformConstant * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        StorageClassInput * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        StorageClassUniform * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        StorageClassOutput * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        StorageClassWorkgroup * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        StorageClassCrossWorkgroup * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        StorageClassPrivate * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader, CapabilityVectorComputeINTEL]), []),
        StorageClassFunction * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        StorageClassGeneric * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGenericPointer]), []),
        StorageClassPushConstant * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        StorageClassAtomicCounter * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAtomicStorage]), []),
        StorageClassImage * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        StorageClassStorageBuffer * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_storage_buffer_storage_class", "SPV_KHR_variable_pointers"], [CapabilityShader]),
          [],
        ),
        StorageClassCallableDataKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        StorageClassIncomingCallableDataKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        StorageClassRayPayloadKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        StorageClassHitAttributeKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        StorageClassIncomingRayPayloadKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        StorageClassShaderRecordBufferKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        StorageClassPhysicalStorageBufferEXT * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"1.5.0", v"∞"),
            ["SPV_EXT_physical_storage_buffer", "SPV_KHR_physical_storage_buffer"],
            [CapabilityPhysicalStorageBufferAddresses],
          ),
          [],
        ),
        StorageClassHitObjectAttributeNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]), []),
        StorageClassTaskPayloadWorkgroupEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_EXT_mesh_shader"], [CapabilityMeshShadingEXT]), []),
        StorageClassCodeSectionINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_function_pointers"], [CapabilityFunctionPointersINTEL]), []),
        StorageClassDeviceOnlyINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_usm_storage_classes"], [CapabilityUSMStorageClassesINTEL]), []),
        StorageClassHostOnlyINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_usm_storage_classes"], [CapabilityUSMStorageClassesINTEL]), []),
      ),
    ),
    Dim => EnumInfo(
      Dim,
      Dict(
        Dim1D * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySampled1D, CapabilityImage1D]), []),
        Dim2D * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader, CapabilityKernel, CapabilityImageMSArray]), []),
        Dim3D * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        DimCube * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader, CapabilityImageCubeArray]), []),
        DimRect * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySampledRect, CapabilityImageRect]), []),
        DimBuffer * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySampledBuffer, CapabilityImageBuffer]), []),
        DimSubpassData * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityInputAttachment]), []),
      ),
    ),
    SamplerAddressingMode => EnumInfo(
      SamplerAddressingMode,
      Dict(
        SamplerAddressingModeNone * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        SamplerAddressingModeClampToEdge * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        SamplerAddressingModeClamp * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        SamplerAddressingModeRepeat * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        SamplerAddressingModeRepeatMirrored * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
      ),
    ),
    SamplerFilterMode => EnumInfo(
      SamplerFilterMode,
      Dict(
        SamplerFilterModeNearest * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        SamplerFilterModeLinear * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
      ),
    ),
    ImageFormat => EnumInfo(
      ImageFormat,
      Dict(
        ImageFormatUnknown * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        ImageFormatRgba32f * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatRgba16f * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatR32f * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatRgba8 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatRgba8Snorm * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatRg32f * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRg16f * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatR11fG11fB10f * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatR16f * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRgba16 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRgb10A2 * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRg16 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRg8 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatR16 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatR8 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRgba16Snorm * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRg16Snorm * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRg8Snorm * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatR16Snorm * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatR8Snorm * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRgba32i * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatRgba16i * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatRgba8i * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatR32i * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatRg32i * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRg16i * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRg8i * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatR16i * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatR8i * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRgba32ui * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatRgba16ui * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatRgba8ui * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatR32ui * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        ImageFormatRgb10a2ui * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRg32ui * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRg16ui * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatRg8ui * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatR16ui * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatR8ui * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityStorageImageExtendedFormats]), []),
        ImageFormatR64ui * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityInt64ImageEXT]), []),
        ImageFormatR64i * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityInt64ImageEXT]), []),
      ),
    ),
    ImageChannelOrder => EnumInfo(
      ImageChannelOrder,
      Dict(
        ImageChannelOrderR * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderA * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderRG * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderRA * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderRGB * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderRGBA * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderBGRA * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderARGB * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderIntensity * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderLuminance * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderRx * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderRGx * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderRGBx * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderDepth * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderDepthStencil * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrdersRGB * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrdersRGBx * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrdersRGBA * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrdersBGRA * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelOrderABGR * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
      ),
    ),
    ImageChannelDataType => EnumInfo(
      ImageChannelDataType,
      Dict(
        ImageChannelDataTypeSnormInt8 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeSnormInt16 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeUnormInt8 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeUnormInt16 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeUnormShort565 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeUnormShort555 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeUnormInt101010 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeSignedInt8 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeSignedInt16 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeSignedInt32 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeUnsignedInt8 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeUnsignedInt16 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeUnsignedInt32 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeHalfFloat * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeFloat * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeUnormInt24 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        ImageChannelDataTypeUnormInt101010_2 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
      ),
    ),
    FPRoundingMode => EnumInfo(
      FPRoundingMode,
      Dict(
        FPRoundingModeRTE * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FPRoundingModeRTZ * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FPRoundingModeRTP * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        FPRoundingModeRTN * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
      ),
    ),
    FPDenormMode => EnumInfo(
      FPDenormMode,
      Dict(
        FPDenormModePreserve * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFunctionFloatControlINTEL]), []),
        FPDenormModeFlushToZero * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFunctionFloatControlINTEL]), []),
      ),
    ),
    QuantizationModes => EnumInfo(
      QuantizationModes,
      Dict(
        QuantizationModesTRN * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]), []),
        QuantizationModesTRN_ZERO * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]), []),
        QuantizationModesRND * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]), []),
        QuantizationModesRND_ZERO * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]), []),
        QuantizationModesRND_INF * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]), []),
        QuantizationModesRND_MIN_INF * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]), []),
        QuantizationModesRND_CONV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]), []),
        QuantizationModesRND_CONV_ODD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]), []),
      ),
    ),
    FPOperationMode => EnumInfo(
      FPOperationMode,
      Dict(
        FPOperationModeIEEE * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFunctionFloatControlINTEL]), []),
        FPOperationModeALT * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFunctionFloatControlINTEL]), []),
      ),
    ),
    OverflowModes => EnumInfo(
      OverflowModes,
      Dict(
        OverflowModesWRAP * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]), []),
        OverflowModesSAT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]), []),
        OverflowModesSAT_ZERO * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]), []),
        OverflowModesSAT_SYM * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]), []),
      ),
    ),
    LinkageType => EnumInfo(
      LinkageType,
      Dict(
        LinkageTypeExport * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityLinkage]), []),
        LinkageTypeImport * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityLinkage]), []),
        LinkageTypeLinkOnceODR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_linkonce_odr"], [CapabilityLinkage]), []),
      ),
    ),
    AccessQualifier => EnumInfo(
      AccessQualifier,
      Dict(
        AccessQualifierReadOnly * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        AccessQualifierWriteOnly * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        AccessQualifierReadWrite * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
      ),
    ),
    FunctionParameterAttribute => EnumInfo(
      FunctionParameterAttribute,
      Dict(
        FunctionParameterAttributeZext * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        FunctionParameterAttributeSext * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        FunctionParameterAttributeByVal * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        FunctionParameterAttributeSret * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        FunctionParameterAttributeNoAlias * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        FunctionParameterAttributeNoCapture * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        FunctionParameterAttributeNoWrite * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        FunctionParameterAttributeNoReadWrite * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        FunctionParameterAttributeRuntimeAlignedINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRuntimeAlignedAttributeINTEL]), []),
      ),
    ),
    Decoration => EnumInfo(
      Decoration,
      Dict(
        DecorationRelaxedPrecision * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        DecorationSpecId * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader, CapabilityKernel]),
          [OperandInfo(LiteralInteger, "'Specialization Constant ID'", nothing)],
        ),
        DecorationBlock * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        DecorationBufferBlock * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        DecorationRowMajor * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMatrix]), []),
        DecorationColMajor * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMatrix]), []),
        DecorationArrayStride * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
          [OperandInfo(LiteralInteger, "'Array Stride'", nothing)],
        ),
        DecorationMatrixStride * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMatrix]),
          [OperandInfo(LiteralInteger, "'Matrix Stride'", nothing)],
        ),
        DecorationGLSLShared * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        DecorationGLSLPacked * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        DecorationCPacked * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        DecorationBuiltIn * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), [OperandInfo(BuiltIn, nothing, nothing)]),
        DecorationNoPerspective * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        DecorationFlat * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        DecorationPatch * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        DecorationCentroid * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        DecorationSample * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySampleRateShading]), []),
        DecorationInvariant * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        DecorationRestrict * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        DecorationAliased * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        DecorationVolatile * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        DecorationConstant * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        DecorationCoherent * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        DecorationNonWritable * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        DecorationNonReadable * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        DecorationUniform * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader, CapabilityUniformDecoration]), []),
        DecorationUniformId * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, [CapabilityShader, CapabilityUniformDecoration]),
          [OperandInfo(IdScope, "'Execution'", nothing)],
        ),
        DecorationSaturatedConversion * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        DecorationStream * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometryStreams]),
          [OperandInfo(LiteralInteger, "'Stream Number'", nothing)],
        ),
        DecorationLocation * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
          [OperandInfo(LiteralInteger, "'Location'", nothing)],
        ),
        DecorationComponent * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
          [OperandInfo(LiteralInteger, "'Component'", nothing)],
        ),
        DecorationIndex * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
          [OperandInfo(LiteralInteger, "'Index'", nothing)],
        ),
        DecorationBinding * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
          [OperandInfo(LiteralInteger, "'Binding Point'", nothing)],
        ),
        DecorationDescriptorSet * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
          [OperandInfo(LiteralInteger, "'Descriptor Set'", nothing)],
        ),
        DecorationOffset * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
          [OperandInfo(LiteralInteger, "'Byte Offset'", nothing)],
        ),
        DecorationXfbBuffer * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTransformFeedback]),
          [OperandInfo(LiteralInteger, "'XFB Buffer Number'", nothing)],
        ),
        DecorationXfbStride * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTransformFeedback]),
          [OperandInfo(LiteralInteger, "'XFB Stride'", nothing)],
        ),
        DecorationFuncParamAttr * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
          [OperandInfo(FunctionParameterAttribute, "'Function Parameter Attribute'", nothing)],
        ),
        DecorationFPRoundingMode * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
          [OperandInfo(FPRoundingMode, "'Floating-Point Rounding Mode'", nothing)],
        ),
        DecorationFPFastMathMode * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
          [OperandInfo(FPFastMathMode, "'Fast-Math Mode'", nothing)],
        ),
        DecorationLinkageAttributes * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityLinkage]),
          [OperandInfo(LiteralString, "'Name'", nothing), OperandInfo(LinkageType, "'Linkage Type'", nothing)],
        ),
        DecorationNoContraction * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        DecorationInputAttachmentIndex * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityInputAttachment]),
          [OperandInfo(LiteralInteger, "'Attachment Index'", nothing)],
        ),
        DecorationAlignment * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
          [OperandInfo(LiteralInteger, "'Alignment'", nothing)],
        ),
        DecorationMaxByteOffset * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityAddresses]),
          [OperandInfo(LiteralInteger, "'Max Byte Offset'", nothing)],
        ),
        DecorationAlignmentId * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.2.0", v"∞"), nothing, [CapabilityKernel]), [OperandInfo(IdRef, "'Alignment'", nothing)]),
        DecorationMaxByteOffsetId * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.2.0", v"∞"), nothing, [CapabilityAddresses]),
          [OperandInfo(IdRef, "'Max Byte Offset'", nothing)],
        ),
        DecorationNoSignedWrap * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_KHR_no_integer_wrap_decoration"], nothing), []),
        DecorationNoUnsignedWrap * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_KHR_no_integer_wrap_decoration"], nothing), []),
        DecorationExplicitInterpAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_explicit_vertex_parameter"], nothing), []),
        DecorationOverrideCoverageNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_sample_mask_override_coverage"], [CapabilitySampleMaskOverrideCoverageNV]),
          [],
        ),
        DecorationPassthroughNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_geometry_shader_passthrough"], [CapabilityGeometryShaderPassthroughNV]),
          [],
        ),
        DecorationViewportRelativeNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderViewportMaskNV]), []),
        DecorationSecondaryViewportRelativeNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_stereo_view_rendering"], [CapabilityShaderStereoViewNV]),
          [OperandInfo(LiteralInteger, "'Offset'", nothing)],
        ),
        DecorationPerPrimitiveEXT * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_mesh_shader", "SPV_EXT_mesh_shader"],
            [CapabilityMeshShadingNV, CapabilityMeshShadingEXT],
          ),
          [],
        ),
        DecorationPerViewNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_mesh_shader"], [CapabilityMeshShadingNV]), []),
        DecorationPerTaskNV * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_mesh_shader", "SPV_EXT_mesh_shader"],
            [CapabilityMeshShadingNV, CapabilityMeshShadingEXT],
          ),
          [],
        ),
        DecorationPerVertexNV * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_fragment_shader_barycentric", "SPV_KHR_fragment_shader_barycentric"],
            [CapabilityFragmentBarycentricNV, CapabilityFragmentBarycentricKHR],
          ),
          [],
        ),
        DecorationNonUniformEXT * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityShaderNonUniform]), []),
        DecorationRestrictPointerEXT * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"1.5.0", v"∞"),
            ["SPV_EXT_physical_storage_buffer", "SPV_KHR_physical_storage_buffer"],
            [CapabilityPhysicalStorageBufferAddresses],
          ),
          [],
        ),
        DecorationAliasedPointerEXT * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"1.5.0", v"∞"),
            ["SPV_EXT_physical_storage_buffer", "SPV_KHR_physical_storage_buffer"],
            [CapabilityPhysicalStorageBufferAddresses],
          ),
          [],
        ),
        DecorationHitObjectShaderRecordBufferNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]), []),
        DecorationBindlessSamplerNV * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityBindlessTextureNV]), []),
        DecorationBindlessImageNV * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityBindlessTextureNV]), []),
        DecorationBoundSamplerNV * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityBindlessTextureNV]), []),
        DecorationBoundImageNV * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityBindlessTextureNV]), []),
        DecorationSIMTCallINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVectorComputeINTEL]),
          [OperandInfo(LiteralInteger, "'N'", nothing)],
        ),
        DecorationReferencedIndirectlyINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_function_pointers"], [CapabilityIndirectReferencesINTEL]), []),
        DecorationClobberINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAsmINTEL]),
          [OperandInfo(LiteralString, "'Register'", nothing)],
        ),
        DecorationSideEffectsINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAsmINTEL]), []),
        DecorationVectorComputeVariableINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVectorComputeINTEL]), []),
        DecorationFuncParamIOKindINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVectorComputeINTEL]),
          [OperandInfo(LiteralInteger, "'Kind'", nothing)],
        ),
        DecorationVectorComputeFunctionINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVectorComputeINTEL]), []),
        DecorationStackCallINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVectorComputeINTEL]), []),
        DecorationGlobalVariableOffsetINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVectorComputeINTEL]),
          [OperandInfo(LiteralInteger, "'Offset'", nothing)],
        ),
        DecorationHlslCounterBufferGOOGLE * U => EnumerantInfo(
          [
            RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_GOOGLE_hlsl_functionality1"], nothing),
            RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, nothing),
          ],
          [OperandInfo(IdRef, "'Counter Buffer'", nothing)],
        ),
        DecorationHlslSemanticGOOGLE * U => EnumerantInfo(
          [
            RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_GOOGLE_hlsl_functionality1"], nothing),
            RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, nothing),
          ],
          [OperandInfo(LiteralString, "'Semantic'", nothing)],
        ),
        DecorationUserTypeGOOGLE * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_GOOGLE_user_type"], nothing),
          [OperandInfo(LiteralString, "'User Type'", nothing)],
        ),
        DecorationFunctionRoundingModeINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFunctionFloatControlINTEL]),
          [OperandInfo(LiteralInteger, "'Target Width'", nothing), OperandInfo(FPRoundingMode, "'FP Rounding Mode'", nothing)],
        ),
        DecorationFunctionDenormModeINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFunctionFloatControlINTEL]),
          [OperandInfo(LiteralInteger, "'Target Width'", nothing), OperandInfo(FPDenormMode, "'FP Denorm Mode'", nothing)],
        ),
        DecorationRegisterINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], [CapabilityFPGAMemoryAttributesINTEL]),
          [],
        ),
        DecorationMemoryINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], [CapabilityFPGAMemoryAttributesINTEL]),
          [OperandInfo(LiteralString, "'Memory Type'", nothing)],
        ),
        DecorationNumbanksINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], [CapabilityFPGAMemoryAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'Banks'", nothing)],
        ),
        DecorationBankwidthINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], [CapabilityFPGAMemoryAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'Bank Width'", nothing)],
        ),
        DecorationMaxPrivateCopiesINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], [CapabilityFPGAMemoryAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'Maximum Copies'", nothing)],
        ),
        DecorationSinglepumpINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], [CapabilityFPGAMemoryAttributesINTEL]),
          [],
        ),
        DecorationDoublepumpINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], [CapabilityFPGAMemoryAttributesINTEL]),
          [],
        ),
        DecorationMaxReplicatesINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], [CapabilityFPGAMemoryAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'Maximum Replicates'", nothing)],
        ),
        DecorationSimpleDualPortINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], [CapabilityFPGAMemoryAttributesINTEL]),
          [],
        ),
        DecorationMergeINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], [CapabilityFPGAMemoryAttributesINTEL]),
          [OperandInfo(LiteralString, "'Merge Key'", nothing), OperandInfo(LiteralString, "'Merge Type'", nothing)],
        ),
        DecorationBankBitsINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], [CapabilityFPGAMemoryAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'Bank Bits'", "*")],
        ),
        DecorationForcePow2DepthINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], [CapabilityFPGAMemoryAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'Force Key'", nothing)],
        ),
        DecorationBurstCoalesceINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAMemoryAccessesINTEL]), []),
        DecorationCacheSizeINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAMemoryAccessesINTEL]),
          [OperandInfo(LiteralInteger, "'Cache Size in bytes'", nothing)],
        ),
        DecorationDontStaticallyCoalesceINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAMemoryAccessesINTEL]), []),
        DecorationPrefetchINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAMemoryAccessesINTEL]),
          [OperandInfo(LiteralInteger, "'Prefetcher Size in bytes'", nothing)],
        ),
        DecorationStallEnableINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAClusterAttributesINTEL]), []),
        DecorationFuseLoopsInFunctionINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityLoopFuseINTEL]), []),
        DecorationMathOpDSPModeINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGADSPControlINTEL]),
          [OperandInfo(LiteralInteger, "'Mode'", nothing), OperandInfo(LiteralInteger, "'Propagate'", nothing)],
        ),
        DecorationAliasScopeINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMemoryAccessAliasingINTEL]),
          [OperandInfo(IdRef, "'Aliasing Scopes List'", nothing)],
        ),
        DecorationNoAliasINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMemoryAccessAliasingINTEL]),
          [OperandInfo(IdRef, "'Aliasing Scopes List'", nothing)],
        ),
        DecorationInitiationIntervalINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAInvocationPipeliningAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'Cycles'", nothing)],
        ),
        DecorationMaxConcurrencyINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAInvocationPipeliningAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'Invocations'", nothing)],
        ),
        DecorationPipelineEnableINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAInvocationPipeliningAttributesINTEL]),
          [OperandInfo(LiteralInteger, "'Enable'", nothing)],
        ),
        DecorationBufferLocationINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGABufferLocationINTEL]),
          [OperandInfo(LiteralInteger, "'Buffer Location ID'", nothing)],
        ),
        DecorationIOPipeStorageINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIOPipesINTEL]),
          [OperandInfo(LiteralInteger, "'IO Pipe ID'", nothing)],
        ),
        DecorationFunctionFloatingPointModeINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFunctionFloatControlINTEL]),
          [OperandInfo(LiteralInteger, "'Target Width'", nothing), OperandInfo(FPOperationMode, "'FP Operation Mode'", nothing)],
        ),
        DecorationSingleElementVectorINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVectorComputeINTEL]), []),
        DecorationVectorComputeCallableFunctionINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVectorComputeINTEL]), []),
        DecorationMediaBlockIOINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVectorComputeINTEL]), []),
        DecorationConduitKernelArgumentINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAArgumentInterfacesINTEL]), []),
        DecorationRegisterMapKernelArgumentINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAArgumentInterfacesINTEL]), []),
        DecorationMMHostInterfaceAddressWidthINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAArgumentInterfacesINTEL]),
          [OperandInfo(LiteralInteger, "'AddressWidth'", nothing)],
        ),
        DecorationMMHostInterfaceDataWidthINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAArgumentInterfacesINTEL]),
          [OperandInfo(LiteralInteger, "'DataWidth'", nothing)],
        ),
        DecorationMMHostInterfaceLatencyINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAArgumentInterfacesINTEL]),
          [OperandInfo(LiteralInteger, "'Latency'", nothing)],
        ),
        DecorationMMHostInterfaceReadWriteModeINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAArgumentInterfacesINTEL]),
          [OperandInfo(AccessQualifier, "'ReadWriteMode'", nothing)],
        ),
        DecorationMMHostInterfaceMaxBurstINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAArgumentInterfacesINTEL]),
          [OperandInfo(LiteralInteger, "'MaxBurstCount'", nothing)],
        ),
        DecorationMMHostInterfaceWaitRequestINTEL * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAArgumentInterfacesINTEL]),
          [OperandInfo(LiteralInteger, "'Waitrequest'", nothing)],
        ),
        DecorationStableKernelArgumentINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFPGAArgumentInterfacesINTEL]), []),
      ),
    ),
    BuiltIn => EnumInfo(
      BuiltIn,
      Dict(
        BuiltInPosition * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        BuiltInPointSize * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        BuiltInClipDistance * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityClipDistance]), []),
        BuiltInCullDistance * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityCullDistance]), []),
        BuiltInVertexId * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        BuiltInInstanceId * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        BuiltInPrimitiveId * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            nothing,
            [
              CapabilityGeometry,
              CapabilityTessellation,
              CapabilityRayTracingNV,
              CapabilityRayTracingKHR,
              CapabilityMeshShadingNV,
              CapabilityMeshShadingEXT,
            ],
          ),
          [],
        ),
        BuiltInInvocationId * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry, CapabilityTessellation]), []),
        BuiltInLayer * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            nothing,
            [CapabilityGeometry, CapabilityShaderLayer, CapabilityShaderViewportIndexLayerEXT, CapabilityMeshShadingNV, CapabilityMeshShadingEXT],
          ),
          [],
        ),
        BuiltInViewportIndex * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            nothing,
            [
              CapabilityMultiViewport,
              CapabilityShaderViewportIndex,
              CapabilityShaderViewportIndexLayerEXT,
              CapabilityMeshShadingNV,
              CapabilityMeshShadingEXT,
            ],
          ),
          [],
        ),
        BuiltInTessLevelOuter * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        BuiltInTessLevelInner * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        BuiltInTessCoord * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        BuiltInPatchVertices * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        BuiltInFragCoord * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        BuiltInPointCoord * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        BuiltInFrontFacing * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        BuiltInSampleId * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySampleRateShading]), []),
        BuiltInSamplePosition * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySampleRateShading]), []),
        BuiltInSampleMask * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        BuiltInFragDepth * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        BuiltInHelperInvocation * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        BuiltInNumWorkgroups * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        BuiltInWorkgroupSize * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        BuiltInWorkgroupId * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        BuiltInLocalInvocationId * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        BuiltInGlobalInvocationId * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        BuiltInLocalInvocationIndex * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        BuiltInWorkDim * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        BuiltInGlobalSize * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        BuiltInEnqueuedWorkgroupSize * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        BuiltInGlobalOffset * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        BuiltInGlobalLinearId * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        BuiltInSubgroupSize * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel, CapabilityGroupNonUniform, CapabilitySubgroupBallotKHR]),
          [],
        ),
        BuiltInSubgroupMaxSize * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        BuiltInNumSubgroups * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel, CapabilityGroupNonUniform]), []),
        BuiltInNumEnqueuedSubgroups * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        BuiltInSubgroupId * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel, CapabilityGroupNonUniform]), []),
        BuiltInSubgroupLocalInvocationId * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel, CapabilityGroupNonUniform, CapabilitySubgroupBallotKHR]),
          [],
        ),
        BuiltInVertexIndex * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        BuiltInInstanceIndex * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        BuiltInCoreIDARM * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityCoreBuiltinsARM]), []),
        BuiltInCoreCountARM * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityCoreBuiltinsARM]), []),
        BuiltInCoreMaxIDARM * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityCoreBuiltinsARM]), []),
        BuiltInWarpIDARM * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityCoreBuiltinsARM]), []),
        BuiltInWarpMaxIDARM * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityCoreBuiltinsARM]), []),
        BuiltInSubgroupEqMaskKHR * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilitySubgroupBallotKHR, CapabilityGroupNonUniformBallot]),
          [],
        ),
        BuiltInSubgroupGeMaskKHR * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilitySubgroupBallotKHR, CapabilityGroupNonUniformBallot]),
          [],
        ),
        BuiltInSubgroupGtMaskKHR * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilitySubgroupBallotKHR, CapabilityGroupNonUniformBallot]),
          [],
        ),
        BuiltInSubgroupLeMaskKHR * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilitySubgroupBallotKHR, CapabilityGroupNonUniformBallot]),
          [],
        ),
        BuiltInSubgroupLtMaskKHR * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilitySubgroupBallotKHR, CapabilityGroupNonUniformBallot]),
          [],
        ),
        BuiltInBaseVertex * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_shader_draw_parameters"], [CapabilityDrawParameters]), []),
        BuiltInBaseInstance * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_shader_draw_parameters"], [CapabilityDrawParameters]), []),
        BuiltInDrawIndex * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"1.3.0", v"∞"),
            ["SPV_KHR_shader_draw_parameters", "SPV_NV_mesh_shader", "SPV_EXT_mesh_shader"],
            [CapabilityDrawParameters, CapabilityMeshShadingNV, CapabilityMeshShadingEXT],
          ),
          [],
        ),
        BuiltInPrimitiveShadingRateKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_fragment_shading_rate"], [CapabilityFragmentShadingRateKHR]), []),
        BuiltInDeviceIndex * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_device_group"], [CapabilityDeviceGroup]), []),
        BuiltInViewIndex * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_multiview"], [CapabilityMultiView]), []),
        BuiltInShadingRateKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_fragment_shading_rate"], [CapabilityFragmentShadingRateKHR]), []),
        BuiltInBaryCoordNoPerspAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_explicit_vertex_parameter"], nothing), []),
        BuiltInBaryCoordNoPerspCentroidAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_explicit_vertex_parameter"], nothing), []),
        BuiltInBaryCoordNoPerspSampleAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_explicit_vertex_parameter"], nothing), []),
        BuiltInBaryCoordSmoothAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_explicit_vertex_parameter"], nothing), []),
        BuiltInBaryCoordSmoothCentroidAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_explicit_vertex_parameter"], nothing), []),
        BuiltInBaryCoordSmoothSampleAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_explicit_vertex_parameter"], nothing), []),
        BuiltInBaryCoordPullModelAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_explicit_vertex_parameter"], nothing), []),
        BuiltInFragStencilRefEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_shader_stencil_export"], [CapabilityStencilExportEXT]), []),
        BuiltInViewportMaskNV * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_viewport_array2", "SPV_NV_mesh_shader"],
            [CapabilityShaderViewportMaskNV, CapabilityMeshShadingNV],
          ),
          [],
        ),
        BuiltInSecondaryPositionNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_stereo_view_rendering"], [CapabilityShaderStereoViewNV]), []),
        BuiltInSecondaryViewportMaskNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_stereo_view_rendering"], [CapabilityShaderStereoViewNV]), []),
        BuiltInPositionPerViewNV * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NVX_multiview_per_view_attributes", "SPV_NV_mesh_shader"],
            [CapabilityPerViewAttributesNV, CapabilityMeshShadingNV],
          ),
          [],
        ),
        BuiltInViewportMaskPerViewNV * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NVX_multiview_per_view_attributes", "SPV_NV_mesh_shader"],
            [CapabilityPerViewAttributesNV, CapabilityMeshShadingNV],
          ),
          [],
        ),
        BuiltInFullyCoveredEXT * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_fragment_fully_covered"], [CapabilityFragmentFullyCoveredEXT]),
          [],
        ),
        BuiltInTaskCountNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_mesh_shader"], [CapabilityMeshShadingNV]), []),
        BuiltInPrimitiveCountNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_mesh_shader"], [CapabilityMeshShadingNV]), []),
        BuiltInPrimitiveIndicesNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_mesh_shader"], [CapabilityMeshShadingNV]), []),
        BuiltInClipDistancePerViewNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_mesh_shader"], [CapabilityMeshShadingNV]), []),
        BuiltInCullDistancePerViewNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_mesh_shader"], [CapabilityMeshShadingNV]), []),
        BuiltInLayerPerViewNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_mesh_shader"], [CapabilityMeshShadingNV]), []),
        BuiltInMeshViewCountNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_mesh_shader"], [CapabilityMeshShadingNV]), []),
        BuiltInMeshViewIndicesNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_mesh_shader"], [CapabilityMeshShadingNV]), []),
        BuiltInBaryCoordNV * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_fragment_shader_barycentric", "SPV_KHR_fragment_shader_barycentric"],
            [CapabilityFragmentBarycentricNV, CapabilityFragmentBarycentricKHR],
          ),
          [],
        ),
        BuiltInBaryCoordNoPerspNV * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_fragment_shader_barycentric", "SPV_KHR_fragment_shader_barycentric"],
            [CapabilityFragmentBarycentricNV, CapabilityFragmentBarycentricKHR],
          ),
          [],
        ),
        BuiltInFragmentSizeNV * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_EXT_fragment_invocation_density", "SPV_NV_shading_rate"],
            [CapabilityFragmentDensityEXT, CapabilityShadingRateNV],
          ),
          [],
        ),
        BuiltInInvocationsPerPixelNV * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_EXT_fragment_invocation_density", "SPV_NV_shading_rate"],
            [CapabilityFragmentDensityEXT, CapabilityShadingRateNV],
          ),
          [],
        ),
        BuiltInPrimitivePointIndicesEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_mesh_shader"], [CapabilityMeshShadingEXT]), []),
        BuiltInPrimitiveLineIndicesEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_mesh_shader"], [CapabilityMeshShadingEXT]), []),
        BuiltInPrimitiveTriangleIndicesEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_mesh_shader"], [CapabilityMeshShadingEXT]), []),
        BuiltInCullPrimitiveEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_mesh_shader"], [CapabilityMeshShadingEXT]), []),
        BuiltInLaunchIdKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInLaunchSizeKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInWorldRayOriginKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInWorldRayDirectionKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInObjectRayOriginKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInObjectRayDirectionKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInRayTminKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInRayTmaxKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInInstanceCustomIndexKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInObjectToWorldKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInWorldToObjectKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInHitTNV * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_ray_tracing"], [CapabilityRayTracingNV]), []),
        BuiltInHitKindKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInCurrentRayTimeNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_ray_tracing_motion_blur"], [CapabilityRayTracingMotionBlurNV]),
          [],
        ),
        BuiltInIncomingRayFlagsKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
            [CapabilityRayTracingNV, CapabilityRayTracingKHR],
          ),
          [],
        ),
        BuiltInRayGeometryIndexKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_tracing"], [CapabilityRayTracingKHR]), []),
        BuiltInWarpsPerSMNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_sm_builtins"], [CapabilityShaderSMBuiltinsNV]), []),
        BuiltInSMCountNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_sm_builtins"], [CapabilityShaderSMBuiltinsNV]), []),
        BuiltInWarpIDNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_sm_builtins"], [CapabilityShaderSMBuiltinsNV]), []),
        BuiltInSMIDNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_sm_builtins"], [CapabilityShaderSMBuiltinsNV]), []),
        BuiltInCullMaskKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_cull_mask"], [CapabilityRayCullMaskKHR]), []),
      ),
    ),
    Scope => EnumInfo(
      Scope,
      Dict(
        ScopeCrossDevice * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        ScopeDevice * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        ScopeWorkgroup * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        ScopeSubgroup * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        ScopeInvocation * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        ScopeQueueFamilyKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityVulkanMemoryModel]), []),
        ScopeShaderCallKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayTracingKHR]), []),
      ),
    ),
    GroupOperation => EnumInfo(
      GroupOperation,
      Dict(
        GroupOperationReduce * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            nothing,
            [CapabilityKernel, CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformBallot],
          ),
          [],
        ),
        GroupOperationInclusiveScan * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            nothing,
            [CapabilityKernel, CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformBallot],
          ),
          [],
        ),
        GroupOperationExclusiveScan * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            nothing,
            [CapabilityKernel, CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformBallot],
          ),
          [],
        ),
        GroupOperationClusteredReduce * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformClustered]), []),
        GroupOperationPartitionedReduceNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_subgroup_partitioned"], [CapabilityGroupNonUniformPartitionedNV]),
          [],
        ),
        GroupOperationPartitionedInclusiveScanNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_subgroup_partitioned"], [CapabilityGroupNonUniformPartitionedNV]),
          [],
        ),
        GroupOperationPartitionedExclusiveScanNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_subgroup_partitioned"], [CapabilityGroupNonUniformPartitionedNV]),
          [],
        ),
      ),
    ),
    KernelEnqueueFlags => EnumInfo(
      KernelEnqueueFlags,
      Dict(
        KernelEnqueueFlagsNoWait * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        KernelEnqueueFlagsWaitKernel * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        KernelEnqueueFlagsWaitWorkGroup * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
      ),
    ),
    Capability => EnumInfo(
      Capability,
      Dict(
        CapabilityMatrix * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        CapabilityShader * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMatrix]), []),
        CapabilityGeometry * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityTessellation * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityAddresses * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        CapabilityLinkage * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        CapabilityKernel * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        CapabilityVector16 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        CapabilityFloat16Buffer * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        CapabilityFloat16 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        CapabilityFloat64 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        CapabilityInt64 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        CapabilityInt64Atomics * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityInt64]), []),
        CapabilityImageBasic * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        CapabilityImageReadWrite * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityImageBasic]), []),
        CapabilityImageMipmap * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityImageBasic]), []),
        CapabilityPipes * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        CapabilityGroups * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_ballot"], nothing), []),
        CapabilityDeviceEnqueue * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        CapabilityLiteralSampler * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]), []),
        CapabilityAtomicStorage * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityInt16 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        CapabilityTessellationPointSize * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityTessellation]), []),
        CapabilityGeometryPointSize * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry]), []),
        CapabilityImageGatherExtended * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityStorageImageMultisample * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityUniformBufferArrayDynamicIndexing * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilitySampledImageArrayDynamicIndexing * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityStorageBufferArrayDynamicIndexing * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityStorageImageArrayDynamicIndexing * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityClipDistance * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityCullDistance * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityImageCubeArray * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySampledCubeArray]), []),
        CapabilitySampleRateShading * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityImageRect * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySampledRect]), []),
        CapabilitySampledRect * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityGenericPointer * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAddresses]), []),
        CapabilityInt8 * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        CapabilityInputAttachment * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilitySparseResidency * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityMinLod * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilitySampled1D * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        CapabilityImage1D * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySampled1D]), []),
        CapabilitySampledCubeArray * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilitySampledBuffer * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing), []),
        CapabilityImageBuffer * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySampledBuffer]), []),
        CapabilityImageMSArray * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityStorageImageExtendedFormats * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityImageQuery * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityDerivativeControl * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityInterpolationFunction * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityTransformFeedback * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityGeometryStreams * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry]), []),
        CapabilityStorageImageReadWithoutFormat * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityStorageImageWriteWithoutFormat * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityMultiViewport * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry]), []),
        CapabilitySubgroupDispatch * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityDeviceEnqueue]), []),
        CapabilityNamedBarrier * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityKernel]), []),
        CapabilityPipeStorage * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityPipes]), []),
        CapabilityGroupNonUniform * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, nothing), []),
        CapabilityGroupNonUniformVote * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniform]), []),
        CapabilityGroupNonUniformArithmetic * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniform]), []),
        CapabilityGroupNonUniformBallot * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniform]), []),
        CapabilityGroupNonUniformShuffle * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniform]), []),
        CapabilityGroupNonUniformShuffleRelative * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniform]), []),
        CapabilityGroupNonUniformClustered * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniform]), []),
        CapabilityGroupNonUniformQuad * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniform]), []),
        CapabilityShaderLayer * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, nothing), []),
        CapabilityShaderViewportIndex * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, nothing), []),
        CapabilityUniformDecoration * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, nothing), []),
        CapabilityCoreBuiltinsARM * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_ARM_core_builtins"], nothing), []),
        CapabilityFragmentShadingRateKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_fragment_shading_rate"], [CapabilityShader]), []),
        CapabilitySubgroupBallotKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_shader_ballot"], nothing), []),
        CapabilityDrawParameters * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_shader_draw_parameters"], [CapabilityShader]), []),
        CapabilityWorkgroupMemoryExplicitLayoutKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_workgroup_memory_explicit_layout"], [CapabilityShader]), []),
        CapabilityWorkgroupMemoryExplicitLayout8BitAccessKHR * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_workgroup_memory_explicit_layout"], [CapabilityWorkgroupMemoryExplicitLayoutKHR]),
          [],
        ),
        CapabilityWorkgroupMemoryExplicitLayout16BitAccessKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_workgroup_memory_explicit_layout"], [CapabilityShader]), []),
        CapabilitySubgroupVoteKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_subgroup_vote"], nothing), []),
        CapabilityStorageUniformBufferBlock16 * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_16bit_storage"], nothing), []),
        CapabilityStorageUniform16 * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"1.3.0", v"∞"),
            ["SPV_KHR_16bit_storage"],
            [CapabilityStorageBuffer16BitAccess, CapabilityStorageUniformBufferBlock16],
          ),
          [],
        ),
        CapabilityStoragePushConstant16 * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_16bit_storage"], nothing), []),
        CapabilityStorageInputOutput16 * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_16bit_storage"], nothing), []),
        CapabilityDeviceGroup * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_device_group"], nothing), []),
        CapabilityMultiView * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_multiview"], [CapabilityShader]), []),
        CapabilityVariablePointersStorageBuffer * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_variable_pointers"], [CapabilityShader]), []),
        CapabilityVariablePointers * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.3.0", v"∞"), ["SPV_KHR_variable_pointers"], [CapabilityVariablePointersStorageBuffer]),
          [],
        ),
        CapabilityAtomicStorageOps * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_shader_atomic_counter_ops"], nothing), []),
        CapabilitySampleMaskPostDepthCoverage * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_post_depth_coverage"], nothing), []),
        CapabilityStorageBuffer8BitAccess * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), ["SPV_KHR_8bit_storage"], nothing), []),
        CapabilityUniformAndStorageBuffer8BitAccess * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), ["SPV_KHR_8bit_storage"], [CapabilityStorageBuffer8BitAccess]), []),
        CapabilityStoragePushConstant8 * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), ["SPV_KHR_8bit_storage"], nothing), []),
        CapabilityDenormPreserve * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_KHR_float_controls"], nothing), []),
        CapabilityDenormFlushToZero * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_KHR_float_controls"], nothing), []),
        CapabilitySignedZeroInfNanPreserve * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_KHR_float_controls"], nothing), []),
        CapabilityRoundingModeRTE * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_KHR_float_controls"], nothing), []),
        CapabilityRoundingModeRTZ * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_KHR_float_controls"], nothing), []),
        CapabilityRayQueryProvisionalKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityShader]), []),
        CapabilityRayQueryKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityShader]), []),
        CapabilityRayTraversalPrimitiveCullingKHR * U => EnumerantInfo(
          RequiredSupport(
            VersionRange(v"0.0.0", v"∞"),
            ["SPV_KHR_ray_query", "SPV_KHR_ray_tracing"],
            [CapabilityRayQueryKHR, CapabilityRayTracingKHR],
          ),
          [],
        ),
        CapabilityRayTracingKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_tracing"], [CapabilityShader]), []),
        CapabilityFloat16ImageAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_gpu_shader_half_float_fetch"], [CapabilityShader]), []),
        CapabilityImageGatherBiasLodAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_texture_gather_bias_lod"], [CapabilityShader]), []),
        CapabilityFragmentMaskAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_fragment_mask"], [CapabilityShader]), []),
        CapabilityStencilExportEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_shader_stencil_export"], [CapabilityShader]), []),
        CapabilityImageReadWriteLodAMD * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_image_load_store_lod"], [CapabilityShader]), []),
        CapabilityInt64ImageEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_shader_image_int64"], [CapabilityShader]), []),
        CapabilityShaderClockKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_shader_clock"], nothing), []),
        CapabilitySampleMaskOverrideCoverageNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_sample_mask_override_coverage"], [CapabilitySampleRateShading]),
          [],
        ),
        CapabilityGeometryShaderPassthroughNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_geometry_shader_passthrough"], [CapabilityGeometry]), []),
        CapabilityShaderViewportIndexLayerNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_shader_viewport_index_layer", "SPV_NV_viewport_array2"], [CapabilityMultiViewport]),
          [],
        ),
        CapabilityShaderViewportMaskNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_viewport_array2"], [CapabilityShaderViewportIndexLayerNV]), []),
        CapabilityShaderStereoViewNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_stereo_view_rendering"], [CapabilityShaderViewportMaskNV]), []),
        CapabilityPerViewAttributesNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NVX_multiview_per_view_attributes"], [CapabilityMultiView]), []),
        CapabilityFragmentFullyCoveredEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_fragment_fully_covered"], [CapabilityShader]), []),
        CapabilityMeshShadingNV * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_mesh_shader"], [CapabilityShader]), []),
        CapabilityImageFootprintNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_image_footprint"], nothing), []),
        CapabilityMeshShadingEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_mesh_shader"], [CapabilityShader]), []),
        CapabilityFragmentBarycentricNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_fragment_shader_barycentric", "SPV_KHR_fragment_shader_barycentric"], nothing),
          [],
        ),
        CapabilityComputeDerivativeGroupQuadsNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_compute_shader_derivatives"], nothing), []),
        CapabilityShadingRateNV * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_fragment_invocation_density", "SPV_NV_shading_rate"], [CapabilityShader]),
          [],
        ),
        CapabilityGroupNonUniformPartitionedNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_subgroup_partitioned"], nothing), []),
        CapabilityShaderNonUniformEXT * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityRuntimeDescriptorArrayEXT * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityInputAttachmentArrayDynamicIndexingEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityInputAttachment]), []),
        CapabilityUniformTexelBufferArrayDynamicIndexingEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilitySampledBuffer]), []),
        CapabilityStorageTexelBufferArrayDynamicIndexingEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityImageBuffer]), []),
        CapabilityUniformBufferArrayNonUniformIndexingEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityShaderNonUniform]), []),
        CapabilitySampledImageArrayNonUniformIndexingEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityShaderNonUniform]), []),
        CapabilityStorageBufferArrayNonUniformIndexingEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityShaderNonUniform]), []),
        CapabilityStorageImageArrayNonUniformIndexingEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityShaderNonUniform]), []),
        CapabilityInputAttachmentArrayNonUniformIndexingEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityInputAttachment, CapabilityShaderNonUniform]), []),
        CapabilityUniformTexelBufferArrayNonUniformIndexingEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilitySampledBuffer, CapabilityShaderNonUniform]), []),
        CapabilityStorageTexelBufferArrayNonUniformIndexingEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, [CapabilityImageBuffer, CapabilityShaderNonUniform]), []),
        CapabilityRayTracingNV * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_ray_tracing"], [CapabilityShader]), []),
        CapabilityRayTracingMotionBlurNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_ray_tracing_motion_blur"], [CapabilityShader]), []),
        CapabilityVulkanMemoryModelKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, nothing), []),
        CapabilityVulkanMemoryModelDeviceScopeKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.5.0", v"∞"), nothing, nothing), []),
        CapabilityPhysicalStorageBufferAddressesEXT * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"1.5.0", v"∞"), ["SPV_EXT_physical_storage_buffer", "SPV_KHR_physical_storage_buffer"], [CapabilityShader]),
          [],
        ),
        CapabilityComputeDerivativeGroupLinearNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_compute_shader_derivatives"], nothing), []),
        CapabilityRayTracingProvisionalKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_tracing"], [CapabilityShader]), []),
        CapabilityCooperativeMatrixNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_cooperative_matrix"], [CapabilityShader]), []),
        CapabilityFragmentShaderSampleInterlockEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_fragment_shader_interlock"], [CapabilityShader]), []),
        CapabilityFragmentShaderShadingRateInterlockEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_fragment_shader_interlock"], [CapabilityShader]), []),
        CapabilityShaderSMBuiltinsNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_sm_builtins"], [CapabilityShader]), []),
        CapabilityFragmentShaderPixelInterlockEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_fragment_shader_interlock"], [CapabilityShader]), []),
        CapabilityDemoteToHelperInvocationEXT * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, [CapabilityShader]), []),
        CapabilityRayTracingOpacityMicromapEXT * U => EnumerantInfo(
          RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_opacity_micromap"], [CapabilityRayQueryKHR, CapabilityRayTracingKHR]),
          [],
        ),
        CapabilityShaderInvocationReorderNV * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_invocation_reorder"], [CapabilityRayTracingKHR]), []),
        CapabilityBindlessTextureNV * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_bindless_texture"], nothing), []),
        CapabilitySubgroupShuffleINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_subgroups"], nothing), []),
        CapabilitySubgroupBufferBlockIOINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_subgroups"], nothing), []),
        CapabilitySubgroupImageBlockIOINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_subgroups"], nothing), []),
        CapabilitySubgroupImageMediaBlockIOINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_media_block_io"], nothing), []),
        CapabilityRoundToInfinityINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_float_controls2"], nothing), []),
        CapabilityFloatingPointModeINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_float_controls2"], nothing), []),
        CapabilityIntegerFunctions2INTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_shader_integer_functions2"], [CapabilityShader]), []),
        CapabilityFunctionPointersINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_function_pointers"], nothing), []),
        CapabilityIndirectReferencesINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_function_pointers"], nothing), []),
        CapabilityAsmINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_inline_assembly"], nothing), []),
        CapabilityAtomicFloat32MinMaxEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_shader_atomic_float_min_max"], nothing), []),
        CapabilityAtomicFloat64MinMaxEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_shader_atomic_float_min_max"], nothing), []),
        CapabilityAtomicFloat16MinMaxEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_shader_atomic_float_min_max"], nothing), []),
        CapabilityVectorComputeINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_vector_compute"], [CapabilityVectorAnyINTEL]), []),
        CapabilityVectorAnyINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_vector_compute"], nothing), []),
        CapabilityExpectAssumeKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_expect_assume"], nothing), []),
        CapabilitySubgroupAvcMotionEstimationINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_device_side_avc_motion_estimation"], nothing), []),
        CapabilitySubgroupAvcMotionEstimationIntraINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_device_side_avc_motion_estimation"], nothing), []),
        CapabilitySubgroupAvcMotionEstimationChromaINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_device_side_avc_motion_estimation"], nothing), []),
        CapabilityVariableLengthArrayINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_variable_length_array"], nothing), []),
        CapabilityFunctionFloatControlINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_float_controls2"], nothing), []),
        CapabilityFPGAMemoryAttributesINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_attributes"], nothing), []),
        CapabilityFPFastMathModeINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fp_fast_math_mode"], [CapabilityKernel]), []),
        CapabilityArbitraryPrecisionIntegersINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_arbitrary_precision_integers"], nothing), []),
        CapabilityArbitraryPrecisionFloatingPointINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_arbitrary_precision_floating_point"], nothing), []),
        CapabilityUnstructuredLoopControlsINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_unstructured_loop_controls"], nothing), []),
        CapabilityFPGALoopControlsINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_loop_controls"], nothing), []),
        CapabilityKernelAttributesINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_kernel_attributes"], nothing), []),
        CapabilityFPGAKernelAttributesINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_kernel_attributes"], nothing), []),
        CapabilityFPGAMemoryAccessesINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_memory_accesses"], nothing), []),
        CapabilityFPGAClusterAttributesINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_cluster_attributes"], nothing), []),
        CapabilityLoopFuseINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_loop_fuse"], nothing), []),
        CapabilityFPGADSPControlINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_dsp_control"], nothing), []),
        CapabilityMemoryAccessAliasingINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_memory_access_aliasing"], nothing), []),
        CapabilityFPGAInvocationPipeliningAttributesINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_invocation_pipelining_attributes"], nothing), []),
        CapabilityFPGABufferLocationINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_buffer_location"], nothing), []),
        CapabilityArbitraryPrecisionFixedPointINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_arbitrary_precision_fixed_point"], nothing), []),
        CapabilityUSMStorageClassesINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_usm_storage_classes"], nothing), []),
        CapabilityRuntimeAlignedAttributeINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_runtime_aligned"], nothing), []),
        CapabilityIOPipesINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_io_pipes"], nothing), []),
        CapabilityBlockingPipesINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_blocking_pipes"], nothing), []),
        CapabilityFPGARegINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_reg"], nothing), []),
        CapabilityDotProductInputAllKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, nothing), []),
        CapabilityDotProductInput4x8BitKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, [CapabilityInt8]), []),
        CapabilityDotProductInput4x8BitPackedKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, nothing), []),
        CapabilityDotProductKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, nothing), []),
        CapabilityRayCullMaskKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_cull_mask"], nothing), []),
        CapabilityBitInstructions * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_bit_instructions"], nothing), []),
        CapabilityGroupNonUniformRotateKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_subgroup_rotate"], [CapabilityGroupNonUniform]), []),
        CapabilityAtomicFloat32AddEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_shader_atomic_float_add"], nothing), []),
        CapabilityAtomicFloat64AddEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_shader_atomic_float_add"], nothing), []),
        CapabilityLongConstantCompositeINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_long_constant_composite"], nothing), []),
        CapabilityOptNoneINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_optnone"], nothing), []),
        CapabilityAtomicFloat16AddEXT * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_shader_atomic_float16_add"], nothing), []),
        CapabilityDebugInfoModuleINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_debug_module"], nothing), []),
        CapabilitySplitBarrierINTEL * U => EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_split_barrier"], nothing), []),
        CapabilityFPGAArgumentInterfacesINTEL * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_argument_interfaces"], nothing), []),
        CapabilityGroupUniformArithmeticKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_uniform_group_instructions"], nothing), []),
      ),
    ),
    RayQueryIntersection => EnumInfo(
      RayQueryIntersection,
      Dict(
        RayQueryIntersectionRayQueryCandidateIntersectionKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR]), []),
        RayQueryIntersectionRayQueryCommittedIntersectionKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR]), []),
      ),
    ),
    RayQueryCommittedIntersectionType => EnumInfo(
      RayQueryCommittedIntersectionType,
      Dict(
        RayQueryCommittedIntersectionTypeRayQueryCommittedIntersectionNoneKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR]), []),
        RayQueryCommittedIntersectionTypeRayQueryCommittedIntersectionTriangleKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR]), []),
        RayQueryCommittedIntersectionTypeRayQueryCommittedIntersectionGeneratedKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR]), []),
      ),
    ),
    RayQueryCandidateIntersectionType => EnumInfo(
      RayQueryCandidateIntersectionType,
      Dict(
        RayQueryCandidateIntersectionTypeRayQueryCandidateIntersectionTriangleKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR]), []),
        RayQueryCandidateIntersectionTypeRayQueryCandidateIntersectionAABBKHR * U =>
          EnumerantInfo(RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityRayQueryKHR]), []),
      ),
    ),
    PackedVectorFormat => EnumInfo(
      PackedVectorFormat,
      Dict(PackedVectorFormatPackedVectorFormat4x8BitKHR * U => EnumerantInfo(RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, nothing), [])),
    ),
  ),
)
