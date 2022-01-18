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
  OpSubgroupReadInvocationKHR                                             = 4432
  OpTraceRayKHR                                                           = 4445
  OpExecuteCallableKHR                                                    = 4446
  OpConvertUToAccelerationStructureKHR                                    = 4447
  OpIgnoreIntersectionKHR                                                 = 4448
  OpTerminateRayKHR                                                       = 4449
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
  OpImageSampleFootprintNV                                                = 5283
  OpGroupNonUniformPartitionNV                                            = 5296
  OpWritePackedPrimitiveIndices4x8NV                                      = 5299
  OpReportIntersectionNV                                                  = 5334
  OpReportIntersectionKHR                                                 = 5334
  OpIgnoreIntersectionNV                                                  = 5335
  OpTerminateRayNV                                                        = 5336
  OpTraceNV                                                               = 5337
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
  OpDemoteToHelperInvocationEXT                                           = 5380
  OpIsHelperInvocationEXT                                                 = 5381
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
  OpFunctionPointerINTEL                                                  = 5600
  OpFunctionPointerCallINTEL                                              = 5601
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
  OpLoopControlINTEL                                                      = 5887
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
end

const instruction_infos = Dict{OpCode,InstructionInfo}(
  OpNop => InstructionInfo("Miscellaneous", [], [], [], v"0.0.0"),
  OpUndef => InstructionInfo(
    "Miscellaneous",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSourceContinued => InstructionInfo(
    "Debug",
    [OperandInfo(LiteralString, "'Continued Source'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpSource => InstructionInfo(
    "Debug",
    [
      OperandInfo(SourceLanguage, nothing, nothing),
      OperandInfo(LiteralInteger, "'Version'", nothing),
      OperandInfo(IdRef, "'File'", "?"),
      OperandInfo(LiteralString, "'Source'", "?"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSourceExtension => InstructionInfo(
    "Debug",
    [OperandInfo(LiteralString, "'Extension'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpName => InstructionInfo(
    "Debug",
    [
      OperandInfo(IdRef, "'Target'", nothing),
      OperandInfo(LiteralString, "'Name'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpMemberName => InstructionInfo(
    "Debug",
    [
      OperandInfo(IdRef, "'Type'", nothing),
      OperandInfo(LiteralInteger, "'Member'", nothing),
      OperandInfo(LiteralString, "'Name'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpString => InstructionInfo(
    "Debug",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(LiteralString, "'String'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpLine => InstructionInfo(
    "Debug",
    [
      OperandInfo(IdRef, "'File'", nothing),
      OperandInfo(LiteralInteger, "'Line'", nothing),
      OperandInfo(LiteralInteger, "'Column'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpExtension => InstructionInfo(
    "Extension",
    [OperandInfo(LiteralString, "'Name'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpExtInstImport => InstructionInfo(
    "Extension",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(LiteralString, "'Name'", nothing),
    ],
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
  ),
  OpMemoryModel => InstructionInfo(
    "Mode-Setting",
    [
      OperandInfo(AddressingModel, nothing, nothing),
      OperandInfo(MemoryModel, nothing, nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpEntryPoint => InstructionInfo(
    "Mode-Setting",
    [
      OperandInfo(ExecutionModel, nothing, nothing),
      OperandInfo(IdRef, "'Entry Point'", nothing),
      OperandInfo(LiteralString, "'Name'", nothing),
      OperandInfo(IdRef, "'Interface'", "*"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpExecutionMode => InstructionInfo(
    "Mode-Setting",
    [
      OperandInfo(IdRef, "'Entry Point'", nothing),
      OperandInfo(ExecutionMode, "'Mode'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpCapability => InstructionInfo(
    "Mode-Setting",
    [OperandInfo(Capability, "'Capability'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpTypeVoid => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpTypeBool => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpTypeInt => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(LiteralInteger, "'Width'", nothing),
      OperandInfo(LiteralInteger, "'Signedness'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpTypeFloat => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(LiteralInteger, "'Width'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpTypeVector => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Component Type'", nothing),
      OperandInfo(LiteralInteger, "'Component Count'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpTypeMatrix => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Column Type'", nothing),
      OperandInfo(LiteralInteger, "'Column Count'", nothing),
    ],
    [CapabilityMatrix],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
  ),
  OpTypeSampler => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpTypeSampledImage => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image Type'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpTypeArray => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Element Type'", nothing),
      OperandInfo(IdRef, "'Length'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpTypeRuntimeArray => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Element Type'", nothing),
    ],
    [CapabilityShader],
    [],
    v"0.0.0",
  ),
  OpTypeStruct => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Member 0 type', +\n'member 1 type', +\n...", "*"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpTypeOpaque => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(LiteralString, "The name of the opaque type.", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpTypePointer => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(StorageClass, nothing, nothing),
      OperandInfo(IdRef, "'Type'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpTypeFunction => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Return Type'", nothing),
      OperandInfo(IdRef, "'Parameter 0 Type', +\n'Parameter 1 Type', +\n...", "*"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpTypeEvent => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpTypeDeviceEvent => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
  ),
  OpTypeReserveId => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilityPipes],
    [],
    v"0.0.0",
  ),
  OpTypeQueue => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
  ),
  OpTypePipe => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(AccessQualifier, "'Qualifier'", nothing),
    ],
    [CapabilityPipes],
    [],
    v"0.0.0",
  ),
  OpTypeForwardPointer => InstructionInfo(
    "Type-Declaration",
    [
      OperandInfo(IdRef, "'Pointer Type'", nothing),
      OperandInfo(StorageClass, nothing, nothing),
    ],
    [CapabilityAddresses, CapabilityPhysicalStorageBufferAddresses],
    [],
    v"0.0.0",
  ),
  OpConstantTrue => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpConstantFalse => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpConstant => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(LiteralContextDependentNumber, "'Value'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpConstantComposite => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Constituents'", "*"),
    ],
    [],
    [],
    v"0.0.0",
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
    [CapabilityLiteralSampler],
    [],
    v"0.0.0",
  ),
  OpConstantNull => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSpecConstantTrue => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSpecConstantFalse => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSpecConstant => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(LiteralContextDependentNumber, "'Value'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSpecConstantComposite => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Constituents'", "*"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSpecConstantOp => InstructionInfo(
    "Constant-Creation",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(LiteralSpecConstantOpInteger, "'Opcode'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFunction => InstructionInfo(
    "Function",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(FunctionControl, nothing, nothing),
      OperandInfo(IdRef, "'Function Type'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFunctionParameter => InstructionInfo(
    "Function",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFunctionEnd => InstructionInfo("Function", [], [], [], v"0.0.0"),
  OpFunctionCall => InstructionInfo(
    "Function",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Function'", nothing),
      OperandInfo(IdRef, "'Argument 0', +\n'Argument 1', +\n...", "*"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpVariable => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(StorageClass, nothing, nothing),
      OperandInfo(IdRef, "'Initializer'", "?"),
    ],
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
  ),
  OpLoad => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(MemoryAccess, nothing, "?"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpStore => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdRef, "'Object'", nothing),
      OperandInfo(MemoryAccess, nothing, "?"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpCopyMemory => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdRef, "'Target'", nothing),
      OperandInfo(IdRef, "'Source'", nothing),
      OperandInfo(MemoryAccess, nothing, "?"),
      OperandInfo(MemoryAccess, nothing, "?"),
    ],
    [],
    [],
    v"0.0.0",
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
    [CapabilityAddresses],
    [],
    v"0.0.0",
  ),
  OpAccessChain => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Indexes'", "*"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpInBoundsAccessChain => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Indexes'", "*"),
    ],
    [],
    [],
    v"0.0.0",
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
    [
      CapabilityAddresses,
      CapabilityVariablePointers,
      CapabilityVariablePointersStorageBuffer,
      CapabilityPhysicalStorageBufferAddresses,
    ],
    [],
    v"0.0.0",
  ),
  OpArrayLength => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Structure'", nothing),
      OperandInfo(LiteralInteger, "'Array member'", nothing),
    ],
    [CapabilityShader],
    [],
    v"0.0.0",
  ),
  OpGenericPtrMemSemantics => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
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
    [CapabilityAddresses],
    [],
    v"0.0.0",
  ),
  OpDecorate => InstructionInfo(
    "Annotation",
    [
      OperandInfo(IdRef, "'Target'", nothing),
      OperandInfo(Decoration, nothing, nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpMemberDecorate => InstructionInfo(
    "Annotation",
    [
      OperandInfo(IdRef, "'Structure Type'", nothing),
      OperandInfo(LiteralInteger, "'Member'", nothing),
      OperandInfo(Decoration, nothing, nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpDecorationGroup => InstructionInfo(
    "Annotation",
    [OperandInfo(IdResult, nothing, nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGroupDecorate => InstructionInfo(
    "Annotation",
    [
      OperandInfo(IdRef, "'Decoration Group'", nothing),
      OperandInfo(IdRef, "'Targets'", "*"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpGroupMemberDecorate => InstructionInfo(
    "Annotation",
    [
      OperandInfo(IdRef, "'Decoration Group'", nothing),
      OperandInfo(PairIdRefLiteralInteger, "'Targets'", "*"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpVectorExtractDynamic => InstructionInfo(
    "Composite",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector'", nothing),
      OperandInfo(IdRef, "'Index'", nothing),
    ],
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
  ),
  OpCompositeConstruct => InstructionInfo(
    "Composite",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Constituents'", "*"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpCompositeExtract => InstructionInfo(
    "Composite",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Composite'", nothing),
      OperandInfo(LiteralInteger, "'Indexes'", "*"),
    ],
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
  ),
  OpCopyObject => InstructionInfo(
    "Composite",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpTranspose => InstructionInfo(
    "Composite",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Matrix'", nothing),
    ],
    [CapabilityMatrix],
    [],
    v"0.0.0",
  ),
  OpSampledImage => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Sampler'", nothing),
    ],
    [],
    [],
    v"0.0.0",
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
    [CapabilityShader],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [CapabilityShader],
    [],
    v"0.0.0",
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
    [CapabilityShader],
    [],
    v"0.0.0",
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
    [CapabilityShader],
    [],
    v"0.0.0",
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
    [CapabilityShader],
    [],
    v"0.0.0",
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
    [CapabilityShader],
    [],
    v"0.0.0",
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
    [CapabilityShader],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [CapabilityShader],
    [],
    v"0.0.0",
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
    [CapabilityShader],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
  ),
  OpImageWrite => InstructionInfo(
    "Image",
    [
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'Texel'", nothing),
      OperandInfo(ImageOperands, nothing, "?"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpImage => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpImageQueryFormat => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpImageQueryOrder => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpImageQuerySizeLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Level of Detail'", nothing),
    ],
    [CapabilityKernel, CapabilityImageQuery],
    [],
    v"0.0.0",
  ),
  OpImageQuerySize => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
    ],
    [CapabilityKernel, CapabilityImageQuery],
    [],
    v"0.0.0",
  ),
  OpImageQueryLod => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Sampled Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
    ],
    [CapabilityImageQuery],
    [],
    v"0.0.0",
  ),
  OpImageQueryLevels => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
    ],
    [CapabilityKernel, CapabilityImageQuery],
    [],
    v"0.0.0",
  ),
  OpImageQuerySamples => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
    ],
    [CapabilityKernel, CapabilityImageQuery],
    [],
    v"0.0.0",
  ),
  OpConvertFToU => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Float Value'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpConvertFToS => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Float Value'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpConvertSToF => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Signed Value'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpConvertUToF => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Unsigned Value'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpUConvert => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Unsigned Value'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSConvert => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Signed Value'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFConvert => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Float Value'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpQuantizeToF16 => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpConvertPtrToU => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
    ],
    [CapabilityAddresses, CapabilityPhysicalStorageBufferAddresses],
    [],
    v"0.0.0",
  ),
  OpSatConvertSToU => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Signed Value'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpSatConvertUToS => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Unsigned Value'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpConvertUToPtr => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Integer Value'", nothing),
    ],
    [CapabilityAddresses, CapabilityPhysicalStorageBufferAddresses],
    [],
    v"0.0.0",
  ),
  OpPtrCastToGeneric => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpGenericCastToPtr => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpGenericCastToPtrExplicit => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(StorageClass, "'Storage'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpBitcast => InstructionInfo(
    "Conversion",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSNegate => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFNegate => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpIAdd => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFAdd => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpISub => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFSub => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpIMul => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFMul => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpUDiv => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSDiv => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFDiv => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpUMod => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSRem => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSMod => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFRem => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFMod => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpVectorTimesScalar => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector'", nothing),
      OperandInfo(IdRef, "'Scalar'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpMatrixTimesScalar => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Matrix'", nothing),
      OperandInfo(IdRef, "'Scalar'", nothing),
    ],
    [CapabilityMatrix],
    [],
    v"0.0.0",
  ),
  OpVectorTimesMatrix => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector'", nothing),
      OperandInfo(IdRef, "'Matrix'", nothing),
    ],
    [CapabilityMatrix],
    [],
    v"0.0.0",
  ),
  OpMatrixTimesVector => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Matrix'", nothing),
      OperandInfo(IdRef, "'Vector'", nothing),
    ],
    [CapabilityMatrix],
    [],
    v"0.0.0",
  ),
  OpMatrixTimesMatrix => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'LeftMatrix'", nothing),
      OperandInfo(IdRef, "'RightMatrix'", nothing),
    ],
    [CapabilityMatrix],
    [],
    v"0.0.0",
  ),
  OpOuterProduct => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
    ],
    [CapabilityMatrix],
    [],
    v"0.0.0",
  ),
  OpDot => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector 1'", nothing),
      OperandInfo(IdRef, "'Vector 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpIAddCarry => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpISubBorrow => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpUMulExtended => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSMulExtended => InstructionInfo(
    "Arithmetic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpAny => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpAll => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Vector'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpIsNan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'x'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpIsInf => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'x'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpIsFinite => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'x'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpIsNormal => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'x'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpSignBitSet => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'x'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpLessOrGreater => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'x'", nothing),
      OperandInfo(IdRef, "'y'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpOrdered => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'x'", nothing),
      OperandInfo(IdRef, "'y'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpUnordered => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'x'", nothing),
      OperandInfo(IdRef, "'y'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpLogicalEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpLogicalNotEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpLogicalOr => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpLogicalAnd => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpLogicalNot => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand'", nothing),
    ],
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
  ),
  OpIEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpINotEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpUGreaterThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSGreaterThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpUGreaterThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSGreaterThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpULessThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSLessThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpULessThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSLessThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFOrdEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFUnordEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFOrdNotEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFUnordNotEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFOrdLessThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFUnordLessThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFOrdGreaterThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFUnordGreaterThan => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFOrdLessThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFUnordLessThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFOrdGreaterThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpFUnordGreaterThanEqual => InstructionInfo(
    "Relational_and_Logical",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpShiftRightLogical => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Shift'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpShiftRightArithmetic => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Shift'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpShiftLeftLogical => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
      OperandInfo(IdRef, "'Shift'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpBitwiseOr => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpBitwiseXor => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpBitwiseAnd => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpNot => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand'", nothing),
    ],
    [],
    [],
    v"0.0.0",
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
    [CapabilityShader],
    [],
    v"0.0.0",
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
    [CapabilityShader],
    [],
    v"0.0.0",
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
    [CapabilityShader],
    [],
    v"0.0.0",
  ),
  OpBitReverse => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
    ],
    [CapabilityShader],
    [],
    v"0.0.0",
  ),
  OpBitCount => InstructionInfo(
    "Bit",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Base'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpDPdx => InstructionInfo(
    "Derivative",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'P'", nothing),
    ],
    [CapabilityShader],
    [],
    v"0.0.0",
  ),
  OpDPdy => InstructionInfo(
    "Derivative",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'P'", nothing),
    ],
    [CapabilityShader],
    [],
    v"0.0.0",
  ),
  OpFwidth => InstructionInfo(
    "Derivative",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'P'", nothing),
    ],
    [CapabilityShader],
    [],
    v"0.0.0",
  ),
  OpDPdxFine => InstructionInfo(
    "Derivative",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'P'", nothing),
    ],
    [CapabilityDerivativeControl],
    [],
    v"0.0.0",
  ),
  OpDPdyFine => InstructionInfo(
    "Derivative",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'P'", nothing),
    ],
    [CapabilityDerivativeControl],
    [],
    v"0.0.0",
  ),
  OpFwidthFine => InstructionInfo(
    "Derivative",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'P'", nothing),
    ],
    [CapabilityDerivativeControl],
    [],
    v"0.0.0",
  ),
  OpDPdxCoarse => InstructionInfo(
    "Derivative",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'P'", nothing),
    ],
    [CapabilityDerivativeControl],
    [],
    v"0.0.0",
  ),
  OpDPdyCoarse => InstructionInfo(
    "Derivative",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'P'", nothing),
    ],
    [CapabilityDerivativeControl],
    [],
    v"0.0.0",
  ),
  OpFwidthCoarse => InstructionInfo(
    "Derivative",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'P'", nothing),
    ],
    [CapabilityDerivativeControl],
    [],
    v"0.0.0",
  ),
  OpEmitVertex =>
    InstructionInfo("Primitive", [], [CapabilityGeometry], [], v"0.0.0"),
  OpEndPrimitive =>
    InstructionInfo("Primitive", [], [CapabilityGeometry], [], v"0.0.0"),
  OpEmitStreamVertex => InstructionInfo(
    "Primitive",
    [OperandInfo(IdRef, "'Stream'", nothing)],
    [CapabilityGeometryStreams],
    [],
    v"0.0.0",
  ),
  OpEndStreamPrimitive => InstructionInfo(
    "Primitive",
    [OperandInfo(IdRef, "'Stream'", nothing)],
    [CapabilityGeometryStreams],
    [],
    v"0.0.0",
  ),
  OpControlBarrier => InstructionInfo(
    "Barrier",
    [
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpMemoryBarrier => InstructionInfo(
    "Barrier",
    [
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
    ],
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
  ),
  OpAtomicStore => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [CapabilityKernel],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
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
    [],
    [],
    v"0.0.0",
  ),
  OpPhi => InstructionInfo(
    "Control-Flow",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(PairIdRefIdRef, "'Variable, Parent, ...'", "*"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpLoopMerge => InstructionInfo(
    "Control-Flow",
    [
      OperandInfo(IdRef, "'Merge Block'", nothing),
      OperandInfo(IdRef, "'Continue Target'", nothing),
      OperandInfo(LoopControl, nothing, nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSelectionMerge => InstructionInfo(
    "Control-Flow",
    [
      OperandInfo(IdRef, "'Merge Block'", nothing),
      OperandInfo(SelectionControl, nothing, nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpLabel => InstructionInfo(
    "Control-Flow",
    [OperandInfo(IdResult, nothing, nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpBranch => InstructionInfo(
    "Control-Flow",
    [OperandInfo(IdRef, "'Target Label'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpBranchConditional => InstructionInfo(
    "Control-Flow",
    [
      OperandInfo(IdRef, "'Condition'", nothing),
      OperandInfo(IdRef, "'True Label'", nothing),
      OperandInfo(IdRef, "'False Label'", nothing),
      OperandInfo(LiteralInteger, "'Branch weights'", "*"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpSwitch => InstructionInfo(
    "Control-Flow",
    [
      OperandInfo(IdRef, "'Selector'", nothing),
      OperandInfo(IdRef, "'Default'", nothing),
      OperandInfo(PairLiteralIntegerIdRef, "'Target'", "*"),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpKill => InstructionInfo("Control-Flow", [], [CapabilityShader], [], v"0.0.0"),
  OpReturn => InstructionInfo("Control-Flow", [], [], [], v"0.0.0"),
  OpReturnValue => InstructionInfo(
    "Control-Flow",
    [OperandInfo(IdRef, "'Value'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpUnreachable => InstructionInfo("Control-Flow", [], [], [], v"0.0.0"),
  OpLifetimeStart => InstructionInfo(
    "Control-Flow",
    [
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(LiteralInteger, "'Size'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpLifetimeStop => InstructionInfo(
    "Control-Flow",
    [
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(LiteralInteger, "'Size'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
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
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpGroupWaitEvents => InstructionInfo(
    "Group",
    [
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Num Events'", nothing),
      OperandInfo(IdRef, "'Events List'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpGroupAll => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    [CapabilityGroups],
    [],
    v"0.0.0",
  ),
  OpGroupAny => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    [CapabilityGroups],
    [],
    v"0.0.0",
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
    [CapabilityGroups],
    [],
    v"0.0.0",
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
    [CapabilityGroups],
    [],
    v"0.0.0",
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
    [CapabilityGroups],
    [],
    v"0.0.0",
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
    [CapabilityGroups],
    [],
    v"0.0.0",
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
    [CapabilityGroups],
    [],
    v"0.0.0",
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
    [CapabilityGroups],
    [],
    v"0.0.0",
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
    [CapabilityGroups],
    [],
    v"0.0.0",
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
    [CapabilityGroups],
    [],
    v"0.0.0",
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
    [CapabilityGroups],
    [],
    v"0.0.0",
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
    [CapabilityPipes],
    [],
    v"0.0.0",
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
    [CapabilityPipes],
    [],
    v"0.0.0",
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
    [CapabilityPipes],
    [],
    v"0.0.0",
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
    [CapabilityPipes],
    [],
    v"0.0.0",
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
    [CapabilityPipes],
    [],
    v"0.0.0",
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
    [CapabilityPipes],
    [],
    v"0.0.0",
  ),
  OpCommitReadPipe => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Reserve Id'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    [CapabilityPipes],
    [],
    v"0.0.0",
  ),
  OpCommitWritePipe => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdRef, "'Pipe'", nothing),
      OperandInfo(IdRef, "'Reserve Id'", nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    [CapabilityPipes],
    [],
    v"0.0.0",
  ),
  OpIsValidReserveId => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Reserve Id'", nothing),
    ],
    [CapabilityPipes],
    [],
    v"0.0.0",
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
    [CapabilityPipes],
    [],
    v"0.0.0",
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
    [CapabilityPipes],
    [],
    v"0.0.0",
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
    [CapabilityPipes],
    [],
    v"0.0.0",
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
    [CapabilityPipes],
    [],
    v"0.0.0",
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
    [CapabilityPipes],
    [],
    v"0.0.0",
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
    [CapabilityPipes],
    [],
    v"0.0.0",
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
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
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
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
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
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
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
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
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
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
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
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
  ),
  OpRetainEvent => InstructionInfo(
    "Device-Side_Enqueue",
    [OperandInfo(IdRef, "'Event'", nothing)],
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
  ),
  OpReleaseEvent => InstructionInfo(
    "Device-Side_Enqueue",
    [OperandInfo(IdRef, "'Event'", nothing)],
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
  ),
  OpCreateUserEvent => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
  ),
  OpIsValidEvent => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Event'", nothing),
    ],
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
  ),
  OpSetUserEventStatus => InstructionInfo(
    "Device-Side_Enqueue",
    [OperandInfo(IdRef, "'Event'", nothing), OperandInfo(IdRef, "'Status'", nothing)],
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
  ),
  OpCaptureEventProfilingInfo => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdRef, "'Event'", nothing),
      OperandInfo(IdRef, "'Profiling Info'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
  ),
  OpGetDefaultQueue => InstructionInfo(
    "Device-Side_Enqueue",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
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
    [CapabilityDeviceEnqueue],
    [],
    v"0.0.0",
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
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
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
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
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
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
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
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
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
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
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
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
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
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
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
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
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
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
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
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
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
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
  ),
  OpImageSparseTexelsResident => InstructionInfo(
    "Image",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Resident Code'", nothing),
    ],
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
  ),
  OpNoLine => InstructionInfo("Debug", [], [], [], v"0.0.0"),
  OpAtomicFlagTestAndSet => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
  ),
  OpAtomicFlagClear => InstructionInfo(
    "Atomic",
    [
      OperandInfo(IdRef, "'Pointer'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
    ],
    [CapabilityKernel],
    [],
    v"0.0.0",
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
    [CapabilitySparseResidency],
    [],
    v"0.0.0",
  ),
  OpSizeOf => InstructionInfo(
    "Miscellaneous",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pointer'", nothing),
    ],
    [CapabilityAddresses],
    [],
    v"1.1.0",
  ),
  OpTypePipeStorage => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilityPipeStorage],
    [],
    v"1.1.0",
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
    [CapabilityPipeStorage],
    [],
    v"1.1.0",
  ),
  OpCreatePipeFromPipeStorage => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Pipe Storage'", nothing),
    ],
    [CapabilityPipeStorage],
    [],
    v"1.1.0",
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
    [CapabilitySubgroupDispatch],
    [],
    v"1.1.0",
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
    [CapabilitySubgroupDispatch],
    [],
    v"1.1.0",
  ),
  OpTypeNamedBarrier => InstructionInfo(
    "Type-Declaration",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilityNamedBarrier],
    [],
    v"1.1.0",
  ),
  OpNamedBarrierInitialize => InstructionInfo(
    "Barrier",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Subgroup Count'", nothing),
    ],
    [CapabilityNamedBarrier],
    [],
    v"1.1.0",
  ),
  OpMemoryNamedBarrier => InstructionInfo(
    "Barrier",
    [
      OperandInfo(IdRef, "'Named Barrier'", nothing),
      OperandInfo(IdScope, "'Memory'", nothing),
      OperandInfo(IdMemorySemantics, "'Semantics'", nothing),
    ],
    [CapabilityNamedBarrier],
    [],
    v"1.1.0",
  ),
  OpModuleProcessed => InstructionInfo(
    "Debug",
    [OperandInfo(LiteralString, "'Process'", nothing)],
    [],
    [],
    v"1.1.0",
  ),
  OpExecutionModeId => InstructionInfo(
    "Mode-Setting",
    [
      OperandInfo(IdRef, "'Entry Point'", nothing),
      OperandInfo(ExecutionMode, "'Mode'", nothing),
    ],
    [],
    [],
    v"1.2.0",
  ),
  OpDecorateId => InstructionInfo(
    "Annotation",
    [
      OperandInfo(IdRef, "'Target'", nothing),
      OperandInfo(Decoration, nothing, nothing),
    ],
    [],
    ["SPV_GOOGLE_hlsl_functionality1"],
    v"1.2.0",
  ),
  OpGroupNonUniformElect => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
    ],
    [CapabilityGroupNonUniform],
    [],
    v"1.3.0",
  ),
  OpGroupNonUniformAll => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    [CapabilityGroupNonUniformVote],
    [],
    v"1.3.0",
  ),
  OpGroupNonUniformAny => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    [CapabilityGroupNonUniformVote],
    [],
    v"1.3.0",
  ),
  OpGroupNonUniformAllEqual => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    [CapabilityGroupNonUniformVote],
    [],
    v"1.3.0",
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
    [CapabilityGroupNonUniformBallot],
    [],
    v"1.3.0",
  ),
  OpGroupNonUniformBroadcastFirst => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    [CapabilityGroupNonUniformBallot],
    [],
    v"1.3.0",
  ),
  OpGroupNonUniformBallot => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    [CapabilityGroupNonUniformBallot],
    [],
    v"1.3.0",
  ),
  OpGroupNonUniformInverseBallot => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    [CapabilityGroupNonUniformBallot],
    [],
    v"1.3.0",
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
    [CapabilityGroupNonUniformBallot],
    [],
    v"1.3.0",
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
    [CapabilityGroupNonUniformBallot],
    [],
    v"1.3.0",
  ),
  OpGroupNonUniformBallotFindLSB => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    [CapabilityGroupNonUniformBallot],
    [],
    v"1.3.0",
  ),
  OpGroupNonUniformBallotFindMSB => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    [CapabilityGroupNonUniformBallot],
    [],
    v"1.3.0",
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
    [CapabilityGroupNonUniformShuffle],
    [],
    v"1.3.0",
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
    [CapabilityGroupNonUniformShuffle],
    [],
    v"1.3.0",
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
    [CapabilityGroupNonUniformShuffleRelative],
    [],
    v"1.3.0",
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
    [CapabilityGroupNonUniformShuffleRelative],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [
      CapabilityGroupNonUniformArithmetic,
      CapabilityGroupNonUniformClustered,
      CapabilityGroupNonUniformPartitionedNV,
    ],
    [],
    v"1.3.0",
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
    [CapabilityGroupNonUniformQuad],
    [],
    v"1.3.0",
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
    [CapabilityGroupNonUniformQuad],
    [],
    v"1.3.0",
  ),
  OpCopyLogical => InstructionInfo(
    "Composite",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand'", nothing),
    ],
    [],
    [],
    v"1.4.0",
  ),
  OpPtrEqual => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"1.4.0",
  ),
  OpPtrNotEqual => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [],
    [],
    v"1.4.0",
  ),
  OpPtrDiff => InstructionInfo(
    "Memory",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [
      CapabilityAddresses,
      CapabilityVariablePointers,
      CapabilityVariablePointersStorageBuffer,
    ],
    [],
    v"1.4.0",
  ),
  OpTerminateInvocation => InstructionInfo(
    "Control-Flow",
    [],
    [CapabilityShader],
    ["SPV_KHR_terminate_invocation"],
    v"0.0.0",
  ),
  OpSubgroupBallotKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    [CapabilitySubgroupBallotKHR],
    ["SPV_KHR_shader_ballot"],
    v"0.0.0",
  ),
  OpSubgroupFirstInvocationKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    [CapabilitySubgroupBallotKHR],
    ["SPV_KHR_shader_ballot"],
    v"0.0.0",
  ),
  OpSubgroupAllKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    [CapabilitySubgroupVoteKHR],
    ["SPV_KHR_subgroup_vote"],
    v"0.0.0",
  ),
  OpSubgroupAnyKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    [CapabilitySubgroupVoteKHR],
    ["SPV_KHR_subgroup_vote"],
    v"0.0.0",
  ),
  OpSubgroupAllEqualKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Predicate'", nothing),
    ],
    [CapabilitySubgroupVoteKHR],
    ["SPV_KHR_subgroup_vote"],
    v"0.0.0",
  ),
  OpSubgroupReadInvocationKHR => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Value'", nothing),
      OperandInfo(IdRef, "'Index'", nothing),
    ],
    [CapabilitySubgroupBallotKHR],
    ["SPV_KHR_shader_ballot"],
    v"0.0.0",
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
    [CapabilityRayTracingKHR],
    ["SPV_KHR_ray_tracing"],
    v"0.0.0",
  ),
  OpExecuteCallableKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'SBT Index'", nothing),
      OperandInfo(IdRef, "'Callable Data'", nothing),
    ],
    [CapabilityRayTracingKHR],
    ["SPV_KHR_ray_tracing"],
    v"0.0.0",
  ),
  OpConvertUToAccelerationStructureKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Accel'", nothing),
    ],
    [CapabilityRayTracingKHR, CapabilityRayQueryKHR],
    ["SPV_KHR_ray_tracing", "SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpIgnoreIntersectionKHR => InstructionInfo(
    "Reserved",
    [],
    [CapabilityRayTracingKHR],
    ["SPV_KHR_ray_tracing"],
    v"0.0.0",
  ),
  OpTerminateRayKHR => InstructionInfo(
    "Reserved",
    [],
    [CapabilityRayTracingKHR],
    ["SPV_KHR_ray_tracing"],
    v"0.0.0",
  ),
  OpTypeRayQueryKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
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
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryTerminateKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'RayQuery'", nothing)],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGenerateIntersectionKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'RayQuery'", nothing), OperandInfo(IdRef, "'HitT'", nothing)],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryConfirmIntersectionKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdRef, "'RayQuery'", nothing)],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryProceedKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionTypeKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
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
    [CapabilityGroups],
    ["SPV_AMD_shader_ballot"],
    v"0.0.0",
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
    [CapabilityGroups],
    ["SPV_AMD_shader_ballot"],
    v"0.0.0",
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
    [CapabilityGroups],
    ["SPV_AMD_shader_ballot"],
    v"0.0.0",
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
    [CapabilityGroups],
    ["SPV_AMD_shader_ballot"],
    v"0.0.0",
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
    [CapabilityGroups],
    ["SPV_AMD_shader_ballot"],
    v"0.0.0",
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
    [CapabilityGroups],
    ["SPV_AMD_shader_ballot"],
    v"0.0.0",
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
    [CapabilityGroups],
    ["SPV_AMD_shader_ballot"],
    v"0.0.0",
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
    [CapabilityGroups],
    ["SPV_AMD_shader_ballot"],
    v"0.0.0",
  ),
  OpFragmentMaskFetchAMD => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
    ],
    [CapabilityFragmentMaskAMD],
    ["SPV_AMD_shader_fragment_mask"],
    v"0.0.0",
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
    [CapabilityFragmentMaskAMD],
    ["SPV_AMD_shader_fragment_mask"],
    v"0.0.0",
  ),
  OpReadClockKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdScope, "'Execution'", nothing),
    ],
    [CapabilityShaderClockKHR],
    ["SPV_KHR_shader_clock"],
    v"0.0.0",
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
    [CapabilityImageFootprintNV],
    ["SPV_NV_shader_image_footprint"],
    v"0.0.0",
  ),
  OpGroupNonUniformPartitionNV => InstructionInfo(
    "Non-Uniform",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    [CapabilityGroupNonUniformPartitionedNV],
    ["SPV_NV_shader_subgroup_partitioned"],
    v"0.0.0",
  ),
  OpWritePackedPrimitiveIndices4x8NV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'Index Offset'", nothing),
      OperandInfo(IdRef, "'Packed Indices'", nothing),
    ],
    [CapabilityMeshShadingNV],
    ["SPV_NV_mesh_shader"],
    v"0.0.0",
  ),
  OpReportIntersectionNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Hit'", nothing),
      OperandInfo(IdRef, "'HitKind'", nothing),
    ],
    [CapabilityRayTracingNV, CapabilityRayTracingKHR],
    ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
    v"0.0.0",
  ),
  OpReportIntersectionKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Hit'", nothing),
      OperandInfo(IdRef, "'HitKind'", nothing),
    ],
    [CapabilityRayTracingNV, CapabilityRayTracingKHR],
    ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing"],
    v"0.0.0",
  ),
  OpIgnoreIntersectionNV => InstructionInfo(
    "Reserved",
    [],
    [CapabilityRayTracingNV],
    ["SPV_NV_ray_tracing"],
    v"0.0.0",
  ),
  OpTerminateRayNV => InstructionInfo(
    "Reserved",
    [],
    [CapabilityRayTracingNV],
    ["SPV_NV_ray_tracing"],
    v"0.0.0",
  ),
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
    [CapabilityRayTracingNV],
    ["SPV_NV_ray_tracing"],
    v"0.0.0",
  ),
  OpTypeAccelerationStructureNV => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilityRayTracingNV, CapabilityRayTracingKHR, CapabilityRayQueryKHR],
    ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing", "SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpTypeAccelerationStructureKHR => InstructionInfo(
    "Reserved",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilityRayTracingNV, CapabilityRayTracingKHR, CapabilityRayQueryKHR],
    ["SPV_NV_ray_tracing", "SPV_KHR_ray_tracing", "SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpExecuteCallableNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdRef, "'SBT Index'", nothing),
      OperandInfo(IdRef, "'Callable DataId'", nothing),
    ],
    [CapabilityRayTracingNV],
    ["SPV_NV_ray_tracing"],
    v"0.0.0",
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
    [CapabilityCooperativeMatrixNV],
    ["SPV_NV_cooperative_matrix"],
    v"0.0.0",
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
    [CapabilityCooperativeMatrixNV],
    ["SPV_NV_cooperative_matrix"],
    v"0.0.0",
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
    [CapabilityCooperativeMatrixNV],
    ["SPV_NV_cooperative_matrix"],
    v"0.0.0",
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
    [CapabilityCooperativeMatrixNV],
    ["SPV_NV_cooperative_matrix"],
    v"0.0.0",
  ),
  OpCooperativeMatrixLengthNV => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Type'", nothing),
    ],
    [CapabilityCooperativeMatrixNV],
    ["SPV_NV_cooperative_matrix"],
    v"0.0.0",
  ),
  OpBeginInvocationInterlockEXT => InstructionInfo(
    "Reserved",
    [],
    [
      CapabilityFragmentShaderSampleInterlockEXT,
      CapabilityFragmentShaderPixelInterlockEXT,
      CapabilityFragmentShaderShadingRateInterlockEXT,
    ],
    ["SPV_EXT_fragment_shader_interlock"],
    v"0.0.0",
  ),
  OpEndInvocationInterlockEXT => InstructionInfo(
    "Reserved",
    [],
    [
      CapabilityFragmentShaderSampleInterlockEXT,
      CapabilityFragmentShaderPixelInterlockEXT,
      CapabilityFragmentShaderShadingRateInterlockEXT,
    ],
    ["SPV_EXT_fragment_shader_interlock"],
    v"0.0.0",
  ),
  OpDemoteToHelperInvocationEXT => InstructionInfo(
    "Reserved",
    [],
    [CapabilityDemoteToHelperInvocationEXT],
    ["SPV_EXT_demote_to_helper_invocation"],
    v"0.0.0",
  ),
  OpIsHelperInvocationEXT => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [CapabilityDemoteToHelperInvocationEXT],
    ["SPV_EXT_demote_to_helper_invocation"],
    v"0.0.0",
  ),
  OpSubgroupShuffleINTEL => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Data'", nothing),
      OperandInfo(IdRef, "'InvocationId'", nothing),
    ],
    [CapabilitySubgroupShuffleINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupShuffleINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupShuffleINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupShuffleXorINTEL => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Data'", nothing),
      OperandInfo(IdRef, "'Value'", nothing),
    ],
    [CapabilitySubgroupShuffleINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupBlockReadINTEL => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Ptr'", nothing),
    ],
    [CapabilitySubgroupBufferBlockIOINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupBlockWriteINTEL => InstructionInfo(
    "Group",
    [OperandInfo(IdRef, "'Ptr'", nothing), OperandInfo(IdRef, "'Data'", nothing)],
    [CapabilitySubgroupBufferBlockIOINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupImageBlockReadINTEL => InstructionInfo(
    "Group",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
    ],
    [CapabilitySubgroupImageBlockIOINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupImageBlockWriteINTEL => InstructionInfo(
    "Group",
    [
      OperandInfo(IdRef, "'Image'", nothing),
      OperandInfo(IdRef, "'Coordinate'", nothing),
      OperandInfo(IdRef, "'Data'", nothing),
    ],
    [CapabilitySubgroupImageBlockIOINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupImageMediaBlockIOINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupImageMediaBlockIOINTEL],
    [],
    v"0.0.0",
  ),
  OpUCountLeadingZerosINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpUCountTrailingZerosINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpAbsISubINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpAbsUSubINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpIAddSatINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpUAddSatINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpIAverageINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpUAverageINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpIAverageRoundedINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpUAverageRoundedINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpISubSatINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpUSubSatINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpIMul32x16INTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpUMul32x16INTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", nothing),
      OperandInfo(IdRef, "'Operand 2'", nothing),
    ],
    [CapabilityIntegerFunctions2INTEL],
    [],
    v"0.0.0",
  ),
  OpFunctionPointerINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Function'", nothing),
    ],
    [CapabilityFunctionPointersINTEL],
    ["SPV_INTEL_function_pointers"],
    v"0.0.0",
  ),
  OpFunctionPointerCallINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Operand 1'", "*"),
    ],
    [CapabilityFunctionPointersINTEL],
    ["SPV_INTEL_function_pointers"],
    v"0.0.0",
  ),
  OpDecorateString => InstructionInfo(
    "Annotation",
    [
      OperandInfo(IdRef, "'Target'", nothing),
      OperandInfo(Decoration, nothing, nothing),
    ],
    [],
    ["SPV_GOOGLE_decorate_string", "SPV_GOOGLE_hlsl_functionality1"],
    v"1.4.0",
  ),
  OpDecorateStringGOOGLE => InstructionInfo(
    "Annotation",
    [
      OperandInfo(IdRef, "'Target'", nothing),
      OperandInfo(Decoration, nothing, nothing),
    ],
    [],
    ["SPV_GOOGLE_decorate_string", "SPV_GOOGLE_hlsl_functionality1"],
    v"1.4.0",
  ),
  OpMemberDecorateString => InstructionInfo(
    "Annotation",
    [
      OperandInfo(IdRef, "'Struct Type'", nothing),
      OperandInfo(LiteralInteger, "'Member'", nothing),
      OperandInfo(Decoration, nothing, nothing),
    ],
    [],
    ["SPV_GOOGLE_decorate_string", "SPV_GOOGLE_hlsl_functionality1"],
    v"1.4.0",
  ),
  OpMemberDecorateStringGOOGLE => InstructionInfo(
    "Annotation",
    [
      OperandInfo(IdRef, "'Struct Type'", nothing),
      OperandInfo(LiteralInteger, "'Member'", nothing),
      OperandInfo(Decoration, nothing, nothing),
    ],
    [],
    ["SPV_GOOGLE_decorate_string", "SPV_GOOGLE_hlsl_functionality1"],
    v"1.4.0",
  ),
  OpVmeImageINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image Type'", nothing),
      OperandInfo(IdRef, "'Sampler'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeVmeImageINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image Type'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeAvcImePayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeAvcRefPayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeAvcSicPayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeAvcMcePayloadINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeAvcMceResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeAvcImeResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeAvcImeResultSingleReferenceStreamoutINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeAvcImeResultDualReferenceStreamoutINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeAvcImeSingleReferenceStreaminINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeAvcImeDualReferenceStreaminINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeAvcRefResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpTypeAvcSicResultINTEL => InstructionInfo(
    "@exclude",
    [OperandInfo(IdResult, nothing, nothing)],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetDefaultInterBaseMultiReferencePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Slice Type'", nothing),
      OperandInfo(IdRef, "'Qp'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceSetInterBaseMultiReferencePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Reference Base Penalty'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetDefaultInterShapePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Slice Type'", nothing),
      OperandInfo(IdRef, "'Qp'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceSetInterShapePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packed Shape Penalty'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetDefaultInterDirectionPenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Slice Type'", nothing),
      OperandInfo(IdRef, "'Qp'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceSetInterDirectionPenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Direction Cost'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetDefaultIntraLumaShapePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Slice Type'", nothing),
      OperandInfo(IdRef, "'Qp'", nothing),
    ],
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationIntraINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetDefaultInterMotionVectorCostTableINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Slice Type'", nothing),
      OperandInfo(IdRef, "'Qp'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetDefaultHighPenaltyCostTableINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetDefaultMediumPenaltyCostTableINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetDefaultLowPenaltyCostTableINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetDefaultIntraLumaModePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Slice Type'", nothing),
      OperandInfo(IdRef, "'Qp'", nothing),
    ],
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationIntraINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetDefaultNonDcLumaIntraPenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationIntraINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetDefaultIntraChromaModeBasePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
    ],
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationChromaINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceSetAcOnlyHaarINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceSetSourceInterlacedFieldPolarityINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Source Field Polarity'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceSetSingleReferenceInterlacedFieldPolarityINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Reference Field Polarity'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceConvertToImePayloadINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceConvertToImeResultINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceConvertToRefPayloadINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceConvertToRefResultINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceConvertToSicPayloadINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceConvertToSicResultINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetMotionVectorsINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetInterDistortionsINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetBestInterDistortionsINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetInterMajorShapeINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetInterMinorShapeINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetInterDirectionsINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetInterMotionVectorCountINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcMceGetInterReferenceIdsINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeRefWindowSizeINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Search Window Config'", nothing),
      OperandInfo(IdRef, "'Dual Ref'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeConvertToMcePayloadINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeSetMaxMotionVectorCountINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Max Motion Vector Count'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeSetUnidirectionalMixDisableINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeSetEarlySearchTerminationThresholdINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Threshold'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeSetWeightedSadINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packed Sad Weights'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeConvertToMceResultINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeGetSingleReferenceStreaminINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeGetDualReferenceStreaminINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeStripSingleReferenceStreamoutINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeStripDualReferenceStreamoutINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeMotionVectorsINTEL =>
    InstructionInfo(
      "@exclude",
      [
        OperandInfo(IdResultType, nothing, nothing),
        OperandInfo(IdResult, nothing, nothing),
        OperandInfo(IdRef, "'Payload'", nothing),
        OperandInfo(IdRef, "'Major Shape'", nothing),
      ],
      [CapabilitySubgroupAvcMotionEstimationINTEL],
      [],
      v"0.0.0",
    ),
  OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeDistortionsINTEL =>
    InstructionInfo(
      "@exclude",
      [
        OperandInfo(IdResultType, nothing, nothing),
        OperandInfo(IdResult, nothing, nothing),
        OperandInfo(IdRef, "'Payload'", nothing),
        OperandInfo(IdRef, "'Major Shape'", nothing),
      ],
      [CapabilitySubgroupAvcMotionEstimationINTEL],
      [],
      v"0.0.0",
    ),
  OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeReferenceIdsINTEL =>
    InstructionInfo(
      "@exclude",
      [
        OperandInfo(IdResultType, nothing, nothing),
        OperandInfo(IdResult, nothing, nothing),
        OperandInfo(IdRef, "'Payload'", nothing),
        OperandInfo(IdRef, "'Major Shape'", nothing),
      ],
      [CapabilitySubgroupAvcMotionEstimationINTEL],
      [],
      v"0.0.0",
    ),
  OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeMotionVectorsINTEL =>
    InstructionInfo(
      "@exclude",
      [
        OperandInfo(IdResultType, nothing, nothing),
        OperandInfo(IdResult, nothing, nothing),
        OperandInfo(IdRef, "'Payload'", nothing),
        OperandInfo(IdRef, "'Major Shape'", nothing),
        OperandInfo(IdRef, "'Direction'", nothing),
      ],
      [CapabilitySubgroupAvcMotionEstimationINTEL],
      [],
      v"0.0.0",
    ),
  OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeDistortionsINTEL =>
    InstructionInfo(
      "@exclude",
      [
        OperandInfo(IdResultType, nothing, nothing),
        OperandInfo(IdResult, nothing, nothing),
        OperandInfo(IdRef, "'Payload'", nothing),
        OperandInfo(IdRef, "'Major Shape'", nothing),
        OperandInfo(IdRef, "'Direction'", nothing),
      ],
      [CapabilitySubgroupAvcMotionEstimationINTEL],
      [],
      v"0.0.0",
    ),
  OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeReferenceIdsINTEL =>
    InstructionInfo(
      "@exclude",
      [
        OperandInfo(IdResultType, nothing, nothing),
        OperandInfo(IdResult, nothing, nothing),
        OperandInfo(IdRef, "'Payload'", nothing),
        OperandInfo(IdRef, "'Major Shape'", nothing),
        OperandInfo(IdRef, "'Direction'", nothing),
      ],
      [CapabilitySubgroupAvcMotionEstimationINTEL],
      [],
      v"0.0.0",
    ),
  OpSubgroupAvcImeGetBorderReachedINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Image Select'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeGetTruncatedSearchIndicationINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeGetUnidirectionalEarlySearchTerminationINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeGetWeightingPatternMinimumMotionVectorINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcImeGetWeightingPatternMinimumDistortionINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcRefConvertToMcePayloadINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcRefSetBidirectionalMixDisableINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcRefSetBilinearFilterEnableINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcRefConvertToMceResultINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicInitializeINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Coord'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationIntraINTEL,
    ],
    [],
    v"0.0.0",
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
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationChromaINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicGetMotionVectorMaskINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Skip Block Partition Type'", nothing),
      OperandInfo(IdRef, "'Direction'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicConvertToMcePayloadINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicSetIntraLumaShapePenaltyINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packed Shape Penalty'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationIntraINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicSetIntraChromaModeCostFunctionINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Chroma Mode Base Penalty'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationChromaINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicSetBilinearFilterEnableINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicSetSkcForwardTransformEnableINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packed Sad Coefficients'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicSetBlockBasedRawSkipSadINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Block Based Skip Type'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicEvaluateIpeINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Src Image'", nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationIntraINTEL,
    ],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
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
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicConvertToMceResultINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicGetIpeLumaShapeINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationIntraINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicGetBestIpeLumaDistortionINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationIntraINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicGetBestIpeChromaDistortionINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicGetPackedIpeLumaModesINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationIntraINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicGetIpeChromaModeINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationChromaINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicGetPackedSkcLumaCountThresholdINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationIntraINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicGetPackedSkcLumaSumThresholdINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [
      CapabilitySubgroupAvcMotionEstimationINTEL,
      CapabilitySubgroupAvcMotionEstimationIntraINTEL,
    ],
    [],
    v"0.0.0",
  ),
  OpSubgroupAvcSicGetInterRawSadsINTEL => InstructionInfo(
    "@exclude",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Payload'", nothing),
    ],
    [CapabilitySubgroupAvcMotionEstimationINTEL],
    [],
    v"0.0.0",
  ),
  OpLoopControlINTEL => InstructionInfo(
    "Reserved",
    [OperandInfo(LiteralInteger, "'Loop Control Parameters'", "*")],
    [CapabilityUnstructuredLoopControlsINTEL],
    ["SPV_INTEL_unstructured_loop_controls"],
    v"0.0.0",
  ),
  OpReadPipeBlockingINTEL => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    [CapabilityBlockingPipesINTEL],
    ["SPV_INTEL_blocking_pipes"],
    v"0.0.0",
  ),
  OpWritePipeBlockingINTEL => InstructionInfo(
    "Pipe",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Packet Size'", nothing),
      OperandInfo(IdRef, "'Packet Alignment'", nothing),
    ],
    [CapabilityBlockingPipesINTEL],
    ["SPV_INTEL_blocking_pipes"],
    v"0.0.0",
  ),
  OpFPGARegINTEL => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'Result'", nothing),
      OperandInfo(IdRef, "'Input'", nothing),
    ],
    [CapabilityFPGARegINTEL],
    ["SPV_INTEL_fpga_reg"],
    v"0.0.0",
  ),
  OpRayQueryGetRayTMinKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetRayFlagsKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionTKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionInstanceCustomIndexKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionInstanceIdKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR =>
    InstructionInfo(
      "Reserved",
      [
        OperandInfo(IdResultType, nothing, nothing),
        OperandInfo(IdResult, nothing, nothing),
        OperandInfo(IdRef, "'RayQuery'", nothing),
        OperandInfo(IdRef, "'Intersection'", nothing),
      ],
      [CapabilityRayQueryKHR],
      ["SPV_KHR_ray_query"],
      v"0.0.0",
    ),
  OpRayQueryGetIntersectionGeometryIndexKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionPrimitiveIndexKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionBarycentricsKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionFrontFaceKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionCandidateAABBOpaqueKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionObjectRayDirectionKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionObjectRayOriginKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetWorldRayDirectionKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetWorldRayOriginKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionObjectToWorldKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
  ),
  OpRayQueryGetIntersectionWorldToObjectKHR => InstructionInfo(
    "Reserved",
    [
      OperandInfo(IdResultType, nothing, nothing),
      OperandInfo(IdResult, nothing, nothing),
      OperandInfo(IdRef, "'RayQuery'", nothing),
      OperandInfo(IdRef, "'Intersection'", nothing),
    ],
    [CapabilityRayQueryKHR],
    ["SPV_KHR_ray_query"],
    v"0.0.0",
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
    [CapabilityAtomicFloat32AddEXT, CapabilityAtomicFloat64AddEXT],
    ["SPV_EXT_shader_atomic_float_add"],
    v"0.0.0",
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
