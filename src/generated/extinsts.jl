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
  OpGLSLRound => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLRoundEven => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLTrunc => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFAbs => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLSAbs => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFSign => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLSSign => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFloor => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLCeil => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFract => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLRadians => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'degrees'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLDegrees => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'radians'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLSin => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLCos => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLTan => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLAsin => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLAcos => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLAtan => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'y_over_x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLSinh => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLCosh => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLTanh => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLAsinh => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLAcosh => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLAtanh => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLAtan2 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'y'", nothing), OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLPow => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLExp => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLLog => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLExp2 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLLog2 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLSqrt => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLInverseSqrt => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLDeterminant => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLMatrixInverse => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLModf => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'i'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLModfStruct => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFMin => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLUMin => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLSMin => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFMax => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLUMax => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLSMax => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFClamp => InstructionInfo(
    nothing,
    [
      OperandInfo(IdRef, "'x'", nothing),
      OperandInfo(IdRef, "'minVal'", nothing),
      OperandInfo(IdRef, "'maxVal'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLUClamp => InstructionInfo(
    nothing,
    [
      OperandInfo(IdRef, "'x'", nothing),
      OperandInfo(IdRef, "'minVal'", nothing),
      OperandInfo(IdRef, "'maxVal'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLSClamp => InstructionInfo(
    nothing,
    [
      OperandInfo(IdRef, "'x'", nothing),
      OperandInfo(IdRef, "'minVal'", nothing),
      OperandInfo(IdRef, "'maxVal'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFMix => InstructionInfo(
    nothing,
    [
      OperandInfo(IdRef, "'x'", nothing),
      OperandInfo(IdRef, "'y'", nothing),
      OperandInfo(IdRef, "'a'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLIMix => InstructionInfo(
    nothing,
    [
      OperandInfo(IdRef, "'x'", nothing),
      OperandInfo(IdRef, "'y'", nothing),
      OperandInfo(IdRef, "'a'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLStep => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'edge'", nothing), OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLSmoothStep => InstructionInfo(
    nothing,
    [
      OperandInfo(IdRef, "'edge0'", nothing),
      OperandInfo(IdRef, "'edge1'", nothing),
      OperandInfo(IdRef, "'x'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFma => InstructionInfo(
    nothing,
    [
      OperandInfo(IdRef, "'a'", nothing),
      OperandInfo(IdRef, "'b'", nothing),
      OperandInfo(IdRef, "'c'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFrexp => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'exp'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFrexpStruct => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLLdexp => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'exp'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLPackSnorm4x8 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'v'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLPackUnorm4x8 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'v'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLPackSnorm2x16 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'v'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLPackUnorm2x16 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'v'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLPackHalf2x16 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'v'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLPackDouble2x32 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'v'", nothing)],
    [CapabilityFloat64],
    [],
    v"0.0.0",
  ),
  OpGLSLUnpackSnorm2x16 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'p'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLUnpackUnorm2x16 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'p'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLUnpackHalf2x16 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'v'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLUnpackSnorm4x8 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'p'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLUnpackUnorm4x8 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'p'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLUnpackDouble2x32 => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'v'", nothing)],
    [CapabilityFloat64],
    [],
    v"0.0.0",
  ),
  OpGLSLLength => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLDistance => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'p0'", nothing), OperandInfo(IdRef, "'p1'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLCross => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLNormalize => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFaceForward => InstructionInfo(
    nothing,
    [
      OperandInfo(IdRef, "'N'", nothing),
      OperandInfo(IdRef, "'I'", nothing),
      OperandInfo(IdRef, "'Nref'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLReflect => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'I'", nothing), OperandInfo(IdRef, "'N'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLRefract => InstructionInfo(
    nothing,
    [
      OperandInfo(IdRef, "'I'", nothing),
      OperandInfo(IdRef, "'N'", nothing),
      OperandInfo(IdRef, "'eta'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFindILsb => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'Value'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFindSMsb => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'Value'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLFindUMsb => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'Value'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLInterpolateAtCentroid => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'interpolant'", nothing)],
    [CapabilityInterpolationFunction],
    [],
    v"0.0.0",
  ),
  OpGLSLInterpolateAtSample => InstructionInfo(
    nothing,
    [
      OperandInfo(IdRef, "'interpolant'", nothing),
      OperandInfo(IdRef, "'sample'", nothing),
    ],
    [CapabilityInterpolationFunction],
    [],
    v"0.0.0",
  ),
  OpGLSLInterpolateAtOffset => InstructionInfo(
    nothing,
    [
      OperandInfo(IdRef, "'interpolant'", nothing),
      OperandInfo(IdRef, "'offset'", nothing),
    ],
    [CapabilityInterpolationFunction],
    [],
    v"0.0.0",
  ),
  OpGLSLNMin => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLNMax => InstructionInfo(
    nothing,
    [OperandInfo(IdRef, "'x'", nothing), OperandInfo(IdRef, "'y'", nothing)],
    [],
    [],
    v"0.0.0",
  ),
  OpGLSLNClamp => InstructionInfo(
    nothing,
    [
      OperandInfo(IdRef, "'x'", nothing),
      OperandInfo(IdRef, "'minVal'", nothing),
      OperandInfo(IdRef, "'maxVal'", nothing),
    ],
    [],
    [],
    v"0.0.0",
  ),
])
