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
    OpSubgroupBallotKHR                                                     = 4421
    OpSubgroupFirstInvocationKHR                                            = 4422
    OpSubgroupAllKHR                                                        = 4428
    OpSubgroupAnyKHR                                                        = 4429
    OpSubgroupAllEqualKHR                                                   = 4430
    OpSubgroupReadInvocationKHR                                             = 4432
    OpTypeRayQueryProvisionalKHR                                            = 4472
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
    OpIgnoreIntersectionKHR                                                 = 5335
    OpTerminateRayNV                                                        = 5336
    OpTerminateRayKHR                                                       = 5336
    OpTraceNV                                                               = 5337
    OpTraceRayKHR                                                           = 5337
    OpTypeAccelerationStructureNV                                           = 5341
    OpTypeAccelerationStructureKHR                                          = 5341
    OpExecuteCallableNV                                                     = 5344
    OpExecuteCallableKHR                                                    = 5344
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
end

const classes = Dict(
    OpNop => (Symbol("Miscellaneous"), []),
    OpUndef =>
        (Symbol("Miscellaneous"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpSourceContinued =>
        (Symbol("Debug"), [(kind = "LiteralString", name = "Continued Source")]),
    OpSource => (
        Symbol("Debug"),
        [
            (kind = "SourceLanguage",),
            (kind = "LiteralInteger", name = "Version"),
            (kind = "IdRef", quantifier = "?", name = "File"),
            (kind = "LiteralString", quantifier = "?", name = "Source"),
        ],
    ),
    OpSourceExtension =>
        (Symbol("Debug"), [(kind = "LiteralString", name = "Extension")]),
    OpName => (
        Symbol("Debug"),
        [(kind = "IdRef", name = "Target"), (kind = "LiteralString", name = "Name")],
    ),
    OpMemberName => (
        Symbol("Debug"),
        [
            (kind = "IdRef", name = "Type"),
            (kind = "LiteralInteger", name = "Member"),
            (kind = "LiteralString", name = "Name"),
        ],
    ),
    OpString => (
        Symbol("Debug"),
        [(kind = "IdResult",), (kind = "LiteralString", name = "String")],
    ),
    OpLine => (
        Symbol("Debug"),
        [
            (kind = "IdRef", name = "File"),
            (kind = "LiteralInteger", name = "Line"),
            (kind = "LiteralInteger", name = "Column"),
        ],
    ),
    OpExtension => (Symbol("Extension"), [(kind = "LiteralString", name = "Name")]),
    OpExtInstImport => (
        Symbol("Extension"),
        [(kind = "IdResult",), (kind = "LiteralString", name = "Name")],
    ),
    OpExtInst => (
        Symbol("Extension"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Set"),
            (kind = "LiteralExtInstInteger", name = "Instruction"),
            (kind = "IdRef", quantifier = "*", name = "Operand 1', +\n'Operand 2', +\n..."),
        ],
    ),
    OpMemoryModel => (
        Symbol("Mode-Setting"),
        [(kind = "AddressingModel",), (kind = "MemoryModel",)],
    ),
    OpEntryPoint => (
        Symbol("Mode-Setting"),
        [
            (kind = "ExecutionModel",),
            (kind = "IdRef", name = "Entry Point"),
            (kind = "LiteralString", name = "Name"),
            (kind = "IdRef", quantifier = "*", name = "Interface"),
        ],
    ),
    OpExecutionMode => (
        Symbol("Mode-Setting"),
        [(kind = "IdRef", name = "Entry Point"), (kind = "ExecutionMode", name = "Mode")],
    ),
    OpCapability =>
        (Symbol("Mode-Setting"), [(kind = "Capability", name = "Capability")]),
    OpTypeVoid => (Symbol("Type-Declaration"), [(kind = "IdResult",)]),
    OpTypeBool => (Symbol("Type-Declaration"), [(kind = "IdResult",)]),
    OpTypeInt => (
        Symbol("Type-Declaration"),
        [
            (kind = "IdResult",),
            (kind = "LiteralInteger", name = "Width"),
            (kind = "LiteralInteger", name = "Signedness"),
        ],
    ),
    OpTypeFloat => (
        Symbol("Type-Declaration"),
        [(kind = "IdResult",), (kind = "LiteralInteger", name = "Width")],
    ),
    OpTypeVector => (
        Symbol("Type-Declaration"),
        [
            (kind = "IdResult",),
            (kind = "IdRef", name = "Component Type"),
            (kind = "LiteralInteger", name = "Component Count"),
        ],
    ),
    OpTypeMatrix => (
        Symbol("Type-Declaration"),
        [
            (kind = "IdResult",),
            (kind = "IdRef", name = "Column Type"),
            (kind = "LiteralInteger", name = "Column Count"),
        ],
    ),
    OpTypeImage => (
        Symbol("Type-Declaration"),
        [
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Type"),
            (kind = "Dim",),
            (kind = "LiteralInteger", name = "Depth"),
            (kind = "LiteralInteger", name = "Arrayed"),
            (kind = "LiteralInteger", name = "MS"),
            (kind = "LiteralInteger", name = "Sampled"),
            (kind = "ImageFormat",),
            (kind = "AccessQualifier", quantifier = "?"),
        ],
    ),
    OpTypeSampler => (Symbol("Type-Declaration"), [(kind = "IdResult",)]),
    OpTypeSampledImage => (
        Symbol("Type-Declaration"),
        [(kind = "IdResult",), (kind = "IdRef", name = "Image Type")],
    ),
    OpTypeArray => (
        Symbol("Type-Declaration"),
        [
            (kind = "IdResult",),
            (kind = "IdRef", name = "Element Type"),
            (kind = "IdRef", name = "Length"),
        ],
    ),
    OpTypeRuntimeArray => (
        Symbol("Type-Declaration"),
        [(kind = "IdResult",), (kind = "IdRef", name = "Element Type")],
    ),
    OpTypeStruct => (
        Symbol("Type-Declaration"),
        [
            (kind = "IdResult",),
            (
                kind = "IdRef",
                quantifier = "*",
                name = "Member 0 type', +\n'member 1 type', +\n...",
            ),
        ],
    ),
    OpTypeOpaque => (
        Symbol("Type-Declaration"),
        [
            (kind = "IdResult",),
            (kind = "LiteralString", name = "The name of the opaque type."),
        ],
    ),
    OpTypePointer => (
        Symbol("Type-Declaration"),
        [(kind = "IdResult",), (kind = "StorageClass",), (kind = "IdRef", name = "Type")],
    ),
    OpTypeFunction => (
        Symbol("Type-Declaration"),
        [
            (kind = "IdResult",),
            (kind = "IdRef", name = "Return Type"),
            (
                kind = "IdRef",
                quantifier = "*",
                name = "Parameter 0 Type', +\n'Parameter 1 Type', +\n...",
            ),
        ],
    ),
    OpTypeEvent => (Symbol("Type-Declaration"), [(kind = "IdResult",)]),
    OpTypeDeviceEvent => (Symbol("Type-Declaration"), [(kind = "IdResult",)]),
    OpTypeReserveId => (Symbol("Type-Declaration"), [(kind = "IdResult",)]),
    OpTypeQueue => (Symbol("Type-Declaration"), [(kind = "IdResult",)]),
    OpTypePipe => (
        Symbol("Type-Declaration"),
        [(kind = "IdResult",), (kind = "AccessQualifier", name = "Qualifier")],
    ),
    OpTypeForwardPointer => (
        Symbol("Type-Declaration"),
        [(kind = "IdRef", name = "Pointer Type"), (kind = "StorageClass",)],
    ),
    OpConstantTrue =>
        (Symbol("Constant-Creation"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpConstantFalse =>
        (Symbol("Constant-Creation"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpConstant => (
        Symbol("Constant-Creation"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "LiteralContextDependentNumber", name = "Value"),
        ],
    ),
    OpConstantComposite => (
        Symbol("Constant-Creation"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", quantifier = "*", name = "Constituents"),
        ],
    ),
    OpConstantSampler => (
        Symbol("Constant-Creation"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "SamplerAddressingMode",),
            (kind = "LiteralInteger", name = "Param"),
            (kind = "SamplerFilterMode",),
        ],
    ),
    OpConstantNull =>
        (Symbol("Constant-Creation"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpSpecConstantTrue =>
        (Symbol("Constant-Creation"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpSpecConstantFalse =>
        (Symbol("Constant-Creation"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpSpecConstant => (
        Symbol("Constant-Creation"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "LiteralContextDependentNumber", name = "Value"),
        ],
    ),
    OpSpecConstantComposite => (
        Symbol("Constant-Creation"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", quantifier = "*", name = "Constituents"),
        ],
    ),
    OpSpecConstantOp => (
        Symbol("Constant-Creation"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "LiteralSpecConstantOpInteger", name = "Opcode"),
        ],
    ),
    OpFunction => (
        Symbol("Function"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "FunctionControl",),
            (kind = "IdRef", name = "Function Type"),
        ],
    ),
    OpFunctionParameter =>
        (Symbol("Function"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpFunctionEnd => (Symbol("Function"), []),
    OpFunctionCall => (
        Symbol("Function"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Function"),
            (
                kind = "IdRef",
                quantifier = "*",
                name = "Argument 0', +\n'Argument 1', +\n...",
            ),
        ],
    ),
    OpVariable => (
        Symbol("Memory"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "StorageClass",),
            (kind = "IdRef", quantifier = "?", name = "Initializer"),
        ],
    ),
    OpImageTexelPointer => (
        Symbol("Memory"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "Sample"),
        ],
    ),
    OpLoad => (
        Symbol("Memory"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "MemoryAccess", quantifier = "?"),
        ],
    ),
    OpStore => (
        Symbol("Memory"),
        [
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdRef", name = "Object"),
            (kind = "MemoryAccess", quantifier = "?"),
        ],
    ),
    OpCopyMemory => (
        Symbol("Memory"),
        [
            (kind = "IdRef", name = "Target"),
            (kind = "IdRef", name = "Source"),
            (kind = "MemoryAccess", quantifier = "?"),
            (kind = "MemoryAccess", quantifier = "?"),
        ],
    ),
    OpCopyMemorySized => (
        Symbol("Memory"),
        [
            (kind = "IdRef", name = "Target"),
            (kind = "IdRef", name = "Source"),
            (kind = "IdRef", name = "Size"),
            (kind = "MemoryAccess", quantifier = "?"),
            (kind = "MemoryAccess", quantifier = "?"),
        ],
    ),
    OpAccessChain => (
        Symbol("Memory"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Base"),
            (kind = "IdRef", quantifier = "*", name = "Indexes"),
        ],
    ),
    OpInBoundsAccessChain => (
        Symbol("Memory"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Base"),
            (kind = "IdRef", quantifier = "*", name = "Indexes"),
        ],
    ),
    OpPtrAccessChain => (
        Symbol("Memory"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Base"),
            (kind = "IdRef", name = "Element"),
            (kind = "IdRef", quantifier = "*", name = "Indexes"),
        ],
    ),
    OpArrayLength => (
        Symbol("Memory"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Structure"),
            (kind = "LiteralInteger", name = "Array member"),
        ],
    ),
    OpGenericPtrMemSemantics => (
        Symbol("Memory"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
        ],
    ),
    OpInBoundsPtrAccessChain => (
        Symbol("Memory"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Base"),
            (kind = "IdRef", name = "Element"),
            (kind = "IdRef", quantifier = "*", name = "Indexes"),
        ],
    ),
    OpDecorate => (
        Symbol("Annotation"),
        [(kind = "IdRef", name = "Target"), (kind = "Decoration",)],
    ),
    OpMemberDecorate => (
        Symbol("Annotation"),
        [
            (kind = "IdRef", name = "Structure Type"),
            (kind = "LiteralInteger", name = "Member"),
            (kind = "Decoration",),
        ],
    ),
    OpDecorationGroup => (Symbol("Annotation"), [(kind = "IdResult",)]),
    OpGroupDecorate => (
        Symbol("Annotation"),
        [
            (kind = "IdRef", name = "Decoration Group"),
            (kind = "IdRef", quantifier = "*", name = "Targets"),
        ],
    ),
    OpGroupMemberDecorate => (
        Symbol("Annotation"),
        [
            (kind = "IdRef", name = "Decoration Group"),
            (kind = "PairIdRefLiteralInteger", quantifier = "*", name = "Targets"),
        ],
    ),
    OpVectorExtractDynamic => (
        Symbol("Composite"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Vector"),
            (kind = "IdRef", name = "Index"),
        ],
    ),
    OpVectorInsertDynamic => (
        Symbol("Composite"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Vector"),
            (kind = "IdRef", name = "Component"),
            (kind = "IdRef", name = "Index"),
        ],
    ),
    OpVectorShuffle => (
        Symbol("Composite"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Vector 1"),
            (kind = "IdRef", name = "Vector 2"),
            (kind = "LiteralInteger", quantifier = "*", name = "Components"),
        ],
    ),
    OpCompositeConstruct => (
        Symbol("Composite"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", quantifier = "*", name = "Constituents"),
        ],
    ),
    OpCompositeExtract => (
        Symbol("Composite"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Composite"),
            (kind = "LiteralInteger", quantifier = "*", name = "Indexes"),
        ],
    ),
    OpCompositeInsert => (
        Symbol("Composite"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Object"),
            (kind = "IdRef", name = "Composite"),
            (kind = "LiteralInteger", quantifier = "*", name = "Indexes"),
        ],
    ),
    OpCopyObject => (
        Symbol("Composite"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand"),
        ],
    ),
    OpTranspose => (
        Symbol("Composite"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Matrix")],
    ),
    OpSampledImage => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Sampler"),
        ],
    ),
    OpImageSampleImplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageSampleExplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "ImageOperands",),
        ],
    ),
    OpImageSampleDrefImplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "D~ref~"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageSampleDrefExplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "D~ref~"),
            (kind = "ImageOperands",),
        ],
    ),
    OpImageSampleProjImplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageSampleProjExplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "ImageOperands",),
        ],
    ),
    OpImageSampleProjDrefImplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "D~ref~"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageSampleProjDrefExplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "D~ref~"),
            (kind = "ImageOperands",),
        ],
    ),
    OpImageFetch => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageGather => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "Component"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageDrefGather => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "D~ref~"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageRead => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageWrite => (
        Symbol("Image"),
        [
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "Texel"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImage => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
        ],
    ),
    OpImageQueryFormat => (
        Symbol("Image"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Image")],
    ),
    OpImageQueryOrder => (
        Symbol("Image"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Image")],
    ),
    OpImageQuerySizeLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Level of Detail"),
        ],
    ),
    OpImageQuerySize => (
        Symbol("Image"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Image")],
    ),
    OpImageQueryLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
        ],
    ),
    OpImageQueryLevels => (
        Symbol("Image"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Image")],
    ),
    OpImageQuerySamples => (
        Symbol("Image"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Image")],
    ),
    OpConvertFToU => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Float Value"),
        ],
    ),
    OpConvertFToS => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Float Value"),
        ],
    ),
    OpConvertSToF => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Signed Value"),
        ],
    ),
    OpConvertUToF => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Unsigned Value"),
        ],
    ),
    OpUConvert => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Unsigned Value"),
        ],
    ),
    OpSConvert => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Signed Value"),
        ],
    ),
    OpFConvert => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Float Value"),
        ],
    ),
    OpQuantizeToF16 => (
        Symbol("Conversion"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Value")],
    ),
    OpConvertPtrToU => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
        ],
    ),
    OpSatConvertSToU => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Signed Value"),
        ],
    ),
    OpSatConvertUToS => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Unsigned Value"),
        ],
    ),
    OpConvertUToPtr => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Integer Value"),
        ],
    ),
    OpPtrCastToGeneric => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
        ],
    ),
    OpGenericCastToPtr => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
        ],
    ),
    OpGenericCastToPtrExplicit => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "StorageClass", name = "Storage"),
        ],
    ),
    OpBitcast => (
        Symbol("Conversion"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand"),
        ],
    ),
    OpSNegate => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand"),
        ],
    ),
    OpFNegate => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand"),
        ],
    ),
    OpIAdd => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFAdd => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpISub => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFSub => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpIMul => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFMul => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpUDiv => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpSDiv => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFDiv => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpUMod => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpSRem => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpSMod => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFRem => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFMod => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpVectorTimesScalar => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Vector"),
            (kind = "IdRef", name = "Scalar"),
        ],
    ),
    OpMatrixTimesScalar => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Matrix"),
            (kind = "IdRef", name = "Scalar"),
        ],
    ),
    OpVectorTimesMatrix => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Vector"),
            (kind = "IdRef", name = "Matrix"),
        ],
    ),
    OpMatrixTimesVector => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Matrix"),
            (kind = "IdRef", name = "Vector"),
        ],
    ),
    OpMatrixTimesMatrix => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "LeftMatrix"),
            (kind = "IdRef", name = "RightMatrix"),
        ],
    ),
    OpOuterProduct => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Vector 1"),
            (kind = "IdRef", name = "Vector 2"),
        ],
    ),
    OpDot => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Vector 1"),
            (kind = "IdRef", name = "Vector 2"),
        ],
    ),
    OpIAddCarry => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpISubBorrow => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpUMulExtended => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpSMulExtended => (
        Symbol("Arithmetic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpAny => (
        Symbol("Relational_and_Logical"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Vector")],
    ),
    OpAll => (
        Symbol("Relational_and_Logical"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Vector")],
    ),
    OpIsNan => (
        Symbol("Relational_and_Logical"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "x")],
    ),
    OpIsInf => (
        Symbol("Relational_and_Logical"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "x")],
    ),
    OpIsFinite => (
        Symbol("Relational_and_Logical"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "x")],
    ),
    OpIsNormal => (
        Symbol("Relational_and_Logical"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "x")],
    ),
    OpSignBitSet => (
        Symbol("Relational_and_Logical"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "x")],
    ),
    OpLessOrGreater => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "x"),
            (kind = "IdRef", name = "y"),
        ],
    ),
    OpOrdered => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "x"),
            (kind = "IdRef", name = "y"),
        ],
    ),
    OpUnordered => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "x"),
            (kind = "IdRef", name = "y"),
        ],
    ),
    OpLogicalEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpLogicalNotEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpLogicalOr => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpLogicalAnd => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpLogicalNot => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand"),
        ],
    ),
    OpSelect => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Condition"),
            (kind = "IdRef", name = "Object 1"),
            (kind = "IdRef", name = "Object 2"),
        ],
    ),
    OpIEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpINotEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpUGreaterThan => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpSGreaterThan => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpUGreaterThanEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpSGreaterThanEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpULessThan => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpSLessThan => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpULessThanEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpSLessThanEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFOrdEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFUnordEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFOrdNotEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFUnordNotEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFOrdLessThan => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFUnordLessThan => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFOrdGreaterThan => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFUnordGreaterThan => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFOrdLessThanEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFUnordLessThanEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFOrdGreaterThanEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpFUnordGreaterThanEqual => (
        Symbol("Relational_and_Logical"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpShiftRightLogical => (
        Symbol("Bit"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Base"),
            (kind = "IdRef", name = "Shift"),
        ],
    ),
    OpShiftRightArithmetic => (
        Symbol("Bit"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Base"),
            (kind = "IdRef", name = "Shift"),
        ],
    ),
    OpShiftLeftLogical => (
        Symbol("Bit"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Base"),
            (kind = "IdRef", name = "Shift"),
        ],
    ),
    OpBitwiseOr => (
        Symbol("Bit"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpBitwiseXor => (
        Symbol("Bit"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpBitwiseAnd => (
        Symbol("Bit"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpNot => (
        Symbol("Bit"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand"),
        ],
    ),
    OpBitFieldInsert => (
        Symbol("Bit"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Base"),
            (kind = "IdRef", name = "Insert"),
            (kind = "IdRef", name = "Offset"),
            (kind = "IdRef", name = "Count"),
        ],
    ),
    OpBitFieldSExtract => (
        Symbol("Bit"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Base"),
            (kind = "IdRef", name = "Offset"),
            (kind = "IdRef", name = "Count"),
        ],
    ),
    OpBitFieldUExtract => (
        Symbol("Bit"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Base"),
            (kind = "IdRef", name = "Offset"),
            (kind = "IdRef", name = "Count"),
        ],
    ),
    OpBitReverse => (
        Symbol("Bit"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Base")],
    ),
    OpBitCount => (
        Symbol("Bit"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Base")],
    ),
    OpDPdx => (
        Symbol("Derivative"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "P")],
    ),
    OpDPdy => (
        Symbol("Derivative"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "P")],
    ),
    OpFwidth => (
        Symbol("Derivative"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "P")],
    ),
    OpDPdxFine => (
        Symbol("Derivative"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "P")],
    ),
    OpDPdyFine => (
        Symbol("Derivative"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "P")],
    ),
    OpFwidthFine => (
        Symbol("Derivative"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "P")],
    ),
    OpDPdxCoarse => (
        Symbol("Derivative"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "P")],
    ),
    OpDPdyCoarse => (
        Symbol("Derivative"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "P")],
    ),
    OpFwidthCoarse => (
        Symbol("Derivative"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "P")],
    ),
    OpEmitVertex => (Symbol("Primitive"), []),
    OpEndPrimitive => (Symbol("Primitive"), []),
    OpEmitStreamVertex => (Symbol("Primitive"), [(kind = "IdRef", name = "Stream")]),
    OpEndStreamPrimitive => (Symbol("Primitive"), [(kind = "IdRef", name = "Stream")]),
    OpControlBarrier => (
        Symbol("Barrier"),
        [
            (kind = "IdScope", name = "Execution"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
        ],
    ),
    OpMemoryBarrier => (
        Symbol("Barrier"),
        [
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
        ],
    ),
    OpAtomicLoad => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
        ],
    ),
    OpAtomicStore => (
        Symbol("Atomic"),
        [
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpAtomicExchange => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpAtomicCompareExchange => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Equal"),
            (kind = "IdMemorySemantics", name = "Unequal"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "Comparator"),
        ],
    ),
    OpAtomicCompareExchangeWeak => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Equal"),
            (kind = "IdMemorySemantics", name = "Unequal"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "Comparator"),
        ],
    ),
    OpAtomicIIncrement => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
        ],
    ),
    OpAtomicIDecrement => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
        ],
    ),
    OpAtomicIAdd => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpAtomicISub => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpAtomicSMin => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpAtomicUMin => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpAtomicSMax => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpAtomicUMax => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpAtomicAnd => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpAtomicOr => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpAtomicXor => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpPhi => (
        Symbol("Control-Flow"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "PairIdRefIdRef", quantifier = "*", name = "Variable, Parent, ..."),
        ],
    ),
    OpLoopMerge => (
        Symbol("Control-Flow"),
        [
            (kind = "IdRef", name = "Merge Block"),
            (kind = "IdRef", name = "Continue Target"),
            (kind = "LoopControl",),
        ],
    ),
    OpSelectionMerge => (
        Symbol("Control-Flow"),
        [(kind = "IdRef", name = "Merge Block"), (kind = "SelectionControl",)],
    ),
    OpLabel => (Symbol("Control-Flow"), [(kind = "IdResult",)]),
    OpBranch => (Symbol("Control-Flow"), [(kind = "IdRef", name = "Target Label")]),
    OpBranchConditional => (
        Symbol("Control-Flow"),
        [
            (kind = "IdRef", name = "Condition"),
            (kind = "IdRef", name = "True Label"),
            (kind = "IdRef", name = "False Label"),
            (kind = "LiteralInteger", quantifier = "*", name = "Branch weights"),
        ],
    ),
    OpSwitch => (
        Symbol("Control-Flow"),
        [
            (kind = "IdRef", name = "Selector"),
            (kind = "IdRef", name = "Default"),
            (kind = "PairLiteralIntegerIdRef", quantifier = "*", name = "Target"),
        ],
    ),
    OpKill => (Symbol("Control-Flow"), []),
    OpReturn => (Symbol("Control-Flow"), []),
    OpReturnValue => (Symbol("Control-Flow"), [(kind = "IdRef", name = "Value")]),
    OpUnreachable => (Symbol("Control-Flow"), []),
    OpLifetimeStart => (
        Symbol("Control-Flow"),
        [(kind = "IdRef", name = "Pointer"), (kind = "LiteralInteger", name = "Size")],
    ),
    OpLifetimeStop => (
        Symbol("Control-Flow"),
        [(kind = "IdRef", name = "Pointer"), (kind = "LiteralInteger", name = "Size")],
    ),
    OpGroupAsyncCopy => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Destination"),
            (kind = "IdRef", name = "Source"),
            (kind = "IdRef", name = "Num Elements"),
            (kind = "IdRef", name = "Stride"),
            (kind = "IdRef", name = "Event"),
        ],
    ),
    OpGroupWaitEvents => (
        Symbol("Group"),
        [
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Num Events"),
            (kind = "IdRef", name = "Events List"),
        ],
    ),
    OpGroupAll => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Predicate"),
        ],
    ),
    OpGroupAny => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Predicate"),
        ],
    ),
    OpGroupBroadcast => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "LocalId"),
        ],
    ),
    OpGroupIAdd => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupFAdd => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupFMin => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupUMin => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupSMin => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupFMax => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupUMax => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupSMax => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpReadPipe => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpWritePipe => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpReservedReadPipe => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Reserve Id"),
            (kind = "IdRef", name = "Index"),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpReservedWritePipe => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Reserve Id"),
            (kind = "IdRef", name = "Index"),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpReserveReadPipePackets => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Num Packets"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpReserveWritePipePackets => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Num Packets"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpCommitReadPipe => (
        Symbol("Pipe"),
        [
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Reserve Id"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpCommitWritePipe => (
        Symbol("Pipe"),
        [
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Reserve Id"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpIsValidReserveId => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Reserve Id"),
        ],
    ),
    OpGetNumPipePackets => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpGetMaxPipePackets => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpGroupReserveReadPipePackets => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Num Packets"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpGroupReserveWritePipePackets => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Num Packets"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpGroupCommitReadPipe => (
        Symbol("Pipe"),
        [
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Reserve Id"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpGroupCommitWritePipe => (
        Symbol("Pipe"),
        [
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Pipe"),
            (kind = "IdRef", name = "Reserve Id"),
            (kind = "IdRef", name = "Packet Size"),
            (kind = "IdRef", name = "Packet Alignment"),
        ],
    ),
    OpEnqueueMarker => (
        Symbol("Device-Side_Enqueue"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Queue"),
            (kind = "IdRef", name = "Num Events"),
            (kind = "IdRef", name = "Wait Events"),
            (kind = "IdRef", name = "Ret Event"),
        ],
    ),
    OpEnqueueKernel => (
        Symbol("Device-Side_Enqueue"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Queue"),
            (kind = "IdRef", name = "Flags"),
            (kind = "IdRef", name = "ND Range"),
            (kind = "IdRef", name = "Num Events"),
            (kind = "IdRef", name = "Wait Events"),
            (kind = "IdRef", name = "Ret Event"),
            (kind = "IdRef", name = "Invoke"),
            (kind = "IdRef", name = "Param"),
            (kind = "IdRef", name = "Param Size"),
            (kind = "IdRef", name = "Param Align"),
            (kind = "IdRef", quantifier = "*", name = "Local Size"),
        ],
    ),
    OpGetKernelNDrangeSubGroupCount => (
        Symbol("Device-Side_Enqueue"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "ND Range"),
            (kind = "IdRef", name = "Invoke"),
            (kind = "IdRef", name = "Param"),
            (kind = "IdRef", name = "Param Size"),
            (kind = "IdRef", name = "Param Align"),
        ],
    ),
    OpGetKernelNDrangeMaxSubGroupSize => (
        Symbol("Device-Side_Enqueue"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "ND Range"),
            (kind = "IdRef", name = "Invoke"),
            (kind = "IdRef", name = "Param"),
            (kind = "IdRef", name = "Param Size"),
            (kind = "IdRef", name = "Param Align"),
        ],
    ),
    OpGetKernelWorkGroupSize => (
        Symbol("Device-Side_Enqueue"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Invoke"),
            (kind = "IdRef", name = "Param"),
            (kind = "IdRef", name = "Param Size"),
            (kind = "IdRef", name = "Param Align"),
        ],
    ),
    OpGetKernelPreferredWorkGroupSizeMultiple => (
        Symbol("Device-Side_Enqueue"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Invoke"),
            (kind = "IdRef", name = "Param"),
            (kind = "IdRef", name = "Param Size"),
            (kind = "IdRef", name = "Param Align"),
        ],
    ),
    OpRetainEvent =>
        (Symbol("Device-Side_Enqueue"), [(kind = "IdRef", name = "Event")]),
    OpReleaseEvent =>
        (Symbol("Device-Side_Enqueue"), [(kind = "IdRef", name = "Event")]),
    OpCreateUserEvent => (
        Symbol("Device-Side_Enqueue"),
        [(kind = "IdResultType",), (kind = "IdResult",)],
    ),
    OpIsValidEvent => (
        Symbol("Device-Side_Enqueue"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Event")],
    ),
    OpSetUserEventStatus => (
        Symbol("Device-Side_Enqueue"),
        [(kind = "IdRef", name = "Event"), (kind = "IdRef", name = "Status")],
    ),
    OpCaptureEventProfilingInfo => (
        Symbol("Device-Side_Enqueue"),
        [
            (kind = "IdRef", name = "Event"),
            (kind = "IdRef", name = "Profiling Info"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpGetDefaultQueue => (
        Symbol("Device-Side_Enqueue"),
        [(kind = "IdResultType",), (kind = "IdResult",)],
    ),
    OpBuildNDRange => (
        Symbol("Device-Side_Enqueue"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "GlobalWorkSize"),
            (kind = "IdRef", name = "LocalWorkSize"),
            (kind = "IdRef", name = "GlobalWorkOffset"),
        ],
    ),
    OpImageSparseSampleImplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageSparseSampleExplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "ImageOperands",),
        ],
    ),
    OpImageSparseSampleDrefImplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "D~ref~"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageSparseSampleDrefExplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "D~ref~"),
            (kind = "ImageOperands",),
        ],
    ),
    OpImageSparseSampleProjImplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageSparseSampleProjExplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "ImageOperands",),
        ],
    ),
    OpImageSparseSampleProjDrefImplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "D~ref~"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageSparseSampleProjDrefExplicitLod => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "D~ref~"),
            (kind = "ImageOperands",),
        ],
    ),
    OpImageSparseFetch => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageSparseGather => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "Component"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageSparseDrefGather => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "D~ref~"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpImageSparseTexelsResident => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Resident Code"),
        ],
    ),
    OpNoLine => (Symbol("Debug"), []),
    OpAtomicFlagTestAndSet => (
        Symbol("Atomic"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
        ],
    ),
    OpAtomicFlagClear => (
        Symbol("Atomic"),
        [
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
        ],
    ),
    OpImageSparseRead => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpSizeOf => (
        Symbol("Miscellaneous"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
        ],
    ),
    OpTypePipeStorage => (Symbol("Type-Declaration"), [(kind = "IdResult",)]),
    OpConstantPipeStorage => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "LiteralInteger", name = "Packet Size"),
            (kind = "LiteralInteger", name = "Packet Alignment"),
            (kind = "LiteralInteger", name = "Capacity"),
        ],
    ),
    OpCreatePipeFromPipeStorage => (
        Symbol("Pipe"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pipe Storage"),
        ],
    ),
    OpGetKernelLocalSizeForSubgroupCount => (
        Symbol("Device-Side_Enqueue"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Subgroup Count"),
            (kind = "IdRef", name = "Invoke"),
            (kind = "IdRef", name = "Param"),
            (kind = "IdRef", name = "Param Size"),
            (kind = "IdRef", name = "Param Align"),
        ],
    ),
    OpGetKernelMaxNumSubgroups => (
        Symbol("Device-Side_Enqueue"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Invoke"),
            (kind = "IdRef", name = "Param"),
            (kind = "IdRef", name = "Param Size"),
            (kind = "IdRef", name = "Param Align"),
        ],
    ),
    OpTypeNamedBarrier => (Symbol("Type-Declaration"), [(kind = "IdResult",)]),
    OpNamedBarrierInitialize => (
        Symbol("Barrier"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Subgroup Count"),
        ],
    ),
    OpMemoryNamedBarrier => (
        Symbol("Barrier"),
        [
            (kind = "IdRef", name = "Named Barrier"),
            (kind = "IdScope", name = "Memory"),
            (kind = "IdMemorySemantics", name = "Semantics"),
        ],
    ),
    OpModuleProcessed =>
        (Symbol("Debug"), [(kind = "LiteralString", name = "Process")]),
    OpExecutionModeId => (
        Symbol("Mode-Setting"),
        [(kind = "IdRef", name = "Entry Point"), (kind = "ExecutionMode", name = "Mode")],
    ),
    OpDecorateId => (
        Symbol("Annotation"),
        [(kind = "IdRef", name = "Target"), (kind = "Decoration",)],
    ),
    OpGroupNonUniformElect => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
        ],
    ),
    OpGroupNonUniformAll => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Predicate"),
        ],
    ),
    OpGroupNonUniformAny => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Predicate"),
        ],
    ),
    OpGroupNonUniformAllEqual => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpGroupNonUniformBroadcast => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "Id"),
        ],
    ),
    OpGroupNonUniformBroadcastFirst => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpGroupNonUniformBallot => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Predicate"),
        ],
    ),
    OpGroupNonUniformInverseBallot => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpGroupNonUniformBallotBitExtract => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "Index"),
        ],
    ),
    OpGroupNonUniformBallotBitCount => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpGroupNonUniformBallotFindLSB => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpGroupNonUniformBallotFindMSB => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpGroupNonUniformShuffle => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "Id"),
        ],
    ),
    OpGroupNonUniformShuffleXor => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "Mask"),
        ],
    ),
    OpGroupNonUniformShuffleUp => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "Delta"),
        ],
    ),
    OpGroupNonUniformShuffleDown => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "Delta"),
        ],
    ),
    OpGroupNonUniformIAdd => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformFAdd => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformIMul => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformFMul => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformSMin => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformUMin => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformFMin => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformSMax => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformUMax => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformFMax => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformBitwiseAnd => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformBitwiseOr => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformBitwiseXor => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformLogicalAnd => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformLogicalOr => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformLogicalXor => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "ClusterSize", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformQuadBroadcast => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "Index"),
        ],
    ),
    OpGroupNonUniformQuadSwap => (
        Symbol("Non-Uniform"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "Direction"),
        ],
    ),
    OpCopyLogical => (
        Symbol("Composite"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand"),
        ],
    ),
    OpPtrEqual => (
        Symbol("Memory"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpPtrNotEqual => (
        Symbol("Memory"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpPtrDiff => (
        Symbol("Memory"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpSubgroupBallotKHR => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Predicate"),
        ],
    ),
    OpSubgroupFirstInvocationKHR => (
        Symbol("Group"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Value")],
    ),
    OpSubgroupAllKHR => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Predicate"),
        ],
    ),
    OpSubgroupAnyKHR => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Predicate"),
        ],
    ),
    OpSubgroupAllEqualKHR => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Predicate"),
        ],
    ),
    OpSubgroupReadInvocationKHR => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Value"),
            (kind = "IdRef", name = "Index"),
        ],
    ),
    OpTypeRayQueryProvisionalKHR => (Symbol("Reserved"), [(kind = "IdResult",)]),
    OpRayQueryInitializeKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Accel"),
            (kind = "IdRef", name = "RayFlags"),
            (kind = "IdRef", name = "CullMask"),
            (kind = "IdRef", name = "RayOrigin"),
            (kind = "IdRef", name = "RayTMin"),
            (kind = "IdRef", name = "RayDirection"),
            (kind = "IdRef", name = "RayTMax"),
        ],
    ),
    OpRayQueryTerminateKHR =>
        (Symbol("Reserved"), [(kind = "IdRef", name = "RayQuery")]),
    OpRayQueryGenerateIntersectionKHR => (
        Symbol("Reserved"),
        [(kind = "IdRef", name = "RayQuery"), (kind = "IdRef", name = "HitT")],
    ),
    OpRayQueryConfirmIntersectionKHR =>
        (Symbol("Reserved"), [(kind = "IdRef", name = "RayQuery")]),
    OpRayQueryProceedKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
        ],
    ),
    OpRayQueryGetIntersectionTypeKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
    OpGroupIAddNonUniformAMD => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupFAddNonUniformAMD => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupFMinNonUniformAMD => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupUMinNonUniformAMD => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupSMinNonUniformAMD => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupFMaxNonUniformAMD => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupUMaxNonUniformAMD => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpGroupSMaxNonUniformAMD => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
            (kind = "GroupOperation", name = "Operation"),
            (kind = "IdRef", name = "X"),
        ],
    ),
    OpFragmentMaskFetchAMD => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Coordinate"),
        ],
    ),
    OpFragmentFetchAMD => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "Fragment Index"),
        ],
    ),
    OpReadClockKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdScope", name = "Execution"),
        ],
    ),
    OpImageSampleFootprintNV => (
        Symbol("Image"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Sampled Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "Granularity"),
            (kind = "IdRef", name = "Coarse"),
            (kind = "ImageOperands", quantifier = "?"),
        ],
    ),
    OpGroupNonUniformPartitionNV => (
        Symbol("Non-Uniform"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Value")],
    ),
    OpWritePackedPrimitiveIndices4x8NV => (
        Symbol("Reserved"),
        [
            (kind = "IdRef", name = "Index Offset"),
            (kind = "IdRef", name = "Packed Indices"),
        ],
    ),
    OpReportIntersectionNV => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Hit"),
            (kind = "IdRef", name = "HitKind"),
        ],
    ),
    OpReportIntersectionKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Hit"),
            (kind = "IdRef", name = "HitKind"),
        ],
    ),
    OpIgnoreIntersectionNV => (Symbol("Reserved"), []),
    OpIgnoreIntersectionKHR => (Symbol("Reserved"), []),
    OpTerminateRayNV => (Symbol("Reserved"), []),
    OpTerminateRayKHR => (Symbol("Reserved"), []),
    OpTraceNV => (
        Symbol("Reserved"),
        [
            (kind = "IdRef", name = "Accel"),
            (kind = "IdRef", name = "Ray Flags"),
            (kind = "IdRef", name = "Cull Mask"),
            (kind = "IdRef", name = "SBT Offset"),
            (kind = "IdRef", name = "SBT Stride"),
            (kind = "IdRef", name = "Miss Index"),
            (kind = "IdRef", name = "Ray Origin"),
            (kind = "IdRef", name = "Ray Tmin"),
            (kind = "IdRef", name = "Ray Direction"),
            (kind = "IdRef", name = "Ray Tmax"),
            (kind = "IdRef", name = "PayloadId"),
        ],
    ),
    OpTraceRayKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdRef", name = "Accel"),
            (kind = "IdRef", name = "Ray Flags"),
            (kind = "IdRef", name = "Cull Mask"),
            (kind = "IdRef", name = "SBT Offset"),
            (kind = "IdRef", name = "SBT Stride"),
            (kind = "IdRef", name = "Miss Index"),
            (kind = "IdRef", name = "Ray Origin"),
            (kind = "IdRef", name = "Ray Tmin"),
            (kind = "IdRef", name = "Ray Direction"),
            (kind = "IdRef", name = "Ray Tmax"),
            (kind = "IdRef", name = "PayloadId"),
        ],
    ),
    OpTypeAccelerationStructureNV => (Symbol("Reserved"), [(kind = "IdResult",)]),
    OpTypeAccelerationStructureKHR => (Symbol("Reserved"), [(kind = "IdResult",)]),
    OpExecuteCallableNV => (
        Symbol("Reserved"),
        [(kind = "IdRef", name = "SBT Index"), (kind = "IdRef", name = "Callable DataId")],
    ),
    OpExecuteCallableKHR => (
        Symbol("Reserved"),
        [(kind = "IdRef", name = "SBT Index"), (kind = "IdRef", name = "Callable DataId")],
    ),
    OpTypeCooperativeMatrixNV => (
        Symbol("Reserved"),
        [
            (kind = "IdResult",),
            (kind = "IdRef", name = "Component Type"),
            (kind = "IdScope", name = "Execution"),
            (kind = "IdRef", name = "Rows"),
            (kind = "IdRef", name = "Columns"),
        ],
    ),
    OpCooperativeMatrixLoadNV => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdRef", name = "Stride"),
            (kind = "IdRef", name = "Column Major"),
            (kind = "MemoryAccess", quantifier = "?"),
        ],
    ),
    OpCooperativeMatrixStoreNV => (
        Symbol("Reserved"),
        [
            (kind = "IdRef", name = "Pointer"),
            (kind = "IdRef", name = "Object"),
            (kind = "IdRef", name = "Stride"),
            (kind = "IdRef", name = "Column Major"),
            (kind = "MemoryAccess", quantifier = "?"),
        ],
    ),
    OpCooperativeMatrixMulAddNV => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "A"),
            (kind = "IdRef", name = "B"),
            (kind = "IdRef", name = "C"),
        ],
    ),
    OpCooperativeMatrixLengthNV => (
        Symbol("Reserved"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Type")],
    ),
    OpBeginInvocationInterlockEXT => (Symbol("Reserved"), []),
    OpEndInvocationInterlockEXT => (Symbol("Reserved"), []),
    OpDemoteToHelperInvocationEXT => (Symbol("Reserved"), []),
    OpIsHelperInvocationEXT =>
        (Symbol("Reserved"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpSubgroupShuffleINTEL => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Data"),
            (kind = "IdRef", name = "InvocationId"),
        ],
    ),
    OpSubgroupShuffleDownINTEL => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Current"),
            (kind = "IdRef", name = "Next"),
            (kind = "IdRef", name = "Delta"),
        ],
    ),
    OpSubgroupShuffleUpINTEL => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Previous"),
            (kind = "IdRef", name = "Current"),
            (kind = "IdRef", name = "Delta"),
        ],
    ),
    OpSubgroupShuffleXorINTEL => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Data"),
            (kind = "IdRef", name = "Value"),
        ],
    ),
    OpSubgroupBlockReadINTEL => (
        Symbol("Group"),
        [(kind = "IdResultType",), (kind = "IdResult",), (kind = "IdRef", name = "Ptr")],
    ),
    OpSubgroupBlockWriteINTEL => (
        Symbol("Group"),
        [(kind = "IdRef", name = "Ptr"), (kind = "IdRef", name = "Data")],
    ),
    OpSubgroupImageBlockReadINTEL => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Coordinate"),
        ],
    ),
    OpSubgroupImageBlockWriteINTEL => (
        Symbol("Group"),
        [
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "Data"),
        ],
    ),
    OpSubgroupImageMediaBlockReadINTEL => (
        Symbol("Group"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "Width"),
            (kind = "IdRef", name = "Height"),
        ],
    ),
    OpSubgroupImageMediaBlockWriteINTEL => (
        Symbol("Group"),
        [
            (kind = "IdRef", name = "Image"),
            (kind = "IdRef", name = "Coordinate"),
            (kind = "IdRef", name = "Width"),
            (kind = "IdRef", name = "Height"),
            (kind = "IdRef", name = "Data"),
        ],
    ),
    OpUCountLeadingZerosINTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand"),
        ],
    ),
    OpUCountTrailingZerosINTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand"),
        ],
    ),
    OpAbsISubINTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpAbsUSubINTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpIAddSatINTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpUAddSatINTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpIAverageINTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpUAverageINTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpIAverageRoundedINTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpUAverageRoundedINTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpISubSatINTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpUSubSatINTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpIMul32x16INTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpUMul32x16INTEL => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Operand 1"),
            (kind = "IdRef", name = "Operand 2"),
        ],
    ),
    OpDecorateString => (
        Symbol("Annotation"),
        [(kind = "IdRef", name = "Target"), (kind = "Decoration",)],
    ),
    OpDecorateStringGOOGLE => (
        Symbol("Annotation"),
        [(kind = "IdRef", name = "Target"), (kind = "Decoration",)],
    ),
    OpMemberDecorateString => (
        Symbol("Annotation"),
        [
            (kind = "IdRef", name = "Struct Type"),
            (kind = "LiteralInteger", name = "Member"),
            (kind = "Decoration",),
        ],
    ),
    OpMemberDecorateStringGOOGLE => (
        Symbol("Annotation"),
        [
            (kind = "IdRef", name = "Struct Type"),
            (kind = "LiteralInteger", name = "Member"),
            (kind = "Decoration",),
        ],
    ),
    OpVmeImageINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image Type"),
            (kind = "IdRef", name = "Sampler"),
        ],
    ),
    OpTypeVmeImageINTEL => (
        Symbol("@exclude"),
        [(kind = "IdResult",), (kind = "IdRef", name = "Image Type")],
    ),
    OpTypeAvcImePayloadINTEL => (Symbol("@exclude"), [(kind = "IdResult",)]),
    OpTypeAvcRefPayloadINTEL => (Symbol("@exclude"), [(kind = "IdResult",)]),
    OpTypeAvcSicPayloadINTEL => (Symbol("@exclude"), [(kind = "IdResult",)]),
    OpTypeAvcMcePayloadINTEL => (Symbol("@exclude"), [(kind = "IdResult",)]),
    OpTypeAvcMceResultINTEL => (Symbol("@exclude"), [(kind = "IdResult",)]),
    OpTypeAvcImeResultINTEL => (Symbol("@exclude"), [(kind = "IdResult",)]),
    OpTypeAvcImeResultSingleReferenceStreamoutINTEL =>
        (Symbol("@exclude"), [(kind = "IdResult",)]),
    OpTypeAvcImeResultDualReferenceStreamoutINTEL =>
        (Symbol("@exclude"), [(kind = "IdResult",)]),
    OpTypeAvcImeSingleReferenceStreaminINTEL =>
        (Symbol("@exclude"), [(kind = "IdResult",)]),
    OpTypeAvcImeDualReferenceStreaminINTEL =>
        (Symbol("@exclude"), [(kind = "IdResult",)]),
    OpTypeAvcRefResultINTEL => (Symbol("@exclude"), [(kind = "IdResult",)]),
    OpTypeAvcSicResultINTEL => (Symbol("@exclude"), [(kind = "IdResult",)]),
    OpSubgroupAvcMceGetDefaultInterBaseMultiReferencePenaltyINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Slice Type"),
            (kind = "IdRef", name = "Qp"),
        ],
    ),
    OpSubgroupAvcMceSetInterBaseMultiReferencePenaltyINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Reference Base Penalty"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetDefaultInterShapePenaltyINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Slice Type"),
            (kind = "IdRef", name = "Qp"),
        ],
    ),
    OpSubgroupAvcMceSetInterShapePenaltyINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Packed Shape Penalty"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetDefaultInterDirectionPenaltyINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Slice Type"),
            (kind = "IdRef", name = "Qp"),
        ],
    ),
    OpSubgroupAvcMceSetInterDirectionPenaltyINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Direction Cost"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetDefaultIntraLumaShapePenaltyINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Slice Type"),
            (kind = "IdRef", name = "Qp"),
        ],
    ),
    OpSubgroupAvcMceGetDefaultInterMotionVectorCostTableINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Slice Type"),
            (kind = "IdRef", name = "Qp"),
        ],
    ),
    OpSubgroupAvcMceGetDefaultHighPenaltyCostTableINTEL =>
        (Symbol("@exclude"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpSubgroupAvcMceGetDefaultMediumPenaltyCostTableINTEL =>
        (Symbol("@exclude"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpSubgroupAvcMceGetDefaultLowPenaltyCostTableINTEL =>
        (Symbol("@exclude"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpSubgroupAvcMceSetMotionVectorCostFunctionINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Packed Cost Center Delta"),
            (kind = "IdRef", name = "Packed Cost Table"),
            (kind = "IdRef", name = "Cost Precision"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetDefaultIntraLumaModePenaltyINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Slice Type"),
            (kind = "IdRef", name = "Qp"),
        ],
    ),
    OpSubgroupAvcMceGetDefaultNonDcLumaIntraPenaltyINTEL =>
        (Symbol("@exclude"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpSubgroupAvcMceGetDefaultIntraChromaModeBasePenaltyINTEL =>
        (Symbol("@exclude"), [(kind = "IdResultType",), (kind = "IdResult",)]),
    OpSubgroupAvcMceSetAcOnlyHaarINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceSetSourceInterlacedFieldPolarityINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Source Field Polarity"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceSetSingleReferenceInterlacedFieldPolarityINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Reference Field Polarity"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceSetDualReferenceInterlacedFieldPolaritiesINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Forward Reference Field Polarity"),
            (kind = "IdRef", name = "Backward Reference Field Polarity"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceConvertToImePayloadINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceConvertToImeResultINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceConvertToRefPayloadINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceConvertToRefResultINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceConvertToSicPayloadINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceConvertToSicResultINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetMotionVectorsINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetInterDistortionsINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetBestInterDistortionsINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetInterMajorShapeINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetInterMinorShapeINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetInterDirectionsINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetInterMotionVectorCountINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetInterReferenceIdsINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcMceGetInterReferenceInterlacedFieldPolaritiesINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Packed Reference Ids"),
            (kind = "IdRef", name = "Packed Reference Parameter Field Polarities"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeInitializeINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Coord"),
            (kind = "IdRef", name = "Partition Mask"),
            (kind = "IdRef", name = "SAD Adjustment"),
        ],
    ),
    OpSubgroupAvcImeSetSingleReferenceINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Ref Offset"),
            (kind = "IdRef", name = "Search Window Config"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeSetDualReferenceINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Fwd Ref Offset"),
            (kind = "IdRef", name = "Bwd Ref Offset"),
            (kind = "IdRef", name = "id> Search Window Config"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeRefWindowSizeINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Search Window Config"),
            (kind = "IdRef", name = "Dual Ref"),
        ],
    ),
    OpSubgroupAvcImeAdjustRefOffsetINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Ref Offset"),
            (kind = "IdRef", name = "Src Coord"),
            (kind = "IdRef", name = "Ref Window Size"),
            (kind = "IdRef", name = "Image Size"),
        ],
    ),
    OpSubgroupAvcImeConvertToMcePayloadINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeSetMaxMotionVectorCountINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Max Motion Vector Count"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeSetUnidirectionalMixDisableINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeSetEarlySearchTerminationThresholdINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Threshold"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeSetWeightedSadINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Packed Sad Weights"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeEvaluateWithSingleReferenceINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Ref Image"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeEvaluateWithDualReferenceINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Fwd Ref Image"),
            (kind = "IdRef", name = "Bwd Ref Image"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeEvaluateWithSingleReferenceStreaminINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Ref Image"),
            (kind = "IdRef", name = "Payload"),
            (kind = "IdRef", name = "Streamin Components"),
        ],
    ),
    OpSubgroupAvcImeEvaluateWithDualReferenceStreaminINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Fwd Ref Image"),
            (kind = "IdRef", name = "Bwd Ref Image"),
            (kind = "IdRef", name = "Payload"),
            (kind = "IdRef", name = "Streamin Components"),
        ],
    ),
    OpSubgroupAvcImeEvaluateWithSingleReferenceStreamoutINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Ref Image"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeEvaluateWithDualReferenceStreamoutINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Fwd Ref Image"),
            (kind = "IdRef", name = "Bwd Ref Image"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeEvaluateWithSingleReferenceStreaminoutINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Ref Image"),
            (kind = "IdRef", name = "Payload"),
            (kind = "IdRef", name = "Streamin Components"),
        ],
    ),
    OpSubgroupAvcImeEvaluateWithDualReferenceStreaminoutINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Fwd Ref Image"),
            (kind = "IdRef", name = "Bwd Ref Image"),
            (kind = "IdRef", name = "Payload"),
            (kind = "IdRef", name = "Streamin Components"),
        ],
    ),
    OpSubgroupAvcImeConvertToMceResultINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeGetSingleReferenceStreaminINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeGetDualReferenceStreaminINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeStripSingleReferenceStreamoutINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeStripDualReferenceStreamoutINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeMotionVectorsINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
            (kind = "IdRef", name = "Major Shape"),
        ],
    ),
    OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeDistortionsINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
            (kind = "IdRef", name = "Major Shape"),
        ],
    ),
    OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeReferenceIdsINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
            (kind = "IdRef", name = "Major Shape"),
        ],
    ),
    OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeMotionVectorsINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
            (kind = "IdRef", name = "Major Shape"),
            (kind = "IdRef", name = "Direction"),
        ],
    ),
    OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeDistortionsINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
            (kind = "IdRef", name = "Major Shape"),
            (kind = "IdRef", name = "Direction"),
        ],
    ),
    OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeReferenceIdsINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
            (kind = "IdRef", name = "Major Shape"),
            (kind = "IdRef", name = "Direction"),
        ],
    ),
    OpSubgroupAvcImeGetBorderReachedINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Image Select"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeGetTruncatedSearchIndicationINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeGetUnidirectionalEarlySearchTerminationINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeGetWeightingPatternMinimumMotionVectorINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcImeGetWeightingPatternMinimumDistortionINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcFmeInitializeINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Coord"),
            (kind = "IdRef", name = "Motion Vectors"),
            (kind = "IdRef", name = "Major Shapes"),
            (kind = "IdRef", name = "Minor Shapes"),
            (kind = "IdRef", name = "Direction"),
            (kind = "IdRef", name = "Pixel Resolution"),
            (kind = "IdRef", name = "Sad Adjustment"),
        ],
    ),
    OpSubgroupAvcBmeInitializeINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Coord"),
            (kind = "IdRef", name = "Motion Vectors"),
            (kind = "IdRef", name = "Major Shapes"),
            (kind = "IdRef", name = "Minor Shapes"),
            (kind = "IdRef", name = "Direction"),
            (kind = "IdRef", name = "Pixel Resolution"),
            (kind = "IdRef", name = "Bidirectional Weight"),
            (kind = "IdRef", name = "Sad Adjustment"),
        ],
    ),
    OpSubgroupAvcRefConvertToMcePayloadINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcRefSetBidirectionalMixDisableINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcRefSetBilinearFilterEnableINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcRefEvaluateWithSingleReferenceINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Ref Image"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcRefEvaluateWithDualReferenceINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Fwd Ref Image"),
            (kind = "IdRef", name = "Bwd Ref Image"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcRefEvaluateWithMultiReferenceINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Packed Reference Ids"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcRefEvaluateWithMultiReferenceInterlacedINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Packed Reference Ids"),
            (kind = "IdRef", name = "Packed Reference Field Polarities"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcRefConvertToMceResultINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicInitializeINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Coord"),
        ],
    ),
    OpSubgroupAvcSicConfigureSkcINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Skip Block Partition Type"),
            (kind = "IdRef", name = "Skip Motion Vector Mask"),
            (kind = "IdRef", name = "Motion Vectors"),
            (kind = "IdRef", name = "Bidirectional Weight"),
            (kind = "IdRef", name = "Sad Adjustment"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicConfigureIpeLumaINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Luma Intra Partition Mask"),
            (kind = "IdRef", name = "Intra Neighbour Availabilty"),
            (kind = "IdRef", name = "Left Edge Luma Pixels"),
            (kind = "IdRef", name = "Upper Left Corner Luma Pixel"),
            (kind = "IdRef", name = "Upper Edge Luma Pixels"),
            (kind = "IdRef", name = "Upper Right Edge Luma Pixels"),
            (kind = "IdRef", name = "Sad Adjustment"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicConfigureIpeLumaChromaINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Luma Intra Partition Mask"),
            (kind = "IdRef", name = "Intra Neighbour Availabilty"),
            (kind = "IdRef", name = "Left Edge Luma Pixels"),
            (kind = "IdRef", name = "Upper Left Corner Luma Pixel"),
            (kind = "IdRef", name = "Upper Edge Luma Pixels"),
            (kind = "IdRef", name = "Upper Right Edge Luma Pixels"),
            (kind = "IdRef", name = "Left Edge Chroma Pixels"),
            (kind = "IdRef", name = "Upper Left Corner Chroma Pixel"),
            (kind = "IdRef", name = "Upper Edge Chroma Pixels"),
            (kind = "IdRef", name = "Sad Adjustment"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicGetMotionVectorMaskINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Skip Block Partition Type"),
            (kind = "IdRef", name = "Direction"),
        ],
    ),
    OpSubgroupAvcSicConvertToMcePayloadINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicSetIntraLumaShapePenaltyINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Packed Shape Penalty"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicSetIntraLumaModeCostFunctionINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Luma Mode Penalty"),
            (kind = "IdRef", name = "Luma Packed Neighbor Modes"),
            (kind = "IdRef", name = "Luma Packed Non Dc Penalty"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicSetIntraChromaModeCostFunctionINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Chroma Mode Base Penalty"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicSetBilinearFilterEnableINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicSetSkcForwardTransformEnableINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Packed Sad Coefficients"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicSetBlockBasedRawSkipSadINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Block Based Skip Type"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicEvaluateIpeINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicEvaluateWithSingleReferenceINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Ref Image"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicEvaluateWithDualReferenceINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Fwd Ref Image"),
            (kind = "IdRef", name = "Bwd Ref Image"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicEvaluateWithMultiReferenceINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Packed Reference Ids"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicEvaluateWithMultiReferenceInterlacedINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Src Image"),
            (kind = "IdRef", name = "Packed Reference Ids"),
            (kind = "IdRef", name = "Packed Reference Field Polarities"),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicConvertToMceResultINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicGetIpeLumaShapeINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicGetBestIpeLumaDistortionINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicGetBestIpeChromaDistortionINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicGetPackedIpeLumaModesINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicGetIpeChromaModeINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicGetPackedSkcLumaCountThresholdINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicGetPackedSkcLumaSumThresholdINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpSubgroupAvcSicGetInterRawSadsINTEL => (
        Symbol("@exclude"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "Payload"),
        ],
    ),
    OpRayQueryGetRayTMinKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
        ],
    ),
    OpRayQueryGetRayFlagsKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
        ],
    ),
    OpRayQueryGetIntersectionTKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
    OpRayQueryGetIntersectionInstanceCustomIndexKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
    OpRayQueryGetIntersectionInstanceIdKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
    OpRayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
    OpRayQueryGetIntersectionGeometryIndexKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
    OpRayQueryGetIntersectionPrimitiveIndexKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
    OpRayQueryGetIntersectionBarycentricsKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
    OpRayQueryGetIntersectionFrontFaceKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
    OpRayQueryGetIntersectionCandidateAABBOpaqueKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
        ],
    ),
    OpRayQueryGetIntersectionObjectRayDirectionKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
    OpRayQueryGetIntersectionObjectRayOriginKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
    OpRayQueryGetWorldRayDirectionKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
        ],
    ),
    OpRayQueryGetWorldRayOriginKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
        ],
    ),
    OpRayQueryGetIntersectionObjectToWorldKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
    OpRayQueryGetIntersectionWorldToObjectKHR => (
        Symbol("Reserved"),
        [
            (kind = "IdResultType",),
            (kind = "IdResult",),
            (kind = "IdRef", name = "RayQuery"),
            (kind = "IdRef", name = "Intersection"),
        ],
    ),
)

const class_printing = Dict(
    Symbol("@exclude")               => "",
    Symbol("Miscellaneous")          => "Miscellaneous Instructions",
    Symbol("Debug")                  => "Debug Instructions",
    Symbol("Annotation")             => "Annotation Instructions",
    Symbol("Extension")              => "Extension Instructions",
    Symbol("Mode-Setting")           => "Mode-Setting Instructions",
    Symbol("Type-Declaration")       => "Type-Declaration Instructions",
    Symbol("Constant-Creation")      => "Constant-Creation Instructions",
    Symbol("Memory")                 => "Memory Instructions",
    Symbol("Function")               => "Function Instructions",
    Symbol("Image")                  => "Image Instructions",
    Symbol("Conversion")             => "Conversion Instructions",
    Symbol("Composite")              => "Composite Instructions",
    Symbol("Arithmetic")             => "Arithmetic Instructions",
    Symbol("Bit")                    => "Bit Instructions",
    Symbol("Relational_and_Logical") => "Relational and Logical Instructions",
    Symbol("Derivative")             => "Derivative Instructions",
    Symbol("Control-Flow")           => "Control-Flow Instructions",
    Symbol("Atomic")                 => "Atomic Instructions",
    Symbol("Primitive")              => "Primitive Instructions",
    Symbol("Barrier")                => "Barrier Instructions",
    Symbol("Group")                  => "Group and Subgroup Instructions",
    Symbol("Device-Side_Enqueue")    => "Device-Side Enqueue Instructions",
    Symbol("Pipe")                   => "Pipe Instructions",
    Symbol("Non-Uniform")            => "Non-Uniform Instructions",
    Symbol("Reserved")               => "Reserved Instructions",
)

const kind_to_category = Dict(
    "ImageOperands"                     => "BitEnum",
    "FPFastMathMode"                    => "BitEnum",
    "SelectionControl"                  => "BitEnum",
    "LoopControl"                       => "BitEnum",
    "FunctionControl"                   => "BitEnum",
    "MemorySemantics"                   => "BitEnum",
    "MemoryAccess"                      => "BitEnum",
    "KernelProfilingInfo"               => "BitEnum",
    "RayFlags"                          => "BitEnum",
    "SourceLanguage"                    => "ValueEnum",
    "ExecutionModel"                    => "ValueEnum",
    "AddressingModel"                   => "ValueEnum",
    "MemoryModel"                       => "ValueEnum",
    "ExecutionMode"                     => "ValueEnum",
    "StorageClass"                      => "ValueEnum",
    "Dim"                               => "ValueEnum",
    "SamplerAddressingMode"             => "ValueEnum",
    "SamplerFilterMode"                 => "ValueEnum",
    "ImageFormat"                       => "ValueEnum",
    "ImageChannelOrder"                 => "ValueEnum",
    "ImageChannelDataType"              => "ValueEnum",
    "FPRoundingMode"                    => "ValueEnum",
    "LinkageType"                       => "ValueEnum",
    "AccessQualifier"                   => "ValueEnum",
    "FunctionParameterAttribute"        => "ValueEnum",
    "Decoration"                        => "ValueEnum",
    "BuiltIn"                           => "ValueEnum",
    "Scope"                             => "ValueEnum",
    "GroupOperation"                    => "ValueEnum",
    "KernelEnqueueFlags"                => "ValueEnum",
    "Capability"                        => "ValueEnum",
    "RayQueryIntersection"              => "ValueEnum",
    "RayQueryCommittedIntersectionType" => "ValueEnum",
    "RayQueryCandidateIntersectionType" => "ValueEnum",
    "IdResultType"                      => "Id",
    "IdResult"                          => "Id",
    "IdMemorySemantics"                 => "Id",
    "IdScope"                           => "Id",
    "IdRef"                             => "Id",
    "LiteralInteger"                    => "Literal",
    "LiteralString"                     => "Literal",
    "LiteralContextDependentNumber"     => "Literal",
    "LiteralExtInstInteger"             => "Literal",
    "LiteralSpecConstantOpInteger"      => "Literal",
    "PairLiteralIntegerIdRef"           => "Composite",
    "PairIdRefLiteralInteger"           => "Composite",
    "PairIdRefIdRef"                    => "Composite",
)
