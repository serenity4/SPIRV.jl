module SPIRV

using CompileTraces
using CEnum
using CEnum: Cenum
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
using StyledStrings
import Serialization: serialize, deserialize
using StaticArrays: StaticArrays, SVector, SMatrix
@reexport using ResultTypes: iserror, unwrap, unwrap_error
using ResultTypes: @try

using Core.Compiler: CodeInfo, IRCode, MethodInstance, InferenceResult, InferenceState,
  retrieve_code_info, lock_mi_inference, AbstractInterpreter, OptimizationParams, InferenceParams, get_world_counter, CodeInstance, WorldView,
  WorldRange, OverlayMethodTable, cached_return_type
const CC = Core.Compiler
using Base.ScopedValues
using Base.Experimental: @overlay, @consistent_overlay, @MethodTable
using Base.IRShow: LineInfoNode
using Base: Fix1, Fix2,
            IEEEFloat,
            BitSigned, BitSigned_types,
            BitUnsigned, BitUnsigned_types,
            BitInteger, BitInteger_types

const IEEEFloat_types = (Float16, Float32, Float64)
const SmallFloat = Union{Float16,Float32}

import LinearAlgebra: dot, cross, norm, normalize

import SPIRV_Tools_jll
const spirv_val = SPIRV_Tools_jll.spirv_val()
const spirv_opt = SPIRV_Tools_jll.spirv_opt()

const Optional{T} = Union{Nothing,T}

struct LiteralType{T} end
Base.:(*)(x, ::Type{LiteralType{T}}) where {T} = T(x)
Base.getindex(::Type{LiteralType{T}}, values...) where {T} = getindex(T, values...)

"""
    x*I
    (x)I

Converts an input `x` to an `Int32` when `I` is right-multiplied with it.
"""
const I = LiteralType{Int32} # unexported to avoid clashes with `I` for the identity matrix.
"""
    x*U
    (x)U

Converts an input `x` to an `UInt32` when `U` is right-multiplied with it.
"""
const U = LiteralType{UInt32}
"""
    x*F
    (x)F

Converts an input `x` to a `Float32` when `F` is right-multiplied with it.
"""
const F = LiteralType{Float32}
"32-bit floating-point representation of `π`."
const πF = (π)F

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

include("frontend/method_table.jl")
include("frontend/types/mutable.jl")
include("frontend/types/pointer.jl")
include("frontend/types/arrays.jl")
include("frontend/types/image.jl")
include("frontend/utility.jl")
include("frontend/intrinsics.jl")
include("frontend/intrinsics_glsl.jl")
include("frontend/overlays.jl")
include("frontend/MathFunctions.jl")
include("layouts.jl")
include("serialization.jl")
include("frontend/interpreter.jl")
include("frontend/target.jl")
include("frontend/compile.jl")
include("frontend/codegen.jl")
include("frontend/shader/options.jl")
include("frontend/shader/interface.jl")
include("frontend/shader/docs.jl")
include("frontend/shader/source.jl")
include("frontend/shader/cache.jl")
include("frontend/shader/shader.jl")
include("frontend/shader/api.jl")
include("optimize.jl")

include("analysis/call_tree.jl")
include("analysis/structural_analysis.jl")
include("analysis/abstract_interpretation.jl")
include("analysis/data_flow.jl")
include("passes.jl")
include("analysis/passes.jl")
include("analysis/restructuring.jl")
include("frontend/shader/analysis.jl")

include("spirv_dsl.jl")
include("precompile.jl")

export
  MathFunctions,

  # Utilities.
  ## Conversion character literals.
  U, F,
  πF,

  @for,

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
  check_compiler_feature_requirements,

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
  ShaderInfo, ShaderSource,
  specialize_shader,
  ShaderCompilationCache,
  @vertex,
  @geometry,
  @tessellation_control,
  @tessellation_evaluation,
  @fragment,
  @compute,
  @ray_generation,
  @intersection,
  @closest_hit,
  @any_hit,
  @miss,
  @callable,
  @task,
  @mesh,

  # Layouts.
  LayoutStrategy, NoPadding, NativeLayout, LayoutInfo, ExplicitLayout, VulkanAlignment, VulkanLayout, ShaderLayout, TypeMetadata,
  alignment, dataoffset, datasize, stride,
  serialize, deserialize,
  serialize!, deserialize!,

  # SPIR-V array/vector/pointer/image types.
  Mutable, Mut,
  Vec,
  Vec2, Vec3, Vec4,
  Vec2U, Vec3U, Vec4U,
  Vec2I, Vec3I, Vec4I,
  Arr,
  Mat, Mat2, Mat3, Mat4,
  Mat23, Mat32, Mat24, Mat42, Mat34, Mat43,
  MatU, Mat2U, Mat3U, Mat4U,
  Mat23U, Mat32U, Mat24U, Mat42U, Mat34U, Mat43U,
  MatI, Mat2I, Mat3I, Mat4I,
  Mat23I, Mat32I, Mat24I, Mat42I, Mat34I, Mat43I,
  @vec, @arr, @mat,
  @load, @store,
  Image, image_type, Sampler,
  SampledImage,
  DPdx, DPdy, Fwidth,
  DPdxCoarse, DPdyCoarse, FwidthCoarse,
  DPdxFine, DPdyFine, FwidthFine,
  combine

end
