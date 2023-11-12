@cenum OpCodeGLSL::UInt32 begin
  OpGLSLRound                 = 1
  OpGLSLRoundEven             = 2
  OpGLSLTrunc                 = 3
  OpGLSLFAbs                  = 4
  OpGLSLSAbs                  = 5
  OpGLSLFSign                 = 6
  OpGLSLSSign                 = 7
  OpGLSLFloor                 = 8
  OpGLSLCeil                  = 9
  OpGLSLFract                 = 10
  OpGLSLRadians               = 11
  OpGLSLDegrees               = 12
  OpGLSLSin                   = 13
  OpGLSLCos                   = 14
  OpGLSLTan                   = 15
  OpGLSLAsin                  = 16
  OpGLSLAcos                  = 17
  OpGLSLAtan                  = 18
  OpGLSLSinh                  = 19
  OpGLSLCosh                  = 20
  OpGLSLTanh                  = 21
  OpGLSLAsinh                 = 22
  OpGLSLAcosh                 = 23
  OpGLSLAtanh                 = 24
  OpGLSLAtan2                 = 25
  OpGLSLPow                   = 26
  OpGLSLExp                   = 27
  OpGLSLLog                   = 28
  OpGLSLExp2                  = 29
  OpGLSLLog2                  = 30
  OpGLSLSqrt                  = 31
  OpGLSLInverseSqrt           = 32
  OpGLSLDeterminant           = 33
  OpGLSLMatrixInverse         = 34
  OpGLSLModf                  = 35
  OpGLSLModfStruct            = 36
  OpGLSLFMin                  = 37
  OpGLSLUMin                  = 38
  OpGLSLSMin                  = 39
  OpGLSLFMax                  = 40
  OpGLSLUMax                  = 41
  OpGLSLSMax                  = 42
  OpGLSLFClamp                = 43
  OpGLSLUClamp                = 44
  OpGLSLSClamp                = 45
  OpGLSLFMix                  = 46
  OpGLSLIMix                  = 47
  OpGLSLStep                  = 48
  OpGLSLSmoothStep            = 49
  OpGLSLFma                   = 50
  OpGLSLFrexp                 = 51
  OpGLSLFrexpStruct           = 52
  OpGLSLLdexp                 = 53
  OpGLSLPackSnorm4x8          = 54
  OpGLSLPackUnorm4x8          = 55
  OpGLSLPackSnorm2x16         = 56
  OpGLSLPackUnorm2x16         = 57
  OpGLSLPackHalf2x16          = 58
  OpGLSLPackDouble2x32        = 59
  OpGLSLUnpackSnorm2x16       = 60
  OpGLSLUnpackUnorm2x16       = 61
  OpGLSLUnpackHalf2x16        = 62
  OpGLSLUnpackSnorm4x8        = 63
  OpGLSLUnpackUnorm4x8        = 64
  OpGLSLUnpackDouble2x32      = 65
  OpGLSLLength                = 66
  OpGLSLDistance              = 67
  OpGLSLCross                 = 68
  OpGLSLNormalize             = 69
  OpGLSLFaceForward           = 70
  OpGLSLReflect               = 71
  OpGLSLRefract               = 72
  OpGLSLFindILsb              = 73
  OpGLSLFindSMsb              = 74
  OpGLSLFindUMsb              = 75
  OpGLSLInterpolateAtCentroid = 76
  OpGLSLInterpolateAtSample   = 77
  OpGLSLInterpolateAtOffset   = 78
  OpGLSLNMin                  = 79
  OpGLSLNMax                  = 80
  OpGLSLNClamp                = 81
end

const instruction_infos_glsl = Dict{OpCodeGLSL,InstructionInfo}([
  OpGLSLRound => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLRoundEven =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLTrunc => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLFAbs => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLSAbs => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLFSign => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLSSign => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLFloor => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLCeil => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLFract => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLRadians =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'degrees'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLDegrees =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'radians'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLSin => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLCos => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLTan => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLAsin => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLAcos => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLAtan =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'y_over_x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLSinh => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLCosh => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLTanh => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLAsinh => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLAcosh => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLAtanh => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLAtan2 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'y'", nothing), OperandInfo(IdRef, "'x'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLPow => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLExp => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLLog => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLExp2 => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLLog2 => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLSqrt => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLInverseSqrt =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLDeterminant =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLMatrixInverse =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLModf => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'i'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLModfStruct =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLFMin => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLUMin => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLSMin => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLFMax => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLUMax => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLSMax => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLFClamp => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'minVal'", nothing), OperandInfo(IdRef, "'maxVal'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLUClamp => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'minVal'", nothing), OperandInfo(IdRef, "'maxVal'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLSClamp => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'minVal'", nothing), OperandInfo(IdRef, "'maxVal'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLFMix => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing), OperandInfo(IdRef, "'a'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLIMix => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing), OperandInfo(IdRef, "'a'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLStep => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'edge'", nothing), OperandInfo(IdRef, "'x'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLSmoothStep => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'edge0'", nothing), OperandInfo(IdRef, "'edge1'", nothing), OperandInfo(IdRef, "'x'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLFma => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'a'", nothing), OperandInfo(IdRef, "'b'", nothing), OperandInfo(IdRef, "'c'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLFrexp => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'exp'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLFrexpStruct =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLLdexp => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'exp'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLPackSnorm4x8 =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'v'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLPackUnorm4x8 =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'v'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLPackSnorm2x16 =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'v'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLPackUnorm2x16 =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'v'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLPackHalf2x16 =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'v'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLPackDouble2x32 =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'v'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFloat64])),
  OpGLSLUnpackSnorm2x16 =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'p'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLUnpackUnorm2x16 =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'p'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLUnpackHalf2x16 =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'v'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLUnpackSnorm4x8 =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'p'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLUnpackUnorm4x8 =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'p'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLUnpackDouble2x32 =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'v'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityFloat64])),
  OpGLSLLength => InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLDistance => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'p0'", nothing), OperandInfo(IdRef, "'p1'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLCross => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLNormalize =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'x'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLFaceForward => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'N'", nothing), OperandInfo(IdRef, "'I'", nothing), OperandInfo(IdRef, "'Nref'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLReflect => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'I'", nothing), OperandInfo(IdRef, "'N'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLRefract => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'I'", nothing), OperandInfo(IdRef, "'N'", nothing), OperandInfo(IdRef, "'eta'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLFindILsb =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'Value'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLFindSMsb =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'Value'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLFindUMsb =>
    InstructionInfo(nothing, [OperandInfo(IdRef, "'Value'", nothing)], RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing)),
  OpGLSLInterpolateAtCentroid => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'interpolant'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityInterpolationFunction]),
  ),
  OpGLSLInterpolateAtSample => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'interpolant'", nothing), OperandInfo(IdRef, "'sample'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityInterpolationFunction]),
  ),
  OpGLSLInterpolateAtOffset => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'interpolant'", nothing), OperandInfo(IdRef, "'offset'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, [CapabilityInterpolationFunction]),
  ),
  OpGLSLNMin => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLNMax => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
  OpGLSLNClamp => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'minVal'", nothing), OperandInfo(IdRef, "'maxVal'", nothing)],
    RequiredSupport(VersionRange(v"0.0.0", v"∞"), nothing, nothing),
  ),
])
