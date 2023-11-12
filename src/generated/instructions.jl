@cenum OpCode::UInt32 begin
  OpNop                                                                   = 0
  OpUndef                                                                 = 1
  OpSourceContinued                                                       = 2
  OpSource                                                                = 3
  OpSourceExtension                                                       = 4
  OpName                                                                  = 5
  OpMemberName                                                            = 6
  OpString                                                                = 7
  OpLine                                                                  = 8
  OpExtension                                                             = 10
  OpExtInstImport                                                         = 11
  OpExtInst                                                               = 12
  OpMemoryModel                                                           = 14
  OpEntryPoint                                                            = 15
  OpExecutionMode                                                         = 16
  OpCapability                                                            = 17
  OpTypeVoid                                                              = 19
  OpTypeBool                                                              = 20
  OpTypeInt                                                               = 21
  OpTypeFloat                                                             = 22
  OpTypeVector                                                            = 23
  OpTypeMatrix                                                            = 24
  OpTypeImage                                                             = 25
  OpTypeSampler                                                           = 26
  OpTypeSampledImage                                                      = 27
  OpTypeArray                                                             = 28
  OpTypeRuntimeArray                                                      = 29
  OpTypeStruct                                                            = 30
  OpTypeOpaque                                                            = 31
  OpTypePointer                                                           = 32
  OpTypeFunction                                                          = 33
  OpTypeEvent                                                             = 34
  OpTypeDeviceEvent                                                       = 35
  OpTypeReserveId                                                         = 36
  OpTypeQueue                                                             = 37
  OpTypePipe                                                              = 38
  OpTypeForwardPointer                                                    = 39
  OpConstantTrue                                                          = 41
  OpConstantFalse                                                         = 42
  OpConstant                                                              = 43
  OpConstantComposite                                                     = 44
  OpConstantSampler                                                       = 45
  OpConstantNull                                                          = 46
  OpSpecConstantTrue                                                      = 48
  OpSpecConstantFalse                                                     = 49
  OpSpecConstant                                                          = 50
  OpSpecConstantComposite                                                 = 51
  OpSpecConstantOp                                                        = 52
  OpFunction                                                              = 54
  OpFunctionParameter                                                     = 55
  OpFunctionEnd                                                           = 56
  OpFunctionCall                                                          = 57
  OpVariable                                                              = 59
  OpImageTexelPointer                                                     = 60
  OpLoad                                                                  = 61
  OpStore                                                                 = 62
  OpCopyMemory                                                            = 63
  OpCopyMemorySized                                                       = 64
  OpAccessChain                                                           = 65
  OpInBoundsAccessChain                                                   = 66
  OpPtrAccessChain                                                        = 67
  OpArrayLength                                                           = 68
  OpGenericPtrMemSemantics                                                = 69
  OpInBoundsPtrAccessChain                                                = 70
  OpDecorate                                                              = 71
  OpMemberDecorate                                                        = 72
  OpDecorationGroup                                                       = 73
  OpGroupDecorate                                                         = 74
  OpGroupMemberDecorate                                                   = 75
  OpVectorExtractDynamic                                                  = 77
  OpVectorInsertDynamic                                                   = 78
  OpVectorShuffle                                                         = 79
  OpCompositeConstruct                                                    = 80
  OpCompositeExtract                                                      = 81
  OpCompositeInsert                                                       = 82
  OpCopyObject                                                            = 83
  OpTranspose                                                             = 84
  OpSampledImage                                                          = 86
  OpImageSampleImplicitLod                                                = 87
  OpImageSampleExplicitLod                                                = 88
  OpImageSampleDrefImplicitLod                                            = 89
  OpImageSampleDrefExplicitLod                                            = 90
  OpImageSampleProjImplicitLod                                            = 91
  OpImageSampleProjExplicitLod                                            = 92
  OpImageSampleProjDrefImplicitLod                                        = 93
  OpImageSampleProjDrefExplicitLod                                        = 94
  OpImageFetch                                                            = 95
  OpImageGather                                                           = 96
  OpImageDrefGather                                                       = 97
  OpImageRead                                                             = 98
  OpImageWrite                                                            = 99
  OpImage                                                                 = 100
  OpImageQueryFormat                                                      = 101
  OpImageQueryOrder                                                       = 102
  OpImageQuerySizeLod                                                     = 103
  OpImageQuerySize                                                        = 104
  OpImageQueryLod                                                         = 105
  OpImageQueryLevels                                                      = 106
  OpImageQuerySamples                                                     = 107
  OpConvertFToU                                                           = 109
  OpConvertFToS                                                           = 110
  OpConvertSToF                                                           = 111
  OpConvertUToF                                                           = 112
  OpUConvert                                                              = 113
  OpSConvert                                                              = 114
  OpFConvert                                                              = 115
  OpQuantizeToF16                                                         = 116
  OpConvertPtrToU                                                         = 117
  OpSatConvertSToU                                                        = 118
  OpSatConvertUToS                                                        = 119
  OpConvertUToPtr                                                         = 120
  OpPtrCastToGeneric                                                      = 121
  OpGenericCastToPtr                                                      = 122
  OpGenericCastToPtrExplicit                                              = 123
  OpBitcast                                                               = 124
  OpSNegate                                                               = 126
  OpFNegate                                                               = 127
  OpIAdd                                                                  = 128
  OpFAdd                                                                  = 129
  OpISub                                                                  = 130
  OpFSub                                                                  = 131
  OpIMul                                                                  = 132
  OpFMul                                                                  = 133
  OpUDiv                                                                  = 134
  OpSDiv                                                                  = 135
  OpFDiv                                                                  = 136
  OpUMod                                                                  = 137
  OpSRem                                                                  = 138
  OpSMod                                                                  = 139
  OpFRem                                                                  = 140
  OpFMod                                                                  = 141
  OpVectorTimesScalar                                                     = 142
  OpMatrixTimesScalar                                                     = 143
  OpVectorTimesMatrix                                                     = 144
  OpMatrixTimesVector                                                     = 145
  OpMatrixTimesMatrix                                                     = 146
  OpOuterProduct                                                          = 147
  OpDot                                                                   = 148
  OpIAddCarry                                                             = 149
  OpISubBorrow                                                            = 150
  OpUMulExtended                                                          = 151
  OpSMulExtended                                                          = 152
  OpAny                                                                   = 154
  OpAll                                                                   = 155
  OpIsNan                                                                 = 156
  OpIsInf                                                                 = 157
  OpIsFinite                                                              = 158
  OpIsNormal                                                              = 159
  OpSignBitSet                                                            = 160
  OpLessOrGreater                                                         = 161
  OpOrdered                                                               = 162
  OpUnordered                                                             = 163
  OpLogicalEqual                                                          = 164
  OpLogicalNotEqual                                                       = 165
  OpLogicalOr                                                             = 166
  OpLogicalAnd                                                            = 167
  OpLogicalNot                                                            = 168
  OpSelect                                                                = 169
  OpIEqual                                                                = 170
  OpINotEqual                                                             = 171
  OpUGreaterThan                                                          = 172
  OpSGreaterThan                                                          = 173
  OpUGreaterThanEqual                                                     = 174
  OpSGreaterThanEqual                                                     = 175
  OpULessThan                                                             = 176
  OpSLessThan                                                             = 177
  OpULessThanEqual                                                        = 178
  OpSLessThanEqual                                                        = 179
  OpFOrdEqual                                                             = 180
  OpFUnordEqual                                                           = 181
  OpFOrdNotEqual                                                          = 182
  OpFUnordNotEqual                                                        = 183
  OpFOrdLessThan                                                          = 184
  OpFUnordLessThan                                                        = 185
  OpFOrdGreaterThan                                                       = 186
  OpFUnordGreaterThan                                                     = 187
  OpFOrdLessThanEqual                                                     = 188
  OpFUnordLessThanEqual                                                   = 189
  OpFOrdGreaterThanEqual                                                  = 190
  OpFUnordGreaterThanEqual                                                = 191
  OpShiftRightLogical                                                     = 194
  OpShiftRightArithmetic                                                  = 195
  OpShiftLeftLogical                                                      = 196
  OpBitwiseOr                                                             = 197
  OpBitwiseXor                                                            = 198
  OpBitwiseAnd                                                            = 199
  OpNot                                                                   = 200
  OpBitFieldInsert                                                        = 201
  OpBitFieldSExtract                                                      = 202
  OpBitFieldUExtract                                                      = 203
  OpBitReverse                                                            = 204
  OpBitCount                                                              = 205
  OpDPdx                                                                  = 207
  OpDPdy                                                                  = 208
  OpFwidth                                                                = 209
  OpDPdxFine                                                              = 210
  OpDPdyFine                                                              = 211
  OpFwidthFine                                                            = 212
  OpDPdxCoarse                                                            = 213
  OpDPdyCoarse                                                            = 214
  OpFwidthCoarse                                                          = 215
  OpEmitVertex                                                            = 218
  OpEndPrimitive                                                          = 219
  OpEmitStreamVertex                                                      = 220
  OpEndStreamPrimitive                                                    = 221
  OpControlBarrier                                                        = 224
  OpMemoryBarrier                                                         = 225
  OpAtomicLoad                                                            = 227
  OpAtomicStore                                                           = 228
  OpAtomicExchange                                                        = 229
  OpAtomicCompareExchange                                                 = 230
  OpAtomicCompareExchangeWeak                                             = 231
  OpAtomicIIncrement                                                      = 232
  OpAtomicIDecrement                                                      = 233
  OpAtomicIAdd                                                            = 234
  OpAtomicISub                                                            = 235
  OpAtomicSMin                                                            = 236
  OpAtomicUMin                                                            = 237
  OpAtomicSMax                                                            = 238
  OpAtomicUMax                                                            = 239
  OpAtomicAnd                                                             = 240
  OpAtomicOr                                                              = 241
  OpAtomicXor                                                             = 242
  OpPhi                                                                   = 245
  OpLoopMerge                                                             = 246
  OpSelectionMerge                                                        = 247
  OpLabel                                                                 = 248
  OpBranch                                                                = 249
  OpBranchConditional                                                     = 250
  OpSwitch                                                                = 251
  OpKill                                                                  = 252
  OpReturn                                                                = 253
  OpReturnValue                                                           = 254
  OpUnreachable                                                           = 255
  OpLifetimeStart                                                         = 256
  OpLifetimeStop                                                          = 257
  OpGroupAsyncCopy                                                        = 259
  OpGroupWaitEvents                                                       = 260
  OpGroupAll                                                              = 261
  OpGroupAny                                                              = 262
  OpGroupBroadcast                                                        = 263
  OpGroupIAdd                                                             = 264
  OpGroupFAdd                                                             = 265
  OpGroupFMin                                                             = 266
  OpGroupUMin                                                             = 267
  OpGroupSMin                                                             = 268
  OpGroupFMax                                                             = 269
  OpGroupUMax                                                             = 270
  OpGroupSMax                                                             = 271
  OpReadPipe                                                              = 274
  OpWritePipe                                                             = 275
  OpReservedReadPipe                                                      = 276
  OpReservedWritePipe                                                     = 277
  OpReserveReadPipePackets                                                = 278
  OpReserveWritePipePackets                                               = 279
  OpCommitReadPipe                                                        = 280
  OpCommitWritePipe                                                       = 281
  OpIsValidReserveId                                                      = 282
  OpGetNumPipePackets                                                     = 283
  OpGetMaxPipePackets                                                     = 284
  OpGroupReserveReadPipePackets                                           = 285
  OpGroupReserveWritePipePackets                                          = 286
  OpGroupCommitReadPipe                                                   = 287
  OpGroupCommitWritePipe                                                  = 288
  OpEnqueueMarker                                                         = 291
  OpEnqueueKernel                                                         = 292
  OpGetKernelNDrangeSubGroupCount                                         = 293
  OpGetKernelNDrangeMaxSubGroupSize                                       = 294
  OpGetKernelWorkGroupSize                                                = 295
  OpGetKernelPreferredWorkGroupSizeMultiple                               = 296
  OpRetainEvent                                                           = 297
  OpReleaseEvent                                                          = 298
  OpCreateUserEvent                                                       = 299
  OpIsValidEvent                                                          = 300
  OpSetUserEventStatus                                                    = 301
  OpCaptureEventProfilingInfo                                             = 302
  OpGetDefaultQueue                                                       = 303
  OpBuildNDRange                                                          = 304
  OpImageSparseSampleImplicitLod                                          = 305
  OpImageSparseSampleExplicitLod                                          = 306
  OpImageSparseSampleDrefImplicitLod                                      = 307
  OpImageSparseSampleDrefExplicitLod                                      = 308
  OpImageSparseSampleProjImplicitLod                                      = 309
  OpImageSparseSampleProjExplicitLod                                      = 310
  OpImageSparseSampleProjDrefImplicitLod                                  = 311
  OpImageSparseSampleProjDrefExplicitLod                                  = 312
  OpImageSparseFetch                                                      = 313
  OpImageSparseGather                                                     = 314
  OpImageSparseDrefGather                                                 = 315
  OpImageSparseTexelsResident                                             = 316
  OpNoLine                                                                = 317
  OpAtomicFlagTestAndSet                                                  = 318
  OpAtomicFlagClear                                                       = 319
  OpImageSparseRead                                                       = 320
  OpSizeOf                                                                = 321
  OpTypePipeStorage                                                       = 322
  OpConstantPipeStorage                                                   = 323
  OpCreatePipeFromPipeStorage                                             = 324
  OpGetKernelLocalSizeForSubgroupCount                                    = 325
  OpGetKernelMaxNumSubgroups                                              = 326
  OpTypeNamedBarrier                                                      = 327
  OpNamedBarrierInitialize                                                = 328
  OpMemoryNamedBarrier                                                    = 329
  OpModuleProcessed                                                       = 330
  OpExecutionModeId                                                       = 331
  OpDecorateId                                                            = 332
  OpGroupNonUniformElect                                                  = 333
  OpGroupNonUniformAll                                                    = 334
  OpGroupNonUniformAny                                                    = 335
  OpGroupNonUniformAllEqual                                               = 336
  OpGroupNonUniformBroadcast                                              = 337
  OpGroupNonUniformBroadcastFirst                                         = 338
  OpGroupNonUniformBallot                                                 = 339
  OpGroupNonUniformInverseBallot                                          = 340
  OpGroupNonUniformBallotBitExtract                                       = 341
  OpGroupNonUniformBallotBitCount                                         = 342
  OpGroupNonUniformBallotFindLSB                                          = 343
  OpGroupNonUniformBallotFindMSB                                          = 344
  OpGroupNonUniformShuffle                                                = 345
  OpGroupNonUniformShuffleXor                                             = 346
  OpGroupNonUniformShuffleUp                                              = 347
  OpGroupNonUniformShuffleDown                                            = 348
  OpGroupNonUniformIAdd                                                   = 349
  OpGroupNonUniformFAdd                                                   = 350
  OpGroupNonUniformIMul                                                   = 351
  OpGroupNonUniformFMul                                                   = 352
  OpGroupNonUniformSMin                                                   = 353
  OpGroupNonUniformUMin                                                   = 354
  OpGroupNonUniformFMin                                                   = 355
  OpGroupNonUniformSMax                                                   = 356
  OpGroupNonUniformUMax                                                   = 357
  OpGroupNonUniformFMax                                                   = 358
  OpGroupNonUniformBitwiseAnd                                             = 359
  OpGroupNonUniformBitwiseOr                                              = 360
  OpGroupNonUniformBitwiseXor                                             = 361
  OpGroupNonUniformLogicalAnd                                             = 362
  OpGroupNonUniformLogicalOr                                              = 363
  OpGroupNonUniformLogicalXor                                             = 364
  OpGroupNonUniformQuadBroadcast                                          = 365
  OpGroupNonUniformQuadSwap                                               = 366
  OpCopyLogical                                                           = 400
  OpPtrEqual                                                              = 401
  OpPtrNotEqual                                                           = 402
  OpPtrDiff                                                               = 403
  OpTerminateInvocation                                                   = 4416
  OpSubgroupBallotKHR                                                     = 4421
  OpSubgroupFirstInvocationKHR                                            = 4422
  OpSubgroupAllKHR                                                        = 4428
  OpSubgroupAnyKHR                                                        = 4429
  OpSubgroupAllEqualKHR                                                   = 4430
  OpGroupNonUniformRotateKHR                                              = 4431
  OpSubgroupReadInvocationKHR                                             = 4432
  OpTraceRayKHR                                                           = 4445
  OpExecuteCallableKHR                                                    = 4446
  OpConvertUToAccelerationStructureKHR                                    = 4447
  OpIgnoreIntersectionKHR                                                 = 4448
  OpTerminateRayKHR                                                       = 4449
  OpSDot                                                                  = 4450
  OpSDotKHR                                                               = 4450
  OpUDot                                                                  = 4451
  OpUDotKHR                                                               = 4451
  OpSUDot                                                                 = 4452
  OpSUDotKHR                                                              = 4452
  OpSDotAccSat                                                            = 4453
  OpSDotAccSatKHR                                                         = 4453
  OpUDotAccSat                                                            = 4454
  OpUDotAccSatKHR                                                         = 4454
  OpSUDotAccSat                                                           = 4455
  OpSUDotAccSatKHR                                                        = 4455
  OpTypeRayQueryKHR                                                       = 4472
  OpRayQueryInitializeKHR                                                 = 4473
  OpRayQueryTerminateKHR                                                  = 4474
  OpRayQueryGenerateIntersectionKHR                                       = 4475
  OpRayQueryConfirmIntersectionKHR                                        = 4476
  OpRayQueryProceedKHR                                                    = 4477
  OpRayQueryGetIntersectionTypeKHR                                        = 4479
  OpGroupIAddNonUniformAMD                                                = 5000
  OpGroupFAddNonUniformAMD                                                = 5001
  OpGroupFMinNonUniformAMD                                                = 5002
  OpGroupUMinNonUniformAMD                                                = 5003
  OpGroupSMinNonUniformAMD                                                = 5004
  OpGroupFMaxNonUniformAMD                                                = 5005
  OpGroupUMaxNonUniformAMD                                                = 5006
  OpGroupSMaxNonUniformAMD                                                = 5007
  OpFragmentMaskFetchAMD                                                  = 5011
  OpFragmentFetchAMD                                                      = 5012
  OpReadClockKHR                                                          = 5056
  OpHitObjectRecordHitMotionNV                                            = 5249
  OpHitObjectRecordHitWithIndexMotionNV                                   = 5250
  OpHitObjectRecordMissMotionNV                                           = 5251
  OpHitObjectGetWorldToObjectNV                                           = 5252
  OpHitObjectGetObjectToWorldNV                                           = 5253
  OpHitObjectGetObjectRayDirectionNV                                      = 5254
  OpHitObjectGetObjectRayOriginNV                                         = 5255
  OpHitObjectTraceRayMotionNV                                             = 5256
  OpHitObjectGetShaderRecordBufferHandleNV                                = 5257
  OpHitObjectGetShaderBindingTableRecordIndexNV                           = 5258
  OpHitObjectRecordEmptyNV                                                = 5259
  OpHitObjectTraceRayNV                                                   = 5260
  OpHitObjectRecordHitNV                                                  = 5261
  OpHitObjectRecordHitWithIndexNV                                         = 5262
  OpHitObjectRecordMissNV                                                 = 5263
  OpHitObjectExecuteShaderNV                                              = 5264
  OpHitObjectGetCurrentTimeNV                                             = 5265
  OpHitObjectGetAttributesNV                                              = 5266
  OpHitObjectGetHitKindNV                                                 = 5267
  OpHitObjectGetPrimitiveIndexNV                                          = 5268
  OpHitObjectGetGeometryIndexNV                                           = 5269
  OpHitObjectGetInstanceIdNV                                              = 5270
  OpHitObjectGetInstanceCustomIndexNV                                     = 5271
  OpHitObjectGetWorldRayDirectionNV                                       = 5272
  OpHitObjectGetWorldRayOriginNV                                          = 5273
  OpHitObjectGetRayTMaxNV                                                 = 5274
  OpHitObjectGetRayTMinNV                                                 = 5275
  OpHitObjectIsEmptyNV                                                    = 5276
  OpHitObjectIsHitNV                                                      = 5277
  OpHitObjectIsMissNV                                                     = 5278
  OpReorderThreadWithHitObjectNV                                          = 5279
  OpReorderThreadWithHintNV                                               = 5280
  OpTypeHitObjectNV                                                       = 5281
  OpImageSampleFootprintNV                                                = 5283
  OpEmitMeshTasksEXT                                                      = 5294
  OpSetMeshOutputsEXT                                                     = 5295
  OpGroupNonUniformPartitionNV                                            = 5296
  OpWritePackedPrimitiveIndices4x8NV                                      = 5299
  OpReportIntersectionNV                                                  = 5334
  OpReportIntersectionKHR                                                 = 5334
  OpIgnoreIntersectionNV                                                  = 5335
  OpTerminateRayNV                                                        = 5336
  OpTraceNV                                                               = 5337
  OpTraceMotionNV                                                         = 5338
  OpTraceRayMotionNV                                                      = 5339
  OpTypeAccelerationStructureNV                                           = 5341
  OpTypeAccelerationStructureKHR                                          = 5341
  OpExecuteCallableNV                                                     = 5344
  OpTypeCooperativeMatrixNV                                               = 5358
  OpCooperativeMatrixLoadNV                                               = 5359
  OpCooperativeMatrixStoreNV                                              = 5360
  OpCooperativeMatrixMulAddNV                                             = 5361
  OpCooperativeMatrixLengthNV                                             = 5362
  OpBeginInvocationInterlockEXT                                           = 5364
  OpEndInvocationInterlockEXT                                             = 5365
  OpDemoteToHelperInvocation                                              = 5380
  OpDemoteToHelperInvocationEXT                                           = 5380
  OpIsHelperInvocationEXT                                                 = 5381
  OpConvertUToImageNV                                                     = 5391
  OpConvertUToSamplerNV                                                   = 5392
  OpConvertImageToUNV                                                     = 5393
  OpConvertSamplerToUNV                                                   = 5394
  OpConvertUToSampledImageNV                                              = 5395
  OpConvertSampledImageToUNV                                              = 5396
  OpSamplerImageAddressingModeNV                                          = 5397
  OpSubgroupShuffleINTEL                                                  = 5571
  OpSubgroupShuffleDownINTEL                                              = 5572
  OpSubgroupShuffleUpINTEL                                                = 5573
  OpSubgroupShuffleXorINTEL                                               = 5574
  OpSubgroupBlockReadINTEL                                                = 5575
  OpSubgroupBlockWriteINTEL                                               = 5576
  OpSubgroupImageBlockReadINTEL                                           = 5577
  OpSubgroupImageBlockWriteINTEL                                          = 5578
  OpSubgroupImageMediaBlockReadINTEL                                      = 5580
  OpSubgroupImageMediaBlockWriteINTEL                                     = 5581
  OpUCountLeadingZerosINTEL                                               = 5585
  OpUCountTrailingZerosINTEL                                              = 5586
  OpAbsISubINTEL                                                          = 5587
  OpAbsUSubINTEL                                                          = 5588
  OpIAddSatINTEL                                                          = 5589
  OpUAddSatINTEL                                                          = 5590
  OpIAverageINTEL                                                         = 5591
  OpUAverageINTEL                                                         = 5592
  OpIAverageRoundedINTEL                                                  = 5593
  OpUAverageRoundedINTEL                                                  = 5594
  OpISubSatINTEL                                                          = 5595
  OpUSubSatINTEL                                                          = 5596
  OpIMul32x16INTEL                                                        = 5597
  OpUMul32x16INTEL                                                        = 5598
  OpConstantFunctionPointerINTEL                                          = 5600
  OpFunctionPointerCallINTEL                                              = 5601
  OpAsmTargetINTEL                                                        = 5609
  OpAsmINTEL                                                              = 5610
  OpAsmCallINTEL                                                          = 5611
  OpAtomicFMinEXT                                                         = 5614
  OpAtomicFMaxEXT                                                         = 5615
  OpAssumeTrueKHR                                                         = 5630
  OpExpectKHR                                                             = 5631
  OpDecorateString                                                        = 5632
  OpDecorateStringGOOGLE                                                  = 5632
  OpMemberDecorateString                                                  = 5633
  OpMemberDecorateStringGOOGLE                                            = 5633
  OpVmeImageINTEL                                                         = 5699
  OpTypeVmeImageINTEL                                                     = 5700
  OpTypeAvcImePayloadINTEL                                                = 5701
  OpTypeAvcRefPayloadINTEL                                                = 5702
  OpTypeAvcSicPayloadINTEL                                                = 5703
  OpTypeAvcMcePayloadINTEL                                                = 5704
  OpTypeAvcMceResultINTEL                                                 = 5705
  OpTypeAvcImeResultINTEL                                                 = 5706
  OpTypeAvcImeResultSingleReferenceStreamoutINTEL                         = 5707
  OpTypeAvcImeResultDualReferenceStreamoutINTEL                           = 5708
  OpTypeAvcImeSingleReferenceStreaminINTEL                                = 5709
  OpTypeAvcImeDualReferenceStreaminINTEL                                  = 5710
  OpTypeAvcRefResultINTEL                                                 = 5711
  OpTypeAvcSicResultINTEL                                                 = 5712
  OpSubgroupAvcMceGetDefaultInterBaseMultiReferencePenaltyINTEL           = 5713
  OpSubgroupAvcMceSetInterBaseMultiReferencePenaltyINTEL                  = 5714
  OpSubgroupAvcMceGetDefaultInterShapePenaltyINTEL                        = 5715
  OpSubgroupAvcMceSetInterShapePenaltyINTEL                               = 5716
  OpSubgroupAvcMceGetDefaultInterDirectionPenaltyINTEL                    = 5717
  OpSubgroupAvcMceSetInterDirectionPenaltyINTEL                           = 5718
  OpSubgroupAvcMceGetDefaultIntraLumaShapePenaltyINTEL                    = 5719
  OpSubgroupAvcMceGetDefaultInterMotionVectorCostTableINTEL               = 5720
  OpSubgroupAvcMceGetDefaultHighPenaltyCostTableINTEL                     = 5721
  OpSubgroupAvcMceGetDefaultMediumPenaltyCostTableINTEL                   = 5722
  OpSubgroupAvcMceGetDefaultLowPenaltyCostTableINTEL                      = 5723
  OpSubgroupAvcMceSetMotionVectorCostFunctionINTEL                        = 5724
  OpSubgroupAvcMceGetDefaultIntraLumaModePenaltyINTEL                     = 5725
  OpSubgroupAvcMceGetDefaultNonDcLumaIntraPenaltyINTEL                    = 5726
  OpSubgroupAvcMceGetDefaultIntraChromaModeBasePenaltyINTEL               = 5727
  OpSubgroupAvcMceSetAcOnlyHaarINTEL                                      = 5728
  OpSubgroupAvcMceSetSourceInterlacedFieldPolarityINTEL                   = 5729
  OpSubgroupAvcMceSetSingleReferenceInterlacedFieldPolarityINTEL          = 5730
  OpSubgroupAvcMceSetDualReferenceInterlacedFieldPolaritiesINTEL          = 5731
  OpSubgroupAvcMceConvertToImePayloadINTEL                                = 5732
  OpSubgroupAvcMceConvertToImeResultINTEL                                 = 5733
  OpSubgroupAvcMceConvertToRefPayloadINTEL                                = 5734
  OpSubgroupAvcMceConvertToRefResultINTEL                                 = 5735
  OpSubgroupAvcMceConvertToSicPayloadINTEL                                = 5736
  OpSubgroupAvcMceConvertToSicResultINTEL                                 = 5737
  OpSubgroupAvcMceGetMotionVectorsINTEL                                   = 5738
  OpSubgroupAvcMceGetInterDistortionsINTEL                                = 5739
  OpSubgroupAvcMceGetBestInterDistortionsINTEL                            = 5740
  OpSubgroupAvcMceGetInterMajorShapeINTEL                                 = 5741
  OpSubgroupAvcMceGetInterMinorShapeINTEL                                 = 5742
  OpSubgroupAvcMceGetInterDirectionsINTEL                                 = 5743
  OpSubgroupAvcMceGetInterMotionVectorCountINTEL                          = 5744
  OpSubgroupAvcMceGetInterReferenceIdsINTEL                               = 5745
  OpSubgroupAvcMceGetInterReferenceInterlacedFieldPolaritiesINTEL         = 5746
  OpSubgroupAvcImeInitializeINTEL                                         = 5747
  OpSubgroupAvcImeSetSingleReferenceINTEL                                 = 5748
  OpSubgroupAvcImeSetDualReferenceINTEL                                   = 5749
  OpSubgroupAvcImeRefWindowSizeINTEL                                      = 5750
  OpSubgroupAvcImeAdjustRefOffsetINTEL                                    = 5751
  OpSubgroupAvcImeConvertToMcePayloadINTEL                                = 5752
  OpSubgroupAvcImeSetMaxMotionVectorCountINTEL                            = 5753
  OpSubgroupAvcImeSetUnidirectionalMixDisableINTEL                        = 5754
  OpSubgroupAvcImeSetEarlySearchTerminationThresholdINTEL                 = 5755
  OpSubgroupAvcImeSetWeightedSadINTEL                                     = 5756
  OpSubgroupAvcImeEvaluateWithSingleReferenceINTEL                        = 5757
  OpSubgroupAvcImeEvaluateWithDualReferenceINTEL                          = 5758
  OpSubgroupAvcImeEvaluateWithSingleReferenceStreaminINTEL                = 5759
  OpSubgroupAvcImeEvaluateWithDualReferenceStreaminINTEL                  = 5760
  OpSubgroupAvcImeEvaluateWithSingleReferenceStreamoutINTEL               = 5761
  OpSubgroupAvcImeEvaluateWithDualReferenceStreamoutINTEL                 = 5762
  OpSubgroupAvcImeEvaluateWithSingleReferenceStreaminoutINTEL             = 5763
  OpSubgroupAvcImeEvaluateWithDualReferenceStreaminoutINTEL               = 5764
  OpSubgroupAvcImeConvertToMceResultINTEL                                 = 5765
  OpSubgroupAvcImeGetSingleReferenceStreaminINTEL                         = 5766
  OpSubgroupAvcImeGetDualReferenceStreaminINTEL                           = 5767
  OpSubgroupAvcImeStripSingleReferenceStreamoutINTEL                      = 5768
  OpSubgroupAvcImeStripDualReferenceStreamoutINTEL                        = 5769
  OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeMotionVectorsINTEL = 5770
  OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeDistortionsINTEL   = 5771
  OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeReferenceIdsINTEL  = 5772
  OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeMotionVectorsINTEL   = 5773
  OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeDistortionsINTEL     = 5774
  OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeReferenceIdsINTEL    = 5775
  OpSubgroupAvcImeGetBorderReachedINTEL                                   = 5776
  OpSubgroupAvcImeGetTruncatedSearchIndicationINTEL                       = 5777
  OpSubgroupAvcImeGetUnidirectionalEarlySearchTerminationINTEL            = 5778
  OpSubgroupAvcImeGetWeightingPatternMinimumMotionVectorINTEL             = 5779
  OpSubgroupAvcImeGetWeightingPatternMinimumDistortionINTEL               = 5780
  OpSubgroupAvcFmeInitializeINTEL                                         = 5781
  OpSubgroupAvcBmeInitializeINTEL                                         = 5782
  OpSubgroupAvcRefConvertToMcePayloadINTEL                                = 5783
  OpSubgroupAvcRefSetBidirectionalMixDisableINTEL                         = 5784
  OpSubgroupAvcRefSetBilinearFilterEnableINTEL                            = 5785
  OpSubgroupAvcRefEvaluateWithSingleReferenceINTEL                        = 5786
  OpSubgroupAvcRefEvaluateWithDualReferenceINTEL                          = 5787
  OpSubgroupAvcRefEvaluateWithMultiReferenceINTEL                         = 5788
  OpSubgroupAvcRefEvaluateWithMultiReferenceInterlacedINTEL               = 5789
  OpSubgroupAvcRefConvertToMceResultINTEL                                 = 5790
  OpSubgroupAvcSicInitializeINTEL                                         = 5791
  OpSubgroupAvcSicConfigureSkcINTEL                                       = 5792
  OpSubgroupAvcSicConfigureIpeLumaINTEL                                   = 5793
  OpSubgroupAvcSicConfigureIpeLumaChromaINTEL                             = 5794
  OpSubgroupAvcSicGetMotionVectorMaskINTEL                                = 5795
  OpSubgroupAvcSicConvertToMcePayloadINTEL                                = 5796
  OpSubgroupAvcSicSetIntraLumaShapePenaltyINTEL                           = 5797
  OpSubgroupAvcSicSetIntraLumaModeCostFunctionINTEL                       = 5798
  OpSubgroupAvcSicSetIntraChromaModeCostFunctionINTEL                     = 5799
  OpSubgroupAvcSicSetBilinearFilterEnableINTEL                            = 5800
  OpSubgroupAvcSicSetSkcForwardTransformEnableINTEL                       = 5801
  OpSubgroupAvcSicSetBlockBasedRawSkipSadINTEL                            = 5802
  OpSubgroupAvcSicEvaluateIpeINTEL                                        = 5803
  OpSubgroupAvcSicEvaluateWithSingleReferenceINTEL                        = 5804
  OpSubgroupAvcSicEvaluateWithDualReferenceINTEL                          = 5805
  OpSubgroupAvcSicEvaluateWithMultiReferenceINTEL                         = 5806
  OpSubgroupAvcSicEvaluateWithMultiReferenceInterlacedINTEL               = 5807
  OpSubgroupAvcSicConvertToMceResultINTEL                                 = 5808
  OpSubgroupAvcSicGetIpeLumaShapeINTEL                                    = 5809
  OpSubgroupAvcSicGetBestIpeLumaDistortionINTEL                           = 5810
  OpSubgroupAvcSicGetBestIpeChromaDistortionINTEL                         = 5811
  OpSubgroupAvcSicGetPackedIpeLumaModesINTEL                              = 5812
  OpSubgroupAvcSicGetIpeChromaModeINTEL                                   = 5813
  OpSubgroupAvcSicGetPackedSkcLumaCountThresholdINTEL                     = 5814
  OpSubgroupAvcSicGetPackedSkcLumaSumThresholdINTEL                       = 5815
  OpSubgroupAvcSicGetInterRawSadsINTEL                                    = 5816
  OpVariableLengthArrayINTEL                                              = 5818
  OpSaveMemoryINTEL                                                       = 5819
  OpRestoreMemoryINTEL                                                    = 5820
  OpArbitraryFloatSinCosPiINTEL                                           = 5840
  OpArbitraryFloatCastINTEL                                               = 5841
  OpArbitraryFloatCastFromIntINTEL                                        = 5842
  OpArbitraryFloatCastToIntINTEL                                          = 5843
  OpArbitraryFloatAddINTEL                                                = 5846
  OpArbitraryFloatSubINTEL                                                = 5847
  OpArbitraryFloatMulINTEL                                                = 5848
  OpArbitraryFloatDivINTEL                                                = 5849
  OpArbitraryFloatGTINTEL                                                 = 5850
  OpArbitraryFloatGEINTEL                                                 = 5851
  OpArbitraryFloatLTINTEL                                                 = 5852
  OpArbitraryFloatLEINTEL                                                 = 5853
  OpArbitraryFloatEQINTEL                                                 = 5854
  OpArbitraryFloatRecipINTEL                                              = 5855
  OpArbitraryFloatRSqrtINTEL                                              = 5856
  OpArbitraryFloatCbrtINTEL                                               = 5857
  OpArbitraryFloatHypotINTEL                                              = 5858
  OpArbitraryFloatSqrtINTEL                                               = 5859
  OpArbitraryFloatLogINTEL                                                = 5860
  OpArbitraryFloatLog2INTEL                                               = 5861
  OpArbitraryFloatLog10INTEL                                              = 5862
  OpArbitraryFloatLog1pINTEL                                              = 5863
  OpArbitraryFloatExpINTEL                                                = 5864
  OpArbitraryFloatExp2INTEL                                               = 5865
  OpArbitraryFloatExp10INTEL                                              = 5866
  OpArbitraryFloatExpm1INTEL                                              = 5867
  OpArbitraryFloatSinINTEL                                                = 5868
  OpArbitraryFloatCosINTEL                                                = 5869
  OpArbitraryFloatSinCosINTEL                                             = 5870
  OpArbitraryFloatSinPiINTEL                                              = 5871
  OpArbitraryFloatCosPiINTEL                                              = 5872
  OpArbitraryFloatASinINTEL                                               = 5873
  OpArbitraryFloatASinPiINTEL                                             = 5874
  OpArbitraryFloatACosINTEL                                               = 5875
  OpArbitraryFloatACosPiINTEL                                             = 5876
  OpArbitraryFloatATanINTEL                                               = 5877
  OpArbitraryFloatATanPiINTEL                                             = 5878
  OpArbitraryFloatATan2INTEL                                              = 5879
  OpArbitraryFloatPowINTEL                                                = 5880
  OpArbitraryFloatPowRINTEL                                               = 5881
  OpArbitraryFloatPowNINTEL                                               = 5882
  OpLoopControlINTEL                                                      = 5887
  OpAliasDomainDeclINTEL                                                  = 5911
  OpAliasScopeDeclINTEL                                                   = 5912
  OpAliasScopeListDeclINTEL                                               = 5913
  OpFixedSqrtINTEL                                                        = 5923
  OpFixedRecipINTEL                                                       = 5924
  OpFixedRsqrtINTEL                                                       = 5925
  OpFixedSinINTEL                                                         = 5926
  OpFixedCosINTEL                                                         = 5927
  OpFixedSinCosINTEL                                                      = 5928
  OpFixedSinPiINTEL                                                       = 5929
  OpFixedCosPiINTEL                                                       = 5930
  OpFixedSinCosPiINTEL                                                    = 5931
  OpFixedLogINTEL                                                         = 5932
  OpFixedExpINTEL                                                         = 5933
  OpPtrCastToCrossWorkgroupINTEL                                          = 5934
  OpCrossWorkgroupCastToPtrINTEL                                          = 5938
  OpReadPipeBlockingINTEL                                                 = 5946
  OpWritePipeBlockingINTEL                                                = 5947
  OpFPGARegINTEL                                                          = 5949
  OpRayQueryGetRayTMinKHR                                                 = 6016
  OpRayQueryGetRayFlagsKHR                                                = 6017
  OpRayQueryGetIntersectionTKHR                                           = 6018
  OpRayQueryGetIntersectionInstanceCustomIndexKHR                         = 6019
  OpRayQueryGetIntersectionInstanceIdKHR                                  = 6020
  OpRayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR      = 6021
  OpRayQueryGetIntersectionGeometryIndexKHR                               = 6022
  OpRayQueryGetIntersectionPrimitiveIndexKHR                              = 6023
  OpRayQueryGetIntersectionBarycentricsKHR                                = 6024
  OpRayQueryGetIntersectionFrontFaceKHR                                   = 6025
  OpRayQueryGetIntersectionCandidateAABBOpaqueKHR                         = 6026
  OpRayQueryGetIntersectionObjectRayDirectionKHR                          = 6027
  OpRayQueryGetIntersectionObjectRayOriginKHR                             = 6028
  OpRayQueryGetWorldRayDirectionKHR                                       = 6029
  OpRayQueryGetWorldRayOriginKHR                                          = 6030
  OpRayQueryGetIntersectionObjectToWorldKHR                               = 6031
  OpRayQueryGetIntersectionWorldToObjectKHR                               = 6032
  OpAtomicFAddEXT                                                         = 6035
  OpTypeBufferSurfaceINTEL                                                = 6086
  OpTypeStructContinuedINTEL                                              = 6090
  OpConstantCompositeContinuedINTEL                                       = 6091
  OpSpecConstantCompositeContinuedINTEL                                   = 6092
  OpControlBarrierArriveINTEL                                             = 6142
  OpControlBarrierWaitINTEL                                               = 6143
  OpGroupIMulKHR                                                          = 6401
  OpGroupFMulKHR                                                          = 6402
  OpGroupBitwiseAndKHR                                                    = 6403
  OpGroupBitwiseOrKHR                                                     = 6404
  OpGroupBitwiseXorKHR                                                    = 6405
  OpGroupLogicalAndKHR                                                    = 6406
  OpGroupLogicalOrKHR                                                     = 6407
  OpGroupLogicalXorKHR                                                    = 6408
end

const instruction_infos = Dict{OpCode,InstructionInfo}(
  OpNop => InstructionInfo("Miscellaneous", [], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpUndef => InstructionInfo(
    "Miscellaneous",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSourceContinued => InstructionInfo(
    "Debug",
    [OperandInfo(LiteralString, "'Continued Source'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSource => InstructionInfo(
    "Debug",
    [
      OperandInfo(SourceLanguage, nothing, nothing),
      OperandInfo(LiteralInteger, "'Version'", nothing),
      OperandInfo(IdRef, "'File'", "?"),
      OperandInfo(LiteralString, "'Source'", "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSourceExtension =>
    InstructionInfo("Debug", [OperandInfo(LiteralString, "'Extension'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpName => InstructionInfo(
    "Debug",
    [OperandInfo(IdRef, "'Target'", nothing), OperandInfo(LiteralString, "'Name'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpMemberName => InstructionInfo(
    "Debug",
    [OperandInfo(IdRef, "'Type'", nothing), OperandInfo(LiteralInteger, "'Member'", nothing), OperandInfo(LiteralString, "'Name'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpString => InstructionInfo(
    "Debug",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(LiteralString, "'String'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpLine => InstructionInfo(
    "Debug",
    [OperandInfo(IdRef, "'File'", nothing), OperandInfo(LiteralInteger, "'Line'", nothing), OperandInfo(LiteralInteger, "'Column'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpExtension =>
    InstructionInfo("Extension", [OperandInfo(LiteralString, "'Name'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpExtInstImport => InstructionInfo(
    "Extension",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(LiteralString, "'Name'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpExtInst => InstructionInfo(
    "Extension",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Set'", nothing),
      OperandInfo(LiteralExtInstInteger, "'Instruction'", nothing),
      OperandInfo(IdRef, "'Operand 1', +\n'Operand 2', +\n...", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpMemoryModel => InstructionInfo(
    "Mode-Setting",
    [OperandInfo(AddressingModel, nothing, nothing), OperandInfo(MemoryModel, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpEntryPoint => InstructionInfo(
    "Mode-Setting",
    [
      OperandInfo(ExecutionModel, nothing, nothing),
      OperandInfo(IdRef, "'Entry Point'", nothing),
      OperandInfo(LiteralString, "'Name'", nothing),
      OperandInfo(IdRef, "'Interface'", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpExecutionMode => InstructionInfo(
    "Mode-Setting",
    [OperandInfo(IdRef, "'Entry Point'", nothing), OperandInfo(ExecutionMode, "'Mode'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpCapability => InstructionInfo(
    "Mode-Setting",
    [OperandInfo(Capability, "'Capability'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpTypeVoid =>
    InstructionInfo("Type-Declaration", [OperandInfo(IdResult, nothing, nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpTypeBool =>
    InstructionInfo("Type-Declaration", [OperandInfo(IdResult, nothing, nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpTypeInt => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(LiteralInteger, "'Width'", nothing), OperandInfo(LiteralInteger, "'Signedness'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpTypeFloat => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(LiteralInteger, "'Width'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpTypeVector => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Component Type'", nothing),
      OperandInfo(LiteralInteger, "'Component Count'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpTypeMatrix => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Column Type'", nothing), OperandInfo(LiteralInteger, "'Column Count'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMatrix]),
  ),
  OpTypeImage => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Type'", nothing),
      OperandInfo(Dim, nothing, nothing),
      OperandInfo(LiteralInteger, "'Depth'", nothing),
      OperandInfo(LiteralInteger, "'Arrayed'", nothing),
      OperandInfo(LiteralInteger, "'MS'", nothing),
      OperandInfo(LiteralInteger, "'Sampled'", nothing),
      OperandInfo(ImageFormat, nothing, nothing),
      OperandInfo(AccessQualifier, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpTypeSampler =>
    InstructionInfo("Type-Declaration", [OperandInfo(IdResult, nothing, nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpTypeSampledImage => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Image Type'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpTypeArray => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Element Type'", nothing), OperandInfo(IdRef, "'Length'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpTypeRuntimeArray => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Element Type'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpTypeStruct => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Member 0 type', +\n'member 1 type', +\n...", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpTypeOpaque => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(LiteralString, "The name of the opaque type.", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpTypePointer => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(StorageClass, nothing, nothing), OperandInfo(IdRef, "'Type'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpTypeFunction => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Return Type'", nothing),
      OperandInfo(IdRef, "'Parameter 0 Type', +\n'Parameter 1 Type', +\n...", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpTypeEvent => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpTypeDeviceEvent => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpTypeReserveId => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpTypeQueue => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpTypePipe => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(AccessQualifier, "'Qualifier'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpTypeForwardPointer => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdRef, "'Pointer Type'", nothing), OperandInfo(StorageClass, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAddresses, CapabilityPhysicalStorageBufferAddresses]),
  ),
  OpConstantTrue => InstructionInfo(
    "Constant-Creation",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpConstantFalse => InstructionInfo(
    "Constant-Creation",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpConstant => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(LiteralContextDependentNumber, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpConstantComposite => InstructionInfo(
    "Constant-Creation",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Constituents'", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpConstantSampler => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(SamplerAddressingMode, nothing, nothing),
      OperandInfo(LiteralInteger, "'Param'", nothing),
      OperandInfo(SamplerFilterMode, nothing, nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityLiteralSampler]),
  ),
  OpConstantNull => InstructionInfo(
    "Constant-Creation",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSpecConstantTrue => InstructionInfo(
    "Constant-Creation",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSpecConstantFalse => InstructionInfo(
    "Constant-Creation",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSpecConstant => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(LiteralContextDependentNumber, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSpecConstantComposite => InstructionInfo(
    "Constant-Creation",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Constituents'", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSpecConstantOp => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(LiteralSpecConstantOpInteger, "'Opcode'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFunction => InstructionInfo(
    "Function",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(FunctionControl, nothing, nothing),
      OperandInfo(IdRef, "'Function Type'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFunctionParameter => InstructionInfo(
    "Function",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFunctionEnd => InstructionInfo("Function", [], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpFunctionCall => InstructionInfo(
    "Function",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Function'", nothing),
      OperandInfo(IdRef, "'Argument 0', +\n'Argument 1', +\n...", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpVariable => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(StorageClass, nothing, nothing),
      OperandInfo(IdRef, "'Initializer'", "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpImageTexelPointer => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'Sample'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpLoad => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(MemoryAccess, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpStore => InstructionInfo(
    "Memory",
    [OperandInfo(IdRef, "'Pointer'", nothing), OperandInfo(IdRef, "'Object'", nothing), OperandInfo(MemoryAccess, nothing, "?")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpCopyMemory => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdRef, "'Target'", nothing),
      OperandInfo(IdRef, "'Source'", nothing),
      OperandInfo(MemoryAccess, nothing, "?"),
      OperandInfo(MemoryAccess, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpCopyMemorySized => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdRef, "'Target'", nothing),
      OperandInfo(IdRef, "'Source'", nothing),
      OperandInfo(IdRef, "'Size'", nothing),
      OperandInfo(MemoryAccess, nothing, "?"),
      OperandInfo(MemoryAccess, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAddresses]),
  ),
  OpAccessChain => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Indexes'", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpInBoundsAccessChain => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Indexes'", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpPtrAccessChain => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Element'", nothing),
      OperandInfo(IdRef, "'Indexes'", "*"),
    ],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilityAddresses, CapabilityVariablePointers, CapabilityVariablePointersStorageBuffer, CapabilityPhysicalStorageBufferAddresses],
    ),
  ),
  OpArrayLength => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Structure'", nothing),
      OperandInfo(LiteralInteger, "'Array member'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpGenericPtrMemSemantics => InstructionInfo(
    "Memory",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Pointer'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpInBoundsPtrAccessChain => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Element'", nothing),
      OperandInfo(IdRef, "'Indexes'", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAddresses]),
  ),
  OpDecorate => InstructionInfo(
    "Annotation",
    [OperandInfo(IdRef, "'Target'", nothing), OperandInfo(Decoration, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpMemberDecorate => InstructionInfo(
    "Annotation",
    [OperandInfo(IdRef, "'Structure Type'", nothing), OperandInfo(LiteralInteger, "'Member'", nothing), OperandInfo(Decoration, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpDecorationGroup =>
    InstructionInfo("Annotation", [OperandInfo(IdResult, nothing, nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGroupDecorate => InstructionInfo(
    "Annotation",
    [OperandInfo(IdRef, "'Decoration Group'", nothing), OperandInfo(IdRef, "'Targets'", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGroupMemberDecorate => InstructionInfo(
    "Annotation",
    [OperandInfo(IdRef, "'Decoration Group'", nothing), OperandInfo(PairIdRefLiteralInteger, "'Targets'", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpVectorExtractDynamic => InstructionInfo(
    "Composite",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector'", nothing),
      OperandInfo(IdRef, "'Index'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpVectorInsertDynamic => InstructionInfo(
    "Composite",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector'", nothing),
      OperandInfo(IdRef, "'Component'", nothing),
      OperandInfo(IdRef, "'Index'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpVectorShuffle => InstructionInfo(
    "Composite",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(LiteralInteger, "'Components'", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpCompositeConstruct => InstructionInfo(
    "Composite",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Constituents'", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpCompositeExtract => InstructionInfo(
    "Composite",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Composite'", nothing),
      OperandInfo(LiteralInteger, "'Indexes'", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpCompositeInsert => InstructionInfo(
    "Composite",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Object'", nothing),
      OperandInfo(IdRef, "'Composite'", nothing),
      OperandInfo(LiteralInteger, "'Indexes'", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpCopyObject => InstructionInfo(
    "Composite",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpTranspose => InstructionInfo(
    "Composite",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Matrix'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMatrix]),
  ),
  OpSampledImage => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Sampler'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpImageSampleImplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpImageSampleExplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(ImageOperands, nothing, nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpImageSampleDrefImplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'D~ref~'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpImageSampleDrefExplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'D~ref~'", nothing),
      OperandInfo(ImageOperands, nothing, nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpImageSampleProjImplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpImageSampleProjExplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(ImageOperands, nothing, nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpImageSampleProjDrefImplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'D~ref~'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpImageSampleProjDrefExplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'D~ref~'", nothing),
      OperandInfo(ImageOperands, nothing, nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpImageFetch => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpImageGather => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'Component'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpImageDrefGather => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'D~ref~'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpImageRead => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpImageWrite => InstructionInfo(
    "Image",
    [
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'Texel'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpImage => InstructionInfo(
    "Image",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Sampled Image'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpImageQueryFormat => InstructionInfo(
    "Image",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Image'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpImageQueryOrder => InstructionInfo(
    "Image",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Image'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpImageQuerySizeLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Level of Detail'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel, CapabilityImageQuery]),
  ),
  OpImageQuerySize => InstructionInfo(
    "Image",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Image'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel, CapabilityImageQuery]),
  ),
  OpImageQueryLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityImageQuery]),
  ),
  OpImageQueryLevels => InstructionInfo(
    "Image",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Image'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel, CapabilityImageQuery]),
  ),
  OpImageQuerySamples => InstructionInfo(
    "Image",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Image'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel, CapabilityImageQuery]),
  ),
  OpConvertFToU => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Float Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpConvertFToS => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Float Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpConvertSToF => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Signed Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpConvertUToF => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Unsigned Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpUConvert => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Unsigned Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSConvert => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Signed Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFConvert => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Float Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpQuantizeToF16 => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpConvertPtrToU => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Pointer'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAddresses, CapabilityPhysicalStorageBufferAddresses]),
  ),
  OpSatConvertSToU => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Signed Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpSatConvertUToS => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Unsigned Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpConvertUToPtr => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Integer Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAddresses, CapabilityPhysicalStorageBufferAddresses]),
  ),
  OpPtrCastToGeneric => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Pointer'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpGenericCastToPtr => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Pointer'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpGenericCastToPtrExplicit => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(StorageClass, "'Storage'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpBitcast => InstructionInfo(
    "Conversion",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSNegate => InstructionInfo(
    "Arithmetic",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFNegate => InstructionInfo(
    "Arithmetic",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpIAdd => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFAdd => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpISub => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFSub => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpIMul => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFMul => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpUDiv => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSDiv => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFDiv => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpUMod => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSRem => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSMod => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFRem => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFMod => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpVectorTimesScalar => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector'", nothing),
      OperandInfo(IdRef, "'Scalar'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpMatrixTimesScalar => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Matrix'", nothing),
      OperandInfo(IdRef, "'Scalar'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMatrix]),
  ),
  OpVectorTimesMatrix => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector'", nothing),
      OperandInfo(IdRef, "'Matrix'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMatrix]),
  ),
  OpMatrixTimesVector => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Matrix'", nothing),
      OperandInfo(IdRef, "'Vector'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMatrix]),
  ),
  OpMatrixTimesMatrix => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'LeftMatrix'", nothing),
      OperandInfo(IdRef, "'RightMatrix'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMatrix]),
  ),
  OpOuterProduct => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMatrix]),
  ),
  OpDot => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpIAddCarry => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpISubBorrow => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpUMulExtended => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSMulExtended => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAny => InstructionInfo(
    "Relational_and_Logical",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Vector'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAll => InstructionInfo(
    "Relational_and_Logical",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Vector'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpIsNan => InstructionInfo(
    "Relational_and_Logical",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'x'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpIsInf => InstructionInfo(
    "Relational_and_Logical",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'x'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpIsFinite => InstructionInfo(
    "Relational_and_Logical",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'x'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpIsNormal => InstructionInfo(
    "Relational_and_Logical",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'x'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpSignBitSet => InstructionInfo(
    "Relational_and_Logical",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'x'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpLessOrGreater => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'x'", nothing),
      OperandInfo(IdRef, "'y'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpOrdered => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'x'", nothing),
      OperandInfo(IdRef, "'y'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpUnordered => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'x'", nothing),
      OperandInfo(IdRef, "'y'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpLogicalEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpLogicalNotEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpLogicalOr => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpLogicalAnd => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpLogicalNot => InstructionInfo(
    "Relational_and_Logical",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSelect => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Condition'", nothing),
      OperandInfo(IdRef, "'Object 1'", nothing),
      OperandInfo(IdRef, "'Object 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpIEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpINotEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpUGreaterThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSGreaterThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpUGreaterThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSGreaterThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpULessThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSLessThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpULessThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSLessThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFOrdEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFUnordEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFOrdNotEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFUnordNotEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFOrdLessThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFUnordLessThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFOrdGreaterThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFUnordGreaterThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFOrdLessThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFUnordLessThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFOrdGreaterThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpFUnordGreaterThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpShiftRightLogical => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Shift'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpShiftRightArithmetic => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Shift'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpShiftLeftLogical => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Shift'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpBitwiseOr => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpBitwiseXor => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpBitwiseAnd => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpNot => InstructionInfo(
    "Bit",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpBitFieldInsert => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Insert'", nothing),
      OperandInfo(IdRef, "'Offset'", nothing),
      OperandInfo(IdRef, "'Count'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader, CapabilityBitInstructions]),
  ),
  OpBitFieldSExtract => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Offset'", nothing),
      OperandInfo(IdRef, "'Count'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader, CapabilityBitInstructions]),
  ),
  OpBitFieldUExtract => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Offset'", nothing),
      OperandInfo(IdRef, "'Count'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader, CapabilityBitInstructions]),
  ),
  OpBitReverse => InstructionInfo(
    "Bit",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Base'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader, CapabilityBitInstructions]),
  ),
  OpBitCount => InstructionInfo(
    "Bit",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Base'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpDPdx => InstructionInfo(
    "Derivative",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'P'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpDPdy => InstructionInfo(
    "Derivative",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'P'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpFwidth => InstructionInfo(
    "Derivative",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'P'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader]),
  ),
  OpDPdxFine => InstructionInfo(
    "Derivative",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'P'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDerivativeControl]),
  ),
  OpDPdyFine => InstructionInfo(
    "Derivative",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'P'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDerivativeControl]),
  ),
  OpFwidthFine => InstructionInfo(
    "Derivative",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'P'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDerivativeControl]),
  ),
  OpDPdxCoarse => InstructionInfo(
    "Derivative",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'P'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDerivativeControl]),
  ),
  OpDPdyCoarse => InstructionInfo(
    "Derivative",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'P'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDerivativeControl]),
  ),
  OpFwidthCoarse => InstructionInfo(
    "Derivative",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'P'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDerivativeControl]),
  ),
  OpEmitVertex => InstructionInfo("Primitive", [], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry])),
  OpEndPrimitive => InstructionInfo("Primitive", [], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometry])),
  OpEmitStreamVertex => InstructionInfo(
    "Primitive",
    [OperandInfo(IdRef, "'Stream'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometryStreams]),
  ),
  OpEndStreamPrimitive => InstructionInfo(
    "Primitive",
    [OperandInfo(IdRef, "'Stream'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGeometryStreams]),
  ),
  OpControlBarrier => InstructionInfo(
    "Barrier",
    [OperandInfo(IdScope, "'Execution'", nothing), OperandInfo(IdScope, "'Memory'", nothing), OperandInfo(IdMemorySemantics, "'Semantics'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpMemoryBarrier => InstructionInfo(
    "Barrier",
    [OperandInfo(IdScope, "'Memory'", nothing), OperandInfo(IdMemorySemantics, "'Semantics'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicLoad => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicStore => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicExchange => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicCompareExchange => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Equal'", nothing),
      OperandInfo(IdMemorySemantics, "'Unequal'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Comparator'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicCompareExchangeWeak => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Equal'", nothing),
      OperandInfo(IdMemorySemantics, "'Unequal'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Comparator'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpAtomicIIncrement => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicIDecrement => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicIAdd => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicISub => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicSMin => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicUMin => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicSMax => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicUMax => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicAnd => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicOr => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpAtomicXor => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpPhi => InstructionInfo(
    "Control-Flow",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(PairIdRefIdRef, "'Variable, Parent, ...'", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpLoopMerge => InstructionInfo(
    "Control-Flow",
    [OperandInfo(IdRef, "'Merge Block'", nothing), OperandInfo(IdRef, "'Continue Target'", nothing), OperandInfo(LoopControl, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSelectionMerge => InstructionInfo(
    "Control-Flow",
    [OperandInfo(IdRef, "'Merge Block'", nothing), OperandInfo(SelectionControl, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpLabel =>
    InstructionInfo("Control-Flow", [OperandInfo(IdResult, nothing, nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpBranch => InstructionInfo(
    "Control-Flow",
    [OperandInfo(IdRef, "'Target Label'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpBranchConditional => InstructionInfo(
    "Control-Flow",
    [
      OperandInfo(IdRef, "'Condition'", nothing),
      OperandInfo(IdRef, "'True Label'", nothing),
      OperandInfo(IdRef, "'False Label'", nothing),
      OperandInfo(LiteralInteger, "'Branch weights'", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpSwitch => InstructionInfo(
    "Control-Flow",
    [OperandInfo(IdRef, "'Selector'", nothing), OperandInfo(IdRef, "'Default'", nothing), OperandInfo(PairLiteralIntegerIdRef, "'Target'", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpKill => InstructionInfo("Control-Flow", [], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShader])),
  OpReturn => InstructionInfo("Control-Flow", [], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpReturnValue =>
    InstructionInfo("Control-Flow", [OperandInfo(IdRef, "'Value'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpUnreachable => InstructionInfo("Control-Flow", [], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpLifetimeStart => InstructionInfo(
    "Control-Flow",
    [OperandInfo(IdRef, "'Pointer'", nothing), OperandInfo(LiteralInteger, "'Size'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpLifetimeStop => InstructionInfo(
    "Control-Flow",
    [OperandInfo(IdRef, "'Pointer'", nothing), OperandInfo(LiteralInteger, "'Size'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpGroupAsyncCopy => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Destination'", nothing),
      OperandInfo(IdRef, "'Source'", nothing),
      OperandInfo(IdRef, "'Num Elements'", nothing),
      OperandInfo(IdRef, "'Stride'", nothing),
      OperandInfo(IdRef, "'Event'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpGroupWaitEvents => InstructionInfo(
    "Group",
    [OperandInfo(IdScope, "'Execution'", nothing), OperandInfo(IdRef, "'Num Events'", nothing), OperandInfo(IdRef, "'Events List'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpGroupAll => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroups]),
  ),
  OpGroupAny => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroups]),
  ),
  OpGroupBroadcast => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'LocalId'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroups]),
  ),
  OpGroupIAdd => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroups]),
  ),
  OpGroupFAdd => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroups]),
  ),
  OpGroupFMin => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroups]),
  ),
  OpGroupUMin => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroups]),
  ),
  OpGroupSMin => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroups]),
  ),
  OpGroupFMax => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroups]),
  ),
  OpGroupUMax => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroups]),
  ),
  OpGroupSMax => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroups]),
  ),
  OpReadPipe => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpWritePipe => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpReservedReadPipe => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Reserve Id'", nothing),
      OperandInfo(IdRef, "'Index'", nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpReservedWritePipe => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Reserve Id'", nothing),
      OperandInfo(IdRef, "'Index'", nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpReserveReadPipePackets => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Num Packets'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpReserveWritePipePackets => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Num Packets'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpCommitReadPipe => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Reserve Id'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpCommitWritePipe => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Reserve Id'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpIsValidReserveId => InstructionInfo(
    "Pipe",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Reserve Id'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpGetNumPipePackets => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpGetMaxPipePackets => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpGroupReserveReadPipePackets => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Num Packets'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpGroupReserveWritePipePackets => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Num Packets'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpGroupCommitReadPipe => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Reserve Id'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpGroupCommitWritePipe => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Reserve Id'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityPipes]),
  ),
  OpEnqueueMarker => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Queue'", nothing),
      OperandInfo(IdRef, "'Num Events'", nothing),
      OperandInfo(IdRef, "'Wait Events'", nothing),
      OperandInfo(IdRef, "'Ret Event'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpEnqueueKernel => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Queue'", nothing),
      OperandInfo(IdRef, "'Flags'", nothing),
      OperandInfo(IdRef, "'ND Range'", nothing),
      OperandInfo(IdRef, "'Num Events'", nothing),
      OperandInfo(IdRef, "'Wait Events'", nothing),
      OperandInfo(IdRef, "'Ret Event'", nothing),
      OperandInfo(IdRef, "'Invoke'", nothing),
      OperandInfo(IdRef, "'Param'", nothing),
      OperandInfo(IdRef, "'Param Size'", nothing),
      OperandInfo(IdRef, "'Param Align'", nothing),
      OperandInfo(IdRef, "'Local Size'", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpGetKernelNDrangeSubGroupCount => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'ND Range'", nothing),
      OperandInfo(IdRef, "'Invoke'", nothing),
      OperandInfo(IdRef, "'Param'", nothing),
      OperandInfo(IdRef, "'Param Size'", nothing),
      OperandInfo(IdRef, "'Param Align'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpGetKernelNDrangeMaxSubGroupSize => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'ND Range'", nothing),
      OperandInfo(IdRef, "'Invoke'", nothing),
      OperandInfo(IdRef, "'Param'", nothing),
      OperandInfo(IdRef, "'Param Size'", nothing),
      OperandInfo(IdRef, "'Param Align'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpGetKernelWorkGroupSize => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Invoke'", nothing),
      OperandInfo(IdRef, "'Param'", nothing),
      OperandInfo(IdRef, "'Param Size'", nothing),
      OperandInfo(IdRef, "'Param Align'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpGetKernelPreferredWorkGroupSizeMultiple => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Invoke'", nothing),
      OperandInfo(IdRef, "'Param'", nothing),
      OperandInfo(IdRef, "'Param Size'", nothing),
      OperandInfo(IdRef, "'Param Align'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpRetainEvent => InstructionInfo(
    "Device-Side_Enqueue",
    [OperandInfo(IdRef, "'Event'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpReleaseEvent => InstructionInfo(
    "Device-Side_Enqueue",
    [OperandInfo(IdRef, "'Event'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpCreateUserEvent => InstructionInfo(
    "Device-Side_Enqueue",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpIsValidEvent => InstructionInfo(
    "Device-Side_Enqueue",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Event'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpSetUserEventStatus => InstructionInfo(
    "Device-Side_Enqueue",
    [OperandInfo(IdRef, "'Event'", nothing), OperandInfo(IdRef, "'Status'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpCaptureEventProfilingInfo => InstructionInfo(
    "Device-Side_Enqueue",
    [OperandInfo(IdRef, "'Event'", nothing), OperandInfo(IdRef, "'Profiling Info'", nothing), OperandInfo(IdRef, "'Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpGetDefaultQueue => InstructionInfo(
    "Device-Side_Enqueue",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpBuildNDRange => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'GlobalWorkSize'", nothing),
      OperandInfo(IdRef, "'LocalWorkSize'", nothing),
      OperandInfo(IdRef, "'GlobalWorkOffset'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityDeviceEnqueue]),
  ),
  OpImageSparseSampleImplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpImageSparseSampleExplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(ImageOperands, nothing, nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpImageSparseSampleDrefImplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'D~ref~'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpImageSparseSampleDrefExplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'D~ref~'", nothing),
      OperandInfo(ImageOperands, nothing, nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpImageSparseSampleProjImplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpImageSparseSampleProjExplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(ImageOperands, nothing, nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpImageSparseSampleProjDrefImplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'D~ref~'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpImageSparseSampleProjDrefExplicitLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'D~ref~'", nothing),
      OperandInfo(ImageOperands, nothing, nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpImageSparseFetch => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpImageSparseGather => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'Component'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpImageSparseDrefGather => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'D~ref~'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpImageSparseTexelsResident => InstructionInfo(
    "Image",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Resident Code'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpNoLine => InstructionInfo("Debug", [], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpAtomicFlagTestAndSet => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpAtomicFlagClear => InstructionInfo(
    "Atomic",
    [OperandInfo(IdRef, "'Pointer'", nothing), OperandInfo(IdScope, "'Memory'", nothing), OperandInfo(IdMemorySemantics, "'Semantics'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityKernel]),
  ),
  OpImageSparseRead => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySparseResidency]),
  ),
  OpSizeOf => InstructionInfo(
    "Miscellaneous",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Pointer'", nothing)],
    RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityAddresses]),
  ),
  OpTypePipeStorage => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityPipeStorage]),
  ),
  OpConstantPipeStorage => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(LiteralInteger, "'Packet Size'", nothing),
      OperandInfo(LiteralInteger, "'Packet Alignment'", nothing),
      OperandInfo(LiteralInteger, "'Capacity'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityPipeStorage]),
  ),
  OpCreatePipeFromPipeStorage => InstructionInfo(
    "Pipe",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Pipe Storage'", nothing)],
    RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityPipeStorage]),
  ),
  OpGetKernelLocalSizeForSubgroupCount => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Subgroup Count'", nothing),
      OperandInfo(IdRef, "'Invoke'", nothing),
      OperandInfo(IdRef, "'Param'", nothing),
      OperandInfo(IdRef, "'Param Size'", nothing),
      OperandInfo(IdRef, "'Param Align'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilitySubgroupDispatch]),
  ),
  OpGetKernelMaxNumSubgroups => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Invoke'", nothing),
      OperandInfo(IdRef, "'Param'", nothing),
      OperandInfo(IdRef, "'Param Size'", nothing),
      OperandInfo(IdRef, "'Param Align'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilitySubgroupDispatch]),
  ),
  OpTypeNamedBarrier => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityNamedBarrier]),
  ),
  OpNamedBarrierInitialize => InstructionInfo(
    "Barrier",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Subgroup Count'", nothing)],
    RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityNamedBarrier]),
  ),
  OpMemoryNamedBarrier => InstructionInfo(
    "Barrier",
    [
      OperandInfo(IdRef, "'Named Barrier'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, [CapabilityNamedBarrier]),
  ),
  OpModuleProcessed =>
    InstructionInfo("Debug", [OperandInfo(LiteralString, "'Process'", nothing)], RequiredSupport(VersionRange(v"1.1.0", v"∞"), nothing, nothing)),
  OpExecutionModeId => InstructionInfo(
    "Mode-Setting",
    [OperandInfo(IdRef, "'Entry Point'", nothing), OperandInfo(ExecutionMode, "'Mode'", nothing)],
    RequiredSupport(VersionRange(v"1.2.0", v"∞"), nothing, nothing),
  ),
  OpDecorateId => InstructionInfo(
    "Annotation",
    [OperandInfo(IdRef, "'Target'", nothing), OperandInfo(Decoration, nothing, nothing)],
    RequiredSupport(VersionRange(v"1.2.0", v"∞"), ["SPV_GOOGLE_hlsl_functionality1"], nothing),
  ),
  OpGroupNonUniformElect => InstructionInfo(
    "Non-Uniform",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdScope, "'Execution'", nothing)],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniform]),
  ),
  OpGroupNonUniformAll => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformVote]),
  ),
  OpGroupNonUniformAny => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformVote]),
  ),
  OpGroupNonUniformAllEqual => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformVote]),
  ),
  OpGroupNonUniformBroadcast => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Id'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformBallot]),
  ),
  OpGroupNonUniformBroadcastFirst => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformBallot]),
  ),
  OpGroupNonUniformBallot => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformBallot]),
  ),
  OpGroupNonUniformInverseBallot => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformBallot]),
  ),
  OpGroupNonUniformBallotBitExtract => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Index'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformBallot]),
  ),
  OpGroupNonUniformBallotBitCount => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformBallot]),
  ),
  OpGroupNonUniformBallotFindLSB => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformBallot]),
  ),
  OpGroupNonUniformBallotFindMSB => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformBallot]),
  ),
  OpGroupNonUniformShuffle => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Id'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformShuffle]),
  ),
  OpGroupNonUniformShuffleXor => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Mask'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformShuffle]),
  ),
  OpGroupNonUniformShuffleUp => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Delta'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformShuffleRelative]),
  ),
  OpGroupNonUniformShuffleDown => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Delta'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformShuffleRelative]),
  ),
  OpGroupNonUniformIAdd => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformFAdd => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformIMul => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformFMul => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformSMin => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformUMin => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformFMin => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformSMax => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformUMax => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformFMax => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformBitwiseAnd => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformBitwiseOr => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformBitwiseXor => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformLogicalAnd => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformLogicalOr => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformLogicalXor => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(
      VersionRange(v"1.3.0", v"∞"),
      nothing,
      [CapabilityGroupNonUniformArithmetic, CapabilityGroupNonUniformClustered, CapabilityGroupNonUniformPartitionedNV],
    ),
  ),
  OpGroupNonUniformQuadBroadcast => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Index'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformQuad]),
  ),
  OpGroupNonUniformQuadSwap => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.3.0", v"∞"), nothing, [CapabilityGroupNonUniformQuad]),
  ),
  OpCopyLogical => InstructionInfo(
    "Composite",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, nothing),
  ),
  OpPtrEqual => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, nothing),
  ),
  OpPtrNotEqual => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"1.4.0", v"∞"), nothing, nothing),
  ),
  OpPtrDiff => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(
      VersionRange(v"1.4.0", v"∞"),
      nothing,
      [CapabilityAddresses, CapabilityVariablePointers, CapabilityVariablePointersStorageBuffer],
    ),
  ),
  OpTerminateInvocation =>
    InstructionInfo("Control-Flow", [], RequiredSupport(VersionRange(v"1.6.0", v"∞"), ["SPV_KHR_terminate_invocation"], [CapabilityShader])),
  OpSubgroupBallotKHR => InstructionInfo(
    "Group",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Predicate'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_shader_ballot"], [CapabilitySubgroupBallotKHR]),
  ),
  OpSubgroupFirstInvocationKHR => InstructionInfo(
    "Group",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_shader_ballot"], [CapabilitySubgroupBallotKHR]),
  ),
  OpSubgroupAllKHR => InstructionInfo(
    "Group",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Predicate'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_subgroup_vote"], [CapabilitySubgroupVoteKHR]),
  ),
  OpSubgroupAnyKHR => InstructionInfo(
    "Group",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Predicate'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_subgroup_vote"], [CapabilitySubgroupVoteKHR]),
  ),
  OpSubgroupAllEqualKHR => InstructionInfo(
    "Group",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Predicate'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_subgroup_vote"], [CapabilitySubgroupVoteKHR]),
  ),
  OpGroupNonUniformRotateKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Delta'", nothing),
      OperandInfo(IdRef, "'ClusterSize'", "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroupNonUniformRotateKHR]),
  ),
  OpSubgroupReadInvocationKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Index'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_shader_ballot"], [CapabilitySubgroupBallotKHR]),
  ),
  OpTraceRayKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Accel'", nothing),
      OperandInfo(IdRef, "'Ray Flags'", nothing),
      OperandInfo(IdRef, "'Cull Mask'", nothing),
      OperandInfo(IdRef, "'SBT Offset'", nothing),
      OperandInfo(IdRef, "'SBT Stride'", nothing),
      OperandInfo(IdRef, "'Miss Index'", nothing),
      OperandInfo(IdRef, "'Ray Origin'", nothing),
      OperandInfo(IdRef, "'Ray Tmin'", nothing),
      OperandInfo(IdRef, "'Ray Direction'", nothing),
      OperandInfo(IdRef, "'Ray Tmax'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_tracing"], [CapabilityRayTracingKHR]),
  ),
  OpExecuteCallableKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'SBT Index'", nothing), OperandInfo(IdRef, "'Callable Data'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_tracing"], [CapabilityRayTracingKHR]),
  ),
  OpConvertUToAccelerationStructureKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Accel'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_tracing", "SPV_KHR_ray_query"], [CapabilityRayTracingKHR, CapabilityRayQueryKHR]),
  ),
  OpIgnoreIntersectionKHR =>
    InstructionInfo("Reserved", [], RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_tracing"], [CapabilityRayTracingKHR])),
  OpTerminateRayKHR =>
    InstructionInfo("Reserved", [], RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_tracing"], [CapabilityRayTracingKHR])),
  OpSDot => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(PackedVectorFormat, "'Packed Vector Format'", "?"),
    ],
    RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, [CapabilityDotProduct]),
  ),
  OpSDotKHR => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(PackedVectorFormat, "'Packed Vector Format'", "?"),
    ],
    RequiredSupport(VersionRange(v"1.6.0", v"∞"), ["SPV_KHR_integer_dot_product"], [CapabilityDotProductKHR]),
  ),
  OpUDot => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(PackedVectorFormat, "'Packed Vector Format'", "?"),
    ],
    RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, [CapabilityDotProduct]),
  ),
  OpUDotKHR => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(PackedVectorFormat, "'Packed Vector Format'", "?"),
    ],
    RequiredSupport(VersionRange(v"1.6.0", v"∞"), ["SPV_KHR_integer_dot_product"], [CapabilityDotProductKHR]),
  ),
  OpSUDot => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(PackedVectorFormat, "'Packed Vector Format'", "?"),
    ],
    RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, [CapabilityDotProduct]),
  ),
  OpSUDotKHR => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(PackedVectorFormat, "'Packed Vector Format'", "?"),
    ],
    RequiredSupport(VersionRange(v"1.6.0", v"∞"), ["SPV_KHR_integer_dot_product"], [CapabilityDotProductKHR]),
  ),
  OpSDotAccSat => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(IdRef, "'Accumulator'", nothing),
      OperandInfo(PackedVectorFormat, "'Packed Vector Format'", "?"),
    ],
    RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, [CapabilityDotProduct]),
  ),
  OpSDotAccSatKHR => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(IdRef, "'Accumulator'", nothing),
      OperandInfo(PackedVectorFormat, "'Packed Vector Format'", "?"),
    ],
    RequiredSupport(VersionRange(v"1.6.0", v"∞"), ["SPV_KHR_integer_dot_product"], [CapabilityDotProductKHR]),
  ),
  OpUDotAccSat => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(IdRef, "'Accumulator'", nothing),
      OperandInfo(PackedVectorFormat, "'Packed Vector Format'", "?"),
    ],
    RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, [CapabilityDotProduct]),
  ),
  OpUDotAccSatKHR => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(IdRef, "'Accumulator'", nothing),
      OperandInfo(PackedVectorFormat, "'Packed Vector Format'", "?"),
    ],
    RequiredSupport(VersionRange(v"1.6.0", v"∞"), ["SPV_KHR_integer_dot_product"], [CapabilityDotProductKHR]),
  ),
  OpSUDotAccSat => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(IdRef, "'Accumulator'", nothing),
      OperandInfo(PackedVectorFormat, "'Packed Vector Format'", "?"),
    ],
    RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, [CapabilityDotProduct]),
  ),
  OpSUDotAccSatKHR => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
      OperandInfo(IdRef, "'Accumulator'", nothing),
      OperandInfo(PackedVectorFormat, "'Packed Vector Format'", "?"),
    ],
    RequiredSupport(VersionRange(v"1.6.0", v"∞"), ["SPV_KHR_integer_dot_product"], [CapabilityDotProductKHR]),
  ),
  OpTypeRayQueryKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryInitializeKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Accel'", nothing),
      OperandInfo(IdRef, "'RayFlags'", nothing),
      OperandInfo(IdRef, "'CullMask'", nothing),
      OperandInfo(IdRef, "'RayOrigin'", nothing),
      OperandInfo(IdRef, "'RayTMin'", nothing),
      OperandInfo(IdRef, "'RayDirection'", nothing),
      OperandInfo(IdRef, "'RayTMax'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryTerminateKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'RayQuery'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGenerateIntersectionKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'RayQuery'", nothing), OperandInfo(IdRef, "'HitT'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryConfirmIntersectionKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'RayQuery'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryProceedKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'RayQuery'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionTypeKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpGroupIAddNonUniformAMD => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_ballot"], [CapabilityGroups]),
  ),
  OpGroupFAddNonUniformAMD => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_ballot"], [CapabilityGroups]),
  ),
  OpGroupFMinNonUniformAMD => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_ballot"], [CapabilityGroups]),
  ),
  OpGroupUMinNonUniformAMD => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_ballot"], [CapabilityGroups]),
  ),
  OpGroupSMinNonUniformAMD => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_ballot"], [CapabilityGroups]),
  ),
  OpGroupFMaxNonUniformAMD => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_ballot"], [CapabilityGroups]),
  ),
  OpGroupUMaxNonUniformAMD => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_ballot"], [CapabilityGroups]),
  ),
  OpGroupSMaxNonUniformAMD => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_ballot"], [CapabilityGroups]),
  ),
  OpFragmentMaskFetchAMD => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_fragment_mask"], [CapabilityFragmentMaskAMD]),
  ),
  OpFragmentFetchAMD => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'Fragment Index'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_AMD_shader_fragment_mask"], [CapabilityFragmentMaskAMD]),
  ),
  OpReadClockKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdScope, "'Scope'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderClockKHR]),
  ),
  OpHitObjectRecordHitMotionNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Hit Object'", nothing),
      OperandInfo(IdRef, "'Acceleration Structure'", nothing),
      OperandInfo(IdRef, "'InstanceId'", nothing),
      OperandInfo(IdRef, "'PrimitiveId'", nothing),
      OperandInfo(IdRef, "'GeometryIndex'", nothing),
      OperandInfo(IdRef, "'Hit Kind'", nothing),
      OperandInfo(IdRef, "'SBT Record Offset'", nothing),
      OperandInfo(IdRef, "'SBT Record Stride'", nothing),
      OperandInfo(IdRef, "'Origin'", nothing),
      OperandInfo(IdRef, "'TMin'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
      OperandInfo(IdRef, "'TMax'", nothing),
      OperandInfo(IdRef, "'Current Time'", nothing),
      OperandInfo(IdRef, "'HitObject Attributes'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV, CapabilityRayTracingMotionBlurNV]),
  ),
  OpHitObjectRecordHitWithIndexMotionNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Hit Object'", nothing),
      OperandInfo(IdRef, "'Acceleration Structure'", nothing),
      OperandInfo(IdRef, "'InstanceId'", nothing),
      OperandInfo(IdRef, "'PrimitiveId'", nothing),
      OperandInfo(IdRef, "'GeometryIndex'", nothing),
      OperandInfo(IdRef, "'Hit Kind'", nothing),
      OperandInfo(IdRef, "'SBT Record Index'", nothing),
      OperandInfo(IdRef, "'Origin'", nothing),
      OperandInfo(IdRef, "'TMin'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
      OperandInfo(IdRef, "'TMax'", nothing),
      OperandInfo(IdRef, "'Current Time'", nothing),
      OperandInfo(IdRef, "'HitObject Attributes'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV, CapabilityRayTracingMotionBlurNV]),
  ),
  OpHitObjectRecordMissMotionNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Hit Object'", nothing),
      OperandInfo(IdRef, "'SBT Index'", nothing),
      OperandInfo(IdRef, "'Origin'", nothing),
      OperandInfo(IdRef, "'TMin'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
      OperandInfo(IdRef, "'TMax'", nothing),
      OperandInfo(IdRef, "'Current Time'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV, CapabilityRayTracingMotionBlurNV]),
  ),
  OpHitObjectGetWorldToObjectNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetObjectToWorldNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetObjectRayDirectionNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetObjectRayOriginNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectTraceRayMotionNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Hit Object'", nothing),
      OperandInfo(IdRef, "'Acceleration Structure'", nothing),
      OperandInfo(IdRef, "'RayFlags'", nothing),
      OperandInfo(IdRef, "'Cullmask'", nothing),
      OperandInfo(IdRef, "'SBT Record Offset'", nothing),
      OperandInfo(IdRef, "'SBT Record Stride'", nothing),
      OperandInfo(IdRef, "'Miss Index'", nothing),
      OperandInfo(IdRef, "'Origin'", nothing),
      OperandInfo(IdRef, "'TMin'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
      OperandInfo(IdRef, "'TMax'", nothing),
      OperandInfo(IdRef, "'Time'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV, CapabilityRayTracingMotionBlurNV]),
  ),
  OpHitObjectGetShaderRecordBufferHandleNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetShaderBindingTableRecordIndexNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectRecordEmptyNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectTraceRayNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Hit Object'", nothing),
      OperandInfo(IdRef, "'Acceleration Structure'", nothing),
      OperandInfo(IdRef, "'RayFlags'", nothing),
      OperandInfo(IdRef, "'Cullmask'", nothing),
      OperandInfo(IdRef, "'SBT Record Offset'", nothing),
      OperandInfo(IdRef, "'SBT Record Stride'", nothing),
      OperandInfo(IdRef, "'Miss Index'", nothing),
      OperandInfo(IdRef, "'Origin'", nothing),
      OperandInfo(IdRef, "'TMin'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
      OperandInfo(IdRef, "'TMax'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectRecordHitNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Hit Object'", nothing),
      OperandInfo(IdRef, "'Acceleration Structure'", nothing),
      OperandInfo(IdRef, "'InstanceId'", nothing),
      OperandInfo(IdRef, "'PrimitiveId'", nothing),
      OperandInfo(IdRef, "'GeometryIndex'", nothing),
      OperandInfo(IdRef, "'Hit Kind'", nothing),
      OperandInfo(IdRef, "'SBT Record Offset'", nothing),
      OperandInfo(IdRef, "'SBT Record Stride'", nothing),
      OperandInfo(IdRef, "'Origin'", nothing),
      OperandInfo(IdRef, "'TMin'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
      OperandInfo(IdRef, "'TMax'", nothing),
      OperandInfo(IdRef, "'HitObject Attributes'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectRecordHitWithIndexNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Hit Object'", nothing),
      OperandInfo(IdRef, "'Acceleration Structure'", nothing),
      OperandInfo(IdRef, "'InstanceId'", nothing),
      OperandInfo(IdRef, "'PrimitiveId'", nothing),
      OperandInfo(IdRef, "'GeometryIndex'", nothing),
      OperandInfo(IdRef, "'Hit Kind'", nothing),
      OperandInfo(IdRef, "'SBT Record Index'", nothing),
      OperandInfo(IdRef, "'Origin'", nothing),
      OperandInfo(IdRef, "'TMin'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
      OperandInfo(IdRef, "'TMax'", nothing),
      OperandInfo(IdRef, "'HitObject Attributes'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectRecordMissNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Hit Object'", nothing),
      OperandInfo(IdRef, "'SBT Index'", nothing),
      OperandInfo(IdRef, "'Origin'", nothing),
      OperandInfo(IdRef, "'TMin'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
      OperandInfo(IdRef, "'TMax'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectExecuteShaderNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'Hit Object'", nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetCurrentTimeNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetAttributesNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'Hit Object'", nothing), OperandInfo(IdRef, "'Hit Object Attribute'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetHitKindNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetPrimitiveIndexNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetGeometryIndexNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetInstanceIdNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetInstanceCustomIndexNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetWorldRayDirectionNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetWorldRayOriginNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetRayTMaxNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectGetRayTMinNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectIsEmptyNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectIsHitNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpHitObjectIsMissNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Hit Object'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpReorderThreadWithHitObjectNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'Hit Object'", nothing), OperandInfo(IdRef, "'Hint'", "?"), OperandInfo(IdRef, "'Bits'", "?")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpReorderThreadWithHintNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'Hint'", nothing), OperandInfo(IdRef, "'Bits'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpTypeHitObjectNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityShaderInvocationReorderNV]),
  ),
  OpImageSampleFootprintNV => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'Granularity'", nothing),
      OperandInfo(IdRef, "'Coarse'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_image_footprint"], [CapabilityImageFootprintNV]),
  ),
  OpEmitMeshTasksEXT => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Group Count X'", nothing),
      OperandInfo(IdRef, "'Group Count Y'", nothing),
      OperandInfo(IdRef, "'Group Count Z'", nothing),
      OperandInfo(IdRef, "'Payload'", "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMeshShadingEXT]),
  ),
  OpSetMeshOutputsEXT => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'Vertex Count'", nothing), OperandInfo(IdRef, "'Primitive Count'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityMeshShadingEXT]),
  ),
  OpGroupNonUniformPartitionNV => InstructionInfo(
    "Non-Uniform",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Value'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_shader_subgroup_partitioned"], [CapabilityGroupNonUniformPartitionedNV]),
  ),
  OpWritePackedPrimitiveIndices4x8NV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'Index Offset'", nothing), OperandInfo(IdRef, "'Packed Indices'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_mesh_shader"], [CapabilityMeshShadingNV]),
  ),
  OpReportIntersectionNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Hit'", nothing),
      OperandInfo(IdRef, "'HitKind'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"], [CapabilityRayTracingNV, CapabilityRayTracingKHR]),
  ),
  OpReportIntersectionKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Hit'", nothing),
      OperandInfo(IdRef, "'HitKind'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"], [CapabilityRayTracingNV, CapabilityRayTracingKHR]),
  ),
  OpIgnoreIntersectionNV =>
    InstructionInfo("Reserved", [], RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_ray_tracing"], [CapabilityRayTracingNV])),
  OpTerminateRayNV =>
    InstructionInfo("Reserved", [], RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_ray_tracing"], [CapabilityRayTracingNV])),
  OpTraceNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Accel'", nothing),
      OperandInfo(IdRef, "'Ray Flags'", nothing),
      OperandInfo(IdRef, "'Cull Mask'", nothing),
      OperandInfo(IdRef, "'SBT Offset'", nothing),
      OperandInfo(IdRef, "'SBT Stride'", nothing),
      OperandInfo(IdRef, "'Miss Index'", nothing),
      OperandInfo(IdRef, "'Ray Origin'", nothing),
      OperandInfo(IdRef, "'Ray Tmin'", nothing),
      OperandInfo(IdRef, "'Ray Direction'", nothing),
      OperandInfo(IdRef, "'Ray Tmax'", nothing),
      OperandInfo(IdRef, "'PayloadId'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_ray_tracing"], [CapabilityRayTracingNV]),
  ),
  OpTraceMotionNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Accel'", nothing),
      OperandInfo(IdRef, "'Ray Flags'", nothing),
      OperandInfo(IdRef, "'Cull Mask'", nothing),
      OperandInfo(IdRef, "'SBT Offset'", nothing),
      OperandInfo(IdRef, "'SBT Stride'", nothing),
      OperandInfo(IdRef, "'Miss Index'", nothing),
      OperandInfo(IdRef, "'Ray Origin'", nothing),
      OperandInfo(IdRef, "'Ray Tmin'", nothing),
      OperandInfo(IdRef, "'Ray Direction'", nothing),
      OperandInfo(IdRef, "'Ray Tmax'", nothing),
      OperandInfo(IdRef, "'Time'", nothing),
      OperandInfo(IdRef, "'PayloadId'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_ray_tracing_motion_blur"], [CapabilityRayTracingMotionBlurNV]),
  ),
  OpTraceRayMotionNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Accel'", nothing),
      OperandInfo(IdRef, "'Ray Flags'", nothing),
      OperandInfo(IdRef, "'Cull Mask'", nothing),
      OperandInfo(IdRef, "'SBT Offset'", nothing),
      OperandInfo(IdRef, "'SBT Stride'", nothing),
      OperandInfo(IdRef, "'Miss Index'", nothing),
      OperandInfo(IdRef, "'Ray Origin'", nothing),
      OperandInfo(IdRef, "'Ray Tmin'", nothing),
      OperandInfo(IdRef, "'Ray Direction'", nothing),
      OperandInfo(IdRef, "'Ray Tmax'", nothing),
      OperandInfo(IdRef, "'Time'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_ray_tracing_motion_blur"], [CapabilityRayTracingMotionBlurNV]),
  ),
  OpTypeAccelerationStructureNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing", "SPV_KHR_ray_query"],
      [CapabilityRayTracingNV, CapabilityRayTracingKHR, CapabilityRayQueryKHR],
    ),
  ),
  OpTypeAccelerationStructureKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing", "SPV_KHR_ray_query"],
      [CapabilityRayTracingNV, CapabilityRayTracingKHR, CapabilityRayQueryKHR],
    ),
  ),
  OpExecuteCallableNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'SBT Index'", nothing), OperandInfo(IdRef, "'Callable DataId'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_ray_tracing"], [CapabilityRayTracingNV]),
  ),
  OpTypeCooperativeMatrixNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Component Type'", nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Rows'", nothing),
      OperandInfo(IdRef, "'Columns'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_cooperative_matrix"], [CapabilityCooperativeMatrixNV]),
  ),
  OpCooperativeMatrixLoadNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdRef, "'Stride'", nothing),
      OperandInfo(IdRef, "'Column Major'", nothing),
      OperandInfo(MemoryAccess, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_cooperative_matrix"], [CapabilityCooperativeMatrixNV]),
  ),
  OpCooperativeMatrixStoreNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdRef, "'Object'", nothing),
      OperandInfo(IdRef, "'Stride'", nothing),
      OperandInfo(IdRef, "'Column Major'", nothing),
      OperandInfo(MemoryAccess, nothing, "?"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_cooperative_matrix"], [CapabilityCooperativeMatrixNV]),
  ),
  OpCooperativeMatrixMulAddNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(IdRef, "'C'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_cooperative_matrix"], [CapabilityCooperativeMatrixNV]),
  ),
  OpCooperativeMatrixLengthNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Type'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_NV_cooperative_matrix"], [CapabilityCooperativeMatrixNV]),
  ),
  OpBeginInvocationInterlockEXT => InstructionInfo(
    "Reserved",
    [],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      ["SPV_EXT_fragment_shader_interlock"],
      [CapabilityFragmentShaderSampleInterlockEXT, CapabilityFragmentShaderPixelInterlockEXT, CapabilityFragmentShaderShadingRateInterlockEXT],
    ),
  ),
  OpEndInvocationInterlockEXT => InstructionInfo(
    "Reserved",
    [],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      ["SPV_EXT_fragment_shader_interlock"],
      [CapabilityFragmentShaderSampleInterlockEXT, CapabilityFragmentShaderPixelInterlockEXT, CapabilityFragmentShaderShadingRateInterlockEXT],
    ),
  ),
  OpDemoteToHelperInvocation =>
    InstructionInfo("Control-Flow", [], RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, [CapabilityDemoteToHelperInvocation])),
  OpDemoteToHelperInvocationEXT =>
    InstructionInfo("Control-Flow", [], RequiredSupport(VersionRange(v"1.6.0", v"∞"), nothing, [CapabilityDemoteToHelperInvocationEXT])),
  OpIsHelperInvocationEXT => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_EXT_demote_to_helper_invocation"], [CapabilityDemoteToHelperInvocationEXT]),
  ),
  OpConvertUToImageNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityBindlessTextureNV]),
  ),
  OpConvertUToSamplerNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityBindlessTextureNV]),
  ),
  OpConvertImageToUNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityBindlessTextureNV]),
  ),
  OpConvertSamplerToUNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityBindlessTextureNV]),
  ),
  OpConvertUToSampledImageNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityBindlessTextureNV]),
  ),
  OpConvertSampledImageToUNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityBindlessTextureNV]),
  ),
  OpSamplerImageAddressingModeNV => InstructionInfo(
    "Reserved",
    [OperandInfo(LiteralInteger, "'Bit Width'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityBindlessTextureNV]),
  ),
  OpSubgroupShuffleINTEL => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Data'", nothing),
      OperandInfo(IdRef, "'InvocationId'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupShuffleINTEL]),
  ),
  OpSubgroupShuffleDownINTEL => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Current'", nothing),
      OperandInfo(IdRef, "'Next'", nothing),
      OperandInfo(IdRef, "'Delta'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupShuffleINTEL]),
  ),
  OpSubgroupShuffleUpINTEL => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Previous'", nothing),
      OperandInfo(IdRef, "'Current'", nothing),
      OperandInfo(IdRef, "'Delta'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupShuffleINTEL]),
  ),
  OpSubgroupShuffleXorINTEL => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Data'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupShuffleINTEL]),
  ),
  OpSubgroupBlockReadINTEL => InstructionInfo(
    "Group",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Ptr'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupBufferBlockIOINTEL]),
  ),
  OpSubgroupBlockWriteINTEL => InstructionInfo(
    "Group",
    [OperandInfo(IdRef, "'Ptr'", nothing), OperandInfo(IdRef, "'Data'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupBufferBlockIOINTEL]),
  ),
  OpSubgroupImageBlockReadINTEL => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupImageBlockIOINTEL]),
  ),
  OpSubgroupImageBlockWriteINTEL => InstructionInfo(
    "Group",
    [OperandInfo(IdRef, "'Image'", nothing), OperandInfo(IdRef, "'Coordinate'", nothing), OperandInfo(IdRef, "'Data'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupImageBlockIOINTEL]),
  ),
  OpSubgroupImageMediaBlockReadINTEL => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'Width'", nothing),
      OperandInfo(IdRef, "'Height'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupImageMediaBlockIOINTEL]),
  ),
  OpSubgroupImageMediaBlockWriteINTEL => InstructionInfo(
    "Group",
    [
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'Width'", nothing),
      OperandInfo(IdRef, "'Height'", nothing),
      OperandInfo(IdRef, "'Data'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupImageMediaBlockIOINTEL]),
  ),
  OpUCountLeadingZerosINTEL => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpUCountTrailingZerosINTEL => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpAbsISubINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpAbsUSubINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpIAddSatINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpUAddSatINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpIAverageINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpUAverageINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpIAverageRoundedINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpUAverageRoundedINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpISubSatINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpUSubSatINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpIMul32x16INTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpUMul32x16INTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityIntegerFunctions2INTEL]),
  ),
  OpConstantFunctionPointerINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Function'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_function_pointers"], [CapabilityFunctionPointersINTEL]),
  ),
  OpFunctionPointerCallINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Operand 1'", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_function_pointers"], [CapabilityFunctionPointersINTEL]),
  ),
  OpAsmTargetINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(LiteralString, "'Asm target'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAsmINTEL]),
  ),
  OpAsmINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Asm type'", nothing),
      OperandInfo(IdRef, "'Target'", nothing),
      OperandInfo(LiteralString, "'Asm instructions'", nothing),
      OperandInfo(LiteralString, "'Constraints'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAsmINTEL]),
  ),
  OpAsmCallINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Asm'", nothing),
      OperandInfo(IdRef, "'Argument 0'", "*"),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityAsmINTEL]),
  ),
  OpAtomicFMinEXT => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilityAtomicFloat16MinMaxEXT, CapabilityAtomicFloat32MinMaxEXT, CapabilityAtomicFloat64MinMaxEXT],
    ),
  ),
  OpAtomicFMaxEXT => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilityAtomicFloat16MinMaxEXT, CapabilityAtomicFloat32MinMaxEXT, CapabilityAtomicFloat64MinMaxEXT],
    ),
  ),
  OpAssumeTrueKHR => InstructionInfo(
    "Miscellaneous",
    [OperandInfo(IdRef, "'Condition'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_expect_assume"], [CapabilityExpectAssumeKHR]),
  ),
  OpExpectKHR => InstructionInfo(
    "Miscellaneous",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'ExpectedValue'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_expect_assume"], [CapabilityExpectAssumeKHR]),
  ),
  OpDecorateString => InstructionInfo(
    "Annotation",
    [OperandInfo(IdRef, "'Target'", nothing), OperandInfo(Decoration, nothing, nothing)],
    RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_GOOGLE_decorate_string", "SPV_GOOGLE_hlsl_functionality1"], nothing),
  ),
  OpDecorateStringGOOGLE => InstructionInfo(
    "Annotation",
    [OperandInfo(IdRef, "'Target'", nothing), OperandInfo(Decoration, nothing, nothing)],
    RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_GOOGLE_decorate_string", "SPV_GOOGLE_hlsl_functionality1"], nothing),
  ),
  OpMemberDecorateString => InstructionInfo(
    "Annotation",
    [OperandInfo(IdRef, "'Struct Type'", nothing), OperandInfo(LiteralInteger, "'Member'", nothing), OperandInfo(Decoration, nothing, nothing)],
    RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_GOOGLE_decorate_string", "SPV_GOOGLE_hlsl_functionality1"], nothing),
  ),
  OpMemberDecorateStringGOOGLE => InstructionInfo(
    "Annotation",
    [OperandInfo(IdRef, "'Struct Type'", nothing), OperandInfo(LiteralInteger, "'Member'", nothing), OperandInfo(Decoration, nothing, nothing)],
    RequiredSupport(VersionRange(v"1.4.0", v"∞"), ["SPV_GOOGLE_decorate_string", "SPV_GOOGLE_hlsl_functionality1"], nothing),
  ),
  OpVmeImageINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image Type'", nothing),
      OperandInfo(IdRef, "'Sampler'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeVmeImageINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Image Type'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeAvcImePayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeAvcRefPayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeAvcSicPayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeAvcMcePayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeAvcMceResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeAvcImeResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeAvcImeResultSingleReferenceStreamoutINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeAvcImeResultDualReferenceStreamoutINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeAvcImeSingleReferenceStreaminINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeAvcImeDualReferenceStreaminINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeAvcRefResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpTypeAvcSicResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetDefaultInterBaseMultiReferencePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Slice Type'", nothing),
      OperandInfo(IdRef, "'Qp'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceSetInterBaseMultiReferencePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Reference Base Penalty'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetDefaultInterShapePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Slice Type'", nothing),
      OperandInfo(IdRef, "'Qp'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceSetInterShapePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packed Shape Penalty'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetDefaultInterDirectionPenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Slice Type'", nothing),
      OperandInfo(IdRef, "'Qp'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceSetInterDirectionPenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Direction Cost'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetDefaultIntraLumaShapePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Slice Type'", nothing),
      OperandInfo(IdRef, "'Qp'", nothing),
    ],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationIntraINTEL],
    ),
  ),
  OpSubgroupAvcMceGetDefaultInterMotionVectorCostTableINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Slice Type'", nothing),
      OperandInfo(IdRef, "'Qp'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetDefaultHighPenaltyCostTableINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetDefaultMediumPenaltyCostTableINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetDefaultLowPenaltyCostTableINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceSetMotionVectorCostFunctionINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packed Cost Center Delta'", nothing),
      OperandInfo(IdRef, "'Packed Cost Table'", nothing),
      OperandInfo(IdRef, "'Cost Precision'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetDefaultIntraLumaModePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Slice Type'", nothing),
      OperandInfo(IdRef, "'Qp'", nothing),
    ],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationIntraINTEL],
    ),
  ),
  OpSubgroupAvcMceGetDefaultNonDcLumaIntraPenaltyINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationIntraINTEL],
    ),
  ),
  OpSubgroupAvcMceGetDefaultIntraChromaModeBasePenaltyINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationChromaINTEL],
    ),
  ),
  OpSubgroupAvcMceSetAcOnlyHaarINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceSetSourceInterlacedFieldPolarityINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Source Field Polarity'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceSetSingleReferenceInterlacedFieldPolarityINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Reference Field Polarity'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceSetDualReferenceInterlacedFieldPolaritiesINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Forward Reference Field Polarity'", nothing),
      OperandInfo(IdRef, "'Backward Reference Field Polarity'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceConvertToImePayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceConvertToImeResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceConvertToRefPayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceConvertToRefResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceConvertToSicPayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceConvertToSicResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetMotionVectorsINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetInterDistortionsINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetBestInterDistortionsINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetInterMajorShapeINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetInterMinorShapeINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetInterDirectionsINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetInterMotionVectorCountINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetInterReferenceIdsINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcMceGetInterReferenceInterlacedFieldPolaritiesINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packed Reference Ids'", nothing),
      OperandInfo(IdRef, "'Packed Reference Parameter Field Polarities'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeInitializeINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Coord'", nothing),
      OperandInfo(IdRef, "'Partition Mask'", nothing),
      OperandInfo(IdRef, "'SAD Adjustment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeSetSingleReferenceINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Ref Offset'", nothing),
      OperandInfo(IdRef, "'Search Window Config'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeSetDualReferenceINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Fwd Ref Offset'", nothing),
      OperandInfo(IdRef, "'Bwd Ref Offset'", nothing),
      OperandInfo(IdRef, "'id> Search Window Config'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeRefWindowSizeINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Search Window Config'", nothing),
      OperandInfo(IdRef, "'Dual Ref'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeAdjustRefOffsetINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Ref Offset'", nothing),
      OperandInfo(IdRef, "'Src Coord'", nothing),
      OperandInfo(IdRef, "'Ref Window Size'", nothing),
      OperandInfo(IdRef, "'Image Size'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeConvertToMcePayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeSetMaxMotionVectorCountINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Max Motion Vector Count'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeSetUnidirectionalMixDisableINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeSetEarlySearchTerminationThresholdINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Threshold'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeSetWeightedSadINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packed Sad Weights'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeEvaluateWithSingleReferenceINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Ref Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeEvaluateWithDualReferenceINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Fwd Ref Image'", nothing),
      OperandInfo(IdRef, "'Bwd Ref Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeEvaluateWithSingleReferenceStreaminINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Ref Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
      OperandInfo(IdRef, "'Streamin Components'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeEvaluateWithDualReferenceStreaminINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Fwd Ref Image'", nothing),
      OperandInfo(IdRef, "'Bwd Ref Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
      OperandInfo(IdRef, "'Streamin Components'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeEvaluateWithSingleReferenceStreamoutINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Ref Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeEvaluateWithDualReferenceStreamoutINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Fwd Ref Image'", nothing),
      OperandInfo(IdRef, "'Bwd Ref Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeEvaluateWithSingleReferenceStreaminoutINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Ref Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
      OperandInfo(IdRef, "'Streamin Components'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeEvaluateWithDualReferenceStreaminoutINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Fwd Ref Image'", nothing),
      OperandInfo(IdRef, "'Bwd Ref Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
      OperandInfo(IdRef, "'Streamin Components'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeConvertToMceResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetSingleReferenceStreaminINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetDualReferenceStreaminINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeStripSingleReferenceStreamoutINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeStripDualReferenceStreamoutINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeMotionVectorsINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
      OperandInfo(IdRef, "'Major Shape'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeDistortionsINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
      OperandInfo(IdRef, "'Major Shape'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeReferenceIdsINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
      OperandInfo(IdRef, "'Major Shape'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeMotionVectorsINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
      OperandInfo(IdRef, "'Major Shape'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeDistortionsINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
      OperandInfo(IdRef, "'Major Shape'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeReferenceIdsINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
      OperandInfo(IdRef, "'Major Shape'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetBorderReachedINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image Select'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetTruncatedSearchIndicationINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetUnidirectionalEarlySearchTerminationINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetWeightingPatternMinimumMotionVectorINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcImeGetWeightingPatternMinimumDistortionINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcFmeInitializeINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Coord'", nothing),
      OperandInfo(IdRef, "'Motion Vectors'", nothing),
      OperandInfo(IdRef, "'Major Shapes'", nothing),
      OperandInfo(IdRef, "'Minor Shapes'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
      OperandInfo(IdRef, "'Pixel Resolution'", nothing),
      OperandInfo(IdRef, "'Sad Adjustment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcBmeInitializeINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Coord'", nothing),
      OperandInfo(IdRef, "'Motion Vectors'", nothing),
      OperandInfo(IdRef, "'Major Shapes'", nothing),
      OperandInfo(IdRef, "'Minor Shapes'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
      OperandInfo(IdRef, "'Pixel Resolution'", nothing),
      OperandInfo(IdRef, "'Bidirectional Weight'", nothing),
      OperandInfo(IdRef, "'Sad Adjustment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcRefConvertToMcePayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcRefSetBidirectionalMixDisableINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcRefSetBilinearFilterEnableINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcRefEvaluateWithSingleReferenceINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Ref Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcRefEvaluateWithDualReferenceINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Fwd Ref Image'", nothing),
      OperandInfo(IdRef, "'Bwd Ref Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcRefEvaluateWithMultiReferenceINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Packed Reference Ids'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcRefEvaluateWithMultiReferenceInterlacedINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Packed Reference Ids'", nothing),
      OperandInfo(IdRef, "'Packed Reference Field Polarities'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcRefConvertToMceResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicInitializeINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Src Coord'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicConfigureSkcINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Skip Block Partition Type'", nothing),
      OperandInfo(IdRef, "'Skip Motion Vector Mask'", nothing),
      OperandInfo(IdRef, "'Motion Vectors'", nothing),
      OperandInfo(IdRef, "'Bidirectional Weight'", nothing),
      OperandInfo(IdRef, "'Sad Adjustment'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicConfigureIpeLumaINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Luma Intra Partition Mask'", nothing),
      OperandInfo(IdRef, "'Intra Neighbour Availabilty'", nothing),
      OperandInfo(IdRef, "'Left Edge Luma Pixels'", nothing),
      OperandInfo(IdRef, "'Upper Left Corner Luma Pixel'", nothing),
      OperandInfo(IdRef, "'Upper Edge Luma Pixels'", nothing),
      OperandInfo(IdRef, "'Upper Right Edge Luma Pixels'", nothing),
      OperandInfo(IdRef, "'Sad Adjustment'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationIntraINTEL],
    ),
  ),
  OpSubgroupAvcSicConfigureIpeLumaChromaINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Luma Intra Partition Mask'", nothing),
      OperandInfo(IdRef, "'Intra Neighbour Availabilty'", nothing),
      OperandInfo(IdRef, "'Left Edge Luma Pixels'", nothing),
      OperandInfo(IdRef, "'Upper Left Corner Luma Pixel'", nothing),
      OperandInfo(IdRef, "'Upper Edge Luma Pixels'", nothing),
      OperandInfo(IdRef, "'Upper Right Edge Luma Pixels'", nothing),
      OperandInfo(IdRef, "'Left Edge Chroma Pixels'", nothing),
      OperandInfo(IdRef, "'Upper Left Corner Chroma Pixel'", nothing),
      OperandInfo(IdRef, "'Upper Edge Chroma Pixels'", nothing),
      OperandInfo(IdRef, "'Sad Adjustment'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationChromaINTEL],
    ),
  ),
  OpSubgroupAvcSicGetMotionVectorMaskINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Skip Block Partition Type'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicConvertToMcePayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicSetIntraLumaShapePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packed Shape Penalty'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicSetIntraLumaModeCostFunctionINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Luma Mode Penalty'", nothing),
      OperandInfo(IdRef, "'Luma Packed Neighbor Modes'", nothing),
      OperandInfo(IdRef, "'Luma Packed Non Dc Penalty'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationIntraINTEL],
    ),
  ),
  OpSubgroupAvcSicSetIntraChromaModeCostFunctionINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Chroma Mode Base Penalty'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationChromaINTEL],
    ),
  ),
  OpSubgroupAvcSicSetBilinearFilterEnableINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicSetSkcForwardTransformEnableINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packed Sad Coefficients'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicSetBlockBasedRawSkipSadINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Block Based Skip Type'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicEvaluateIpeINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationIntraINTEL],
    ),
  ),
  OpSubgroupAvcSicEvaluateWithSingleReferenceINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Ref Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicEvaluateWithDualReferenceINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Fwd Ref Image'", nothing),
      OperandInfo(IdRef, "'Bwd Ref Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicEvaluateWithMultiReferenceINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Packed Reference Ids'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicEvaluateWithMultiReferenceInterlacedINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Packed Reference Ids'", nothing),
      OperandInfo(IdRef, "'Packed Reference Field Polarities'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicConvertToMceResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicGetIpeLumaShapeINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationIntraINTEL],
    ),
  ),
  OpSubgroupAvcSicGetBestIpeLumaDistortionINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationIntraINTEL],
    ),
  ),
  OpSubgroupAvcSicGetBestIpeChromaDistortionINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpSubgroupAvcSicGetPackedIpeLumaModesINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationIntraINTEL],
    ),
  ),
  OpSubgroupAvcSicGetIpeChromaModeINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationChromaINTEL],
    ),
  ),
  OpSubgroupAvcSicGetPackedSkcLumaCountThresholdINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationIntraINTEL],
    ),
  ),
  OpSubgroupAvcSicGetPackedSkcLumaSumThresholdINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      nothing,
      [CapabilitySubgroupAvcMotionEstimationINTEL, CapabilitySubgroupAvcMotionEstimationIntraINTEL],
    ),
  ),
  OpSubgroupAvcSicGetInterRawSadsINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Payload'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySubgroupAvcMotionEstimationINTEL]),
  ),
  OpVariableLengthArrayINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Lenght'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVariableLengthArrayINTEL]),
  ),
  OpSaveMemoryINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVariableLengthArrayINTEL]),
  ),
  OpRestoreMemoryINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdRef, "'Ptr'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVariableLengthArrayINTEL]),
  ),
  OpArbitraryFloatSinCosPiINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'FromSign'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatCastINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatCastFromIntINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'FromSign'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatCastToIntINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatAddINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatSubINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatMulINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatDivINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatGTINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatGEINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatLTINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatLEINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatEQINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatRecipINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatRSqrtINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatCbrtINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatHypotINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatSqrtINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatLogINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatLog2INTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatLog10INTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatLog1pINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatExpINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatExp2INTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatExp10INTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatExpm1INTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatSinINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatCosINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatSinCosINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatSinPiINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatCosPiINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatASinINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatASinPiINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatACosINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatACosPiINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatATanINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatATanPiINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatATan2INTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatPowINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatPowRINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'M2'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpArbitraryFloatPowNINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'A'", nothing),
      OperandInfo(LiteralInteger, "'M1'", nothing),
      OperandInfo(IdRef, "'B'", nothing),
      OperandInfo(LiteralInteger, "'Mout'", nothing),
      OperandInfo(LiteralInteger, "'EnableSubnormals'", nothing),
      OperandInfo(LiteralInteger, "'RoundingMode'", nothing),
      OperandInfo(LiteralInteger, "'RoundingAccuracy'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFloatingPointINTEL]),
  ),
  OpLoopControlINTEL => InstructionInfo(
    "Reserved",
    [OperandInfo(LiteralInteger, "'Loop Control Parameters'", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_unstructured_loop_controls"], [CapabilityUnstructuredLoopControlsINTEL]),
  ),
  OpAliasDomainDeclINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Name'", "?")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_memory_access_aliasing"], [CapabilityMemoryAccessAliasingINTEL]),
  ),
  OpAliasScopeDeclINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Alias Domain'", nothing), OperandInfo(IdRef, "'Name'", "?")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_memory_access_aliasing"], [CapabilityMemoryAccessAliasingINTEL]),
  ),
  OpAliasScopeListDeclINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'AliasScope1, AliasScope2, ...'", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_memory_access_aliasing"], [CapabilityMemoryAccessAliasingINTEL]),
  ),
  OpFixedSqrtINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Input Type'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
      OperandInfo(LiteralInteger, "'S'", nothing),
      OperandInfo(LiteralInteger, "'I'", nothing),
      OperandInfo(LiteralInteger, "'rI'", nothing),
      OperandInfo(LiteralInteger, "'Q'", nothing),
      OperandInfo(LiteralInteger, "'O'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]),
  ),
  OpFixedRecipINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Input Type'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
      OperandInfo(LiteralInteger, "'S'", nothing),
      OperandInfo(LiteralInteger, "'I'", nothing),
      OperandInfo(LiteralInteger, "'rI'", nothing),
      OperandInfo(LiteralInteger, "'Q'", nothing),
      OperandInfo(LiteralInteger, "'O'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]),
  ),
  OpFixedRsqrtINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Input Type'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
      OperandInfo(LiteralInteger, "'S'", nothing),
      OperandInfo(LiteralInteger, "'I'", nothing),
      OperandInfo(LiteralInteger, "'rI'", nothing),
      OperandInfo(LiteralInteger, "'Q'", nothing),
      OperandInfo(LiteralInteger, "'O'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]),
  ),
  OpFixedSinINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Input Type'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
      OperandInfo(LiteralInteger, "'S'", nothing),
      OperandInfo(LiteralInteger, "'I'", nothing),
      OperandInfo(LiteralInteger, "'rI'", nothing),
      OperandInfo(LiteralInteger, "'Q'", nothing),
      OperandInfo(LiteralInteger, "'O'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]),
  ),
  OpFixedCosINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Input Type'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
      OperandInfo(LiteralInteger, "'S'", nothing),
      OperandInfo(LiteralInteger, "'I'", nothing),
      OperandInfo(LiteralInteger, "'rI'", nothing),
      OperandInfo(LiteralInteger, "'Q'", nothing),
      OperandInfo(LiteralInteger, "'O'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]),
  ),
  OpFixedSinCosINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Input Type'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
      OperandInfo(LiteralInteger, "'S'", nothing),
      OperandInfo(LiteralInteger, "'I'", nothing),
      OperandInfo(LiteralInteger, "'rI'", nothing),
      OperandInfo(LiteralInteger, "'Q'", nothing),
      OperandInfo(LiteralInteger, "'O'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]),
  ),
  OpFixedSinPiINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Input Type'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
      OperandInfo(LiteralInteger, "'S'", nothing),
      OperandInfo(LiteralInteger, "'I'", nothing),
      OperandInfo(LiteralInteger, "'rI'", nothing),
      OperandInfo(LiteralInteger, "'Q'", nothing),
      OperandInfo(LiteralInteger, "'O'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]),
  ),
  OpFixedCosPiINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Input Type'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
      OperandInfo(LiteralInteger, "'S'", nothing),
      OperandInfo(LiteralInteger, "'I'", nothing),
      OperandInfo(LiteralInteger, "'rI'", nothing),
      OperandInfo(LiteralInteger, "'Q'", nothing),
      OperandInfo(LiteralInteger, "'O'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]),
  ),
  OpFixedSinCosPiINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Input Type'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
      OperandInfo(LiteralInteger, "'S'", nothing),
      OperandInfo(LiteralInteger, "'I'", nothing),
      OperandInfo(LiteralInteger, "'rI'", nothing),
      OperandInfo(LiteralInteger, "'Q'", nothing),
      OperandInfo(LiteralInteger, "'O'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]),
  ),
  OpFixedLogINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Input Type'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
      OperandInfo(LiteralInteger, "'S'", nothing),
      OperandInfo(LiteralInteger, "'I'", nothing),
      OperandInfo(LiteralInteger, "'rI'", nothing),
      OperandInfo(LiteralInteger, "'Q'", nothing),
      OperandInfo(LiteralInteger, "'O'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]),
  ),
  OpFixedExpINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Input Type'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
      OperandInfo(LiteralInteger, "'S'", nothing),
      OperandInfo(LiteralInteger, "'I'", nothing),
      OperandInfo(LiteralInteger, "'rI'", nothing),
      OperandInfo(LiteralInteger, "'Q'", nothing),
      OperandInfo(LiteralInteger, "'O'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityArbitraryPrecisionFixedPointINTEL]),
  ),
  OpPtrCastToCrossWorkgroupINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Pointer'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityUSMStorageClassesINTEL]),
  ),
  OpCrossWorkgroupCastToPtrINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'Pointer'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityUSMStorageClassesINTEL]),
  ),
  OpReadPipeBlockingINTEL => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_blocking_pipes"], [CapabilityBlockingPipesINTEL]),
  ),
  OpWritePipeBlockingINTEL => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_blocking_pipes"], [CapabilityBlockingPipesINTEL]),
  ),
  OpFPGARegINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Result'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_INTEL_fpga_reg"], [CapabilityFPGARegINTEL]),
  ),
  OpRayQueryGetRayTMinKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'RayQuery'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetRayFlagsKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'RayQuery'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionTKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionInstanceCustomIndexKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionInstanceIdKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionGeometryIndexKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionPrimitiveIndexKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionBarycentricsKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionFrontFaceKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionCandidateAABBOpaqueKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'RayQuery'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionObjectRayDirectionKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionObjectRayOriginKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetWorldRayDirectionKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'RayQuery'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetWorldRayOriginKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResultType, nothing, nothing), OperandInfo(IdResult, nothing, nothing), OperandInfo(IdRef, "'RayQuery'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionObjectToWorldKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpRayQueryGetIntersectionWorldToObjectKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), ["SPV_KHR_ray_query"], [CapabilityRayQueryKHR]),
  ),
  OpAtomicFAddEXT => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    RequiredSupport(
      VersionRange(v"0.0.0", v"∞"),
      ["SPV_EXT_shader_atomic_float_add"],
      [CapabilityAtomicFloat16AddEXT, CapabilityAtomicFloat32AddEXT, CapabilityAtomicFloat64AddEXT],
    ),
  ),
  OpTypeBufferSurfaceINTEL => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing), OperandInfo(AccessQualifier, "'AccessQualifier'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityVectorComputeINTEL]),
  ),
  OpTypeStructContinuedINTEL => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdRef, "'Member 0 type', +\n'member 1 type', +\n...", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityLongConstantCompositeINTEL]),
  ),
  OpConstantCompositeContinuedINTEL => InstructionInfo(
    "Constant-Creation",
    [OperandInfo(IdRef, "'Constituents'", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityLongConstantCompositeINTEL]),
  ),
  OpSpecConstantCompositeContinuedINTEL => InstructionInfo(
    "Constant-Creation",
    [OperandInfo(IdRef, "'Constituents'", "*")],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityLongConstantCompositeINTEL]),
  ),
  OpControlBarrierArriveINTEL => InstructionInfo(
    "Barrier",
    [OperandInfo(IdScope, "'Execution'", nothing), OperandInfo(IdScope, "'Memory'", nothing), OperandInfo(IdMemorySemantics, "'Semantics'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySplitBarrierINTEL]),
  ),
  OpControlBarrierWaitINTEL => InstructionInfo(
    "Barrier",
    [OperandInfo(IdScope, "'Execution'", nothing), OperandInfo(IdScope, "'Memory'", nothing), OperandInfo(IdMemorySemantics, "'Semantics'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilitySplitBarrierINTEL]),
  ),
  OpGroupIMulKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroupUniformArithmeticKHR]),
  ),
  OpGroupFMulKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroupUniformArithmeticKHR]),
  ),
  OpGroupBitwiseAndKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroupUniformArithmeticKHR]),
  ),
  OpGroupBitwiseOrKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroupUniformArithmeticKHR]),
  ),
  OpGroupBitwiseXorKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroupUniformArithmeticKHR]),
  ),
  OpGroupLogicalAndKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroupUniformArithmeticKHR]),
  ),
  OpGroupLogicalOrKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroupUniformArithmeticKHR]),
  ),
  OpGroupLogicalXorKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(GroupOperation, "'Operation'", nothing),
      OperandInfo(IdRef, "'X'", nothing),
    ],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityGroupUniformArithmeticKHR]),
  ),
)

const class_printing = Dict{String,String}([
  "@exclude" => "",
  "Miscellaneous" => "Miscellaneous Instructions",
  "Debug" => "Debug Instructions",
  "Annotation" => "Annotation Instructions",
  "Extension" => "Extension Instructions",
  "Mode-Setting" => "Mode-Setting Instructions",
  "Type-Declaration" => "Type-Declaration Instructions",
  "Constant-Creation" => "Constant-Creation Instructions",
  "Memory" => "Memory Instructions",
  "Function" => "Function Instructions",
  "Image" => "Image Instructions",
  "Conversion" => "Conversion Instructions",
  "Composite" => "Composite Instructions",
  "Arithmetic" => "Arithmetic Instructions",
  "Bit" => "Bit Instructions",
  "Relational_and_Logical" => "Relational and Logical Instructions",
  "Derivative" => "Derivative Instructions",
  "Control-Flow" => "Control-Flow Instructions",
  "Atomic" => "Atomic Instructions",
  "Primitive" => "Primitive Instructions",
  "Barrier" => "Barrier Instructions",
  "Group" => "Group and Subgroup Instructions",
  "Device-Side_Enqueue" => "Device-Side Enqueue Instructions",
  "Pipe" => "Pipe Instructions",
  "Non-Uniform" => "Non-Uniform Instructions",
  "Reserved" => "Reserved Instructions",
])

const kind_to_category = Dict(
  ImageOperands                     => "BitEnum",
  FPFastMathMode                    => "BitEnum",
  SelectionControl                  => "BitEnum",
  LoopControl                       => "BitEnum",
  FunctionControl                   => "BitEnum",
  MemorySemantics                   => "BitEnum",
  MemoryAccess                      => "BitEnum",
  KernelProfilingInfo               => "BitEnum",
  RayFlags                          => "BitEnum",
  FragmentShadingRate               => "BitEnum",
  SourceLanguage                    => "ValueEnum",
  ExecutionModel                    => "ValueEnum",
  AddressingModel                   => "ValueEnum",
  MemoryModel                       => "ValueEnum",
  ExecutionMode                     => "ValueEnum",
  StorageClass                      => "ValueEnum",
  Dim                               => "ValueEnum",
  SamplerAddressingMode             => "ValueEnum",
  SamplerFilterMode                 => "ValueEnum",
  ImageFormat                       => "ValueEnum",
  ImageChannelOrder                 => "ValueEnum",
  ImageChannelDataType              => "ValueEnum",
  FPRoundingMode                    => "ValueEnum",
  FPDenormMode                      => "ValueEnum",
  QuantizationModes                 => "ValueEnum",
  FPOperationMode                   => "ValueEnum",
  OverflowModes                     => "ValueEnum",
  LinkageType                       => "ValueEnum",
  AccessQualifier                   => "ValueEnum",
  FunctionParameterAttribute        => "ValueEnum",
  Decoration                        => "ValueEnum",
  BuiltIn                           => "ValueEnum",
  Scope                             => "ValueEnum",
  GroupOperation                    => "ValueEnum",
  KernelEnqueueFlags                => "ValueEnum",
  Capability                        => "ValueEnum",
  RayQueryIntersection              => "ValueEnum",
  RayQueryCommittedIntersectionType => "ValueEnum",
  RayQueryCandidateIntersectionType => "ValueEnum",
  PackedVectorFormat                => "ValueEnum",
  IdResultType                      => "Id",
  IdResult                          => "Id",
  IdMemorySemantics                 => "Id",
  IdScope                           => "Id",
  IdRef                             => "Id",
  LiteralInteger                    => "Literal",
  LiteralString                     => "Literal",
  LiteralContextDependentNumber     => "Literal",
  LiteralExtInstInteger             => "Literal",
  LiteralSpecConstantOpInteger      => "Literal",
  PairLiteralIntegerIdRef           => "Composite",
  PairIdRefLiteralInteger           => "Composite",
  PairIdRefIdRef                    => "Composite",
)
