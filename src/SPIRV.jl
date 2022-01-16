module SPIRV

using CEnum
using MLStyle
using Graphs
using Reexport
using Dictionaries
using AutoHashEquals
using Accessors

using CodeInfoTools
using Core.Compiler: CodeInfo, IRCode, compute_basic_blocks, uncompressed_ir, MethodInstance, InferenceResult, typeinf, InferenceState, retrieve_code_info, lock_mi_inference, AbstractInterpreter, OptimizationParams, InferenceParams, get_world_counter, CodeInstance, WorldView, WorldRange, OverlayMethodTable
using Base.Experimental: @overlay, @MethodTable

import SPIRV_Tools_jll
const spirv_val = SPIRV_Tools_jll.spirv_val(identity)

const Optional{T} = Union{Nothing,T}

const magic_number = 0x07230203
const generator_magic_number = 0x12349876

# generated SPIR-V wrapper
include("generated/enums.jl")
include("grammar.jl")
include("generated/enum_infos.jl")
include("generated/instructions.jl")
include("generated/extinsts.jl")

include("utils.jl")
include("bijection.jl")
include("ssa.jl")
include("instructions.jl")
include("spir_types.jl")
include("parse.jl")
include("disassemble.jl")
include("functions.jl")
include("ir.jl")
include("cfg.jl")
include("assemble.jl")
include("validate.jl")
include("alignment.jl")
include("requirements.jl")

include("frontend/ci_cache.jl")
include("frontend/method_table.jl")
include("frontend/intrinsics.jl")
include("frontend/array.jl")
include("frontend/intrinsics_glsl.jl")
include("frontend/vulkan.jl")
include("frontend/interpreter.jl")
include("frontend/deltagraph.jl")
include("frontend/cfg.jl")
include("frontend/reflection.jl")
include("frontend/restructuring.jl")
include("frontend/compile.jl")
include("frontend/codegen.jl")
include("frontend/shader.jl")

export
        # parse
        PhysicalInstruction, PhysicalModule,
        Instruction,

        # disassemble
        disassemble,

        # assemble
        assemble,

        # SPIR-V types
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

        # IR
        IR,
        SSAValue,
        Metadata,
        SSADict,
        @inst,
        FeatureRequirements,
        FeatureSupport, AllSupported, SupportedFeatures,

        # CFG
        control_flow_graph,

        # validation
        validate,
        validate_shader,

        # Front-end
        CFG,
        @cfg,
        is_single_entry_single_exit,
        is_tail_structured,
        is_single_node,
        rem_head_recursion!,
        compact_reducible_bbs!,
        compact_structured_branches!,
        merge_mutually_recursive!,
        merge_return_blocks,
        compact,
        sinks,
        sources,

        replace_code!,
        infer,

        verify,
        compile,
        make_shader,
        ShaderInterface,
        AlignmentStrategy, VulkanAlignment,
        @compile,
        invalidate_all!,
        SPIRVInterpreter,
        VULKAN_METHOD_TABLE, INTRINSICS_GLSL_METHOD_TABLE, INTRINSICS_METHOD_TABLE,
        DEFAULT_CI_CACHE, VULKAN_CI_CACHE,

        # SPIR-V array/vector types
        GenericVector,
        ScalarVector, SVec,
        ScalarMatrix, MVec,
        Pointer

end
