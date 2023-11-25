module SPIRV

using CompileTraces
using CEnum
using MLStyle
using Graphs
using Reexport
using Dictionaries
using StructEquality
using Accessors
using ResultTypes: Result
using AbstractTrees
using AbstractTrees: parent
using SwapStreams: SwapStream
using BitMasks
using UUIDs: UUID, uuid1
using SnoopPrecompile
using ForwardMethods
using Random
import Serialization: serialize, deserialize
@reexport using ResultTypes: iserror, unwrap, unwrap_error

using Core.Compiler: CodeInfo, IRCode, compute_basic_blocks, uncompressed_ir, MethodInstance, InferenceResult, typeinf, InferenceState,
  retrieve_code_info, lock_mi_inference, AbstractInterpreter, OptimizationParams, InferenceParams, get_world_counter, CodeInstance, WorldView,
  WorldRange, OverlayMethodTable
const CC = Core.Compiler
using Base.Experimental: @overlay, @MethodTable
using Base: Fix1, Fix2,
            IEEEFloat,
            BitSigned, BitSigned_types,
            BitUnsigned, BitUnsigned_types,
            BitInteger, BitInteger_types

const IEEEFloat_types = (Float16, Float32, Float64)
const SmallFloat = Union{Float16,Float32}

import LinearAlgebra: dot, cross

import SPIRV_Tools_jll
const spirv_val = SPIRV_Tools_jll.spirv_val()

const Optional{T} = Union{Nothing,T}

struct LiteralType{T} end
Base.:(*)(x, ::Type{LiteralType{T}}) where {T} = T(x)

const U = LiteralType{UInt32}
const F = LiteralType{Float32}

const MAGIC_NUMBER = 0x07230203
const GENERATOR_MAGIC_NUMBER = 0x12349876
const SPIRV_VERSION = v"1.6"

# generated SPIR-V wrapper
include("generated/enums.jl")
include("grammar.jl")
include("generated/enum_infos.jl")
include("generated/instructions.jl")
include("generated/extinsts.jl")

"""
Enumerated value representing the type of an instruction.
See https://registry.khronos.org/SPIR-V/specs/unified1/SPIRV.html#_instructions_3 for a list of SPIR-V opcodes (excluding extended instruction sets).
"""
OpCode

include("utils.jl")
include("bijection.jl")
include("cursor.jl")
include("result.jl")
include("instructions.jl")
include("spir_types.jl")
include("expressions.jl")
include("parse.jl")
include("functions.jl")
include("diff.jl")
include("annotated_module.jl")
include("disassemble.jl")
include("globals.jl")
include("metadata.jl")
include("debug.jl")
include("entry_point.jl")
include("ir.jl")
include("assemble.jl")
include("validate.jl")
include("requirements.jl")

include("analysis/deltagraph.jl")
include("analysis/control_flow.jl")

include("frontend/ci_cache.jl")
include("frontend/method_table.jl")
include("frontend/overlay.jl")
include("frontend/types/abstractarray.jl")
include("frontend/types/pointer.jl")
include("frontend/types/vector.jl")
include("frontend/types/matrix.jl")
include("frontend/types/array.jl")
include("frontend/types/image.jl")
include("frontend/types/broadcast.jl")
include("frontend/types/base/ranges.jl")
include("frontend/intrinsics.jl")
include("frontend/intrinsics_glsl.jl")
include("frontend/MathFunctions.jl")
include("layouts.jl")
include("serialization.jl")
include("frontend/interpreter.jl")
include("frontend/ci_passes.jl")
include("frontend/target.jl")
include("frontend/compile.jl")
include("frontend/codegen.jl")
include("frontend/shader/options.jl")
include("frontend/shader/interface.jl")
include("frontend/shader/shader.jl")

include("analysis/call_tree.jl")
include("analysis/structural_analysis.jl")
include("analysis/abstract_interpretation.jl")
include("analysis/data_flow.jl")
include("passes.jl")
include("analysis/passes.jl")
include("analysis/restructuring.jl")
include("frontend/shader/analysis.jl")

include("frontend/shader/source.jl")
include("frontend/shader/cache.jl")
include("frontend/shader/api.jl")

include("spirv_dsl.jl")
include("precompile.jl")

export
  MathFunctions,

  # Conversion character literals.
  U, F,

  # Parsing, assembly, disassembly.
  PhysicalInstruction, PhysicalModule,
  Instruction, InstructionCursor,
  disassemble,
  assemble,

  # SPIR-V types.
  TypeMap,
  SPIRType,
  VoidType,
  ScalarType, BooleanType, IntegerType, FloatType,
  VectorType, MatrixType,
  ImageType,
  SamplerType, SampledImageType,
  ArrayType,
  OpaqueType,
  StructType,
  PointerType,
  spir_type,

  # IR.
  annotate, AnnotatedModule,
  IR,
  ResultID,
  ModuleMetadata,
  ResultDict,
  @inst, @block, @spv_ir, @spv_module,

  # Features.
  FeatureRequirements,
  FeatureSupport, AllSupported, SupportedFeatures,

  # Annotations.
  Decorations, has_decoration, decorate!, Metadata, decorations,
  set_name!,

  # Control-flow.
  DeltaGraph, compact,
  ControlFlowGraph,
  control_flow_graph,
  is_reducible,
  is_structured,
  ControlTree, ControlNode, region_type,
  is_single_entry_single_exit,
  sinks,
  sources,
  DominatorTree, immediate_postdominators, immediate_dominator,

  # Analysis.
  dependent_functions,

  # Validation.
  validate,
  validate_shader,

  # Compilation.
  SPIRVTarget,
  @target,
  compile,
  SPIRVInterpreter,
  invalidate_all!,
  @compile,
  INTRINSICS_GLSL_METHOD_TABLE, INTRINSICS_METHOD_TABLE,
  DEFAULT_CI_CACHE,

  # Shader.
  ShaderInterface, Shader,
  ShaderExecutionOptions, InvalidExecutionOptions,
  CommonExecutionOptions,
  FragmentExecutionOptions,
  ComputeExecutionOptions,
  GeometryExecutionOptions,
  TessellationExecutionOptions,
  MeshExecutionOptions,
  ShaderSpec, ShaderInfo, ShaderSource,
  ShaderCompilationCache,

  # Layouts.
  LayoutStrategy, NoPadding, NativeLayout, LayoutInfo, ExplicitLayout, VulkanAlignment, VulkanLayout, ShaderLayout, TypeMetadata,
  alignment, dataoffset, datasize, stride,
  serialize, deserialize,

  # SPIR-V array/vector/pointer/image types.
  Vec, Vec2, Vec3, Vec4,
  Mat, Mat2, Mat3, Mat4, @mat,
  Arr,
  Pointer, @load, @store,
  Image, image_type, Sampler,
  SampledImage,
  combine

end
