module SPIRV

using CEnum
using MLStyle
using Graphs
using Reexport
using Dictionaries
using AutoHashEquals
using Accessors

import SPIRV_Tools_jll
const spirv_val = SPIRV_Tools_jll.spirv_val(identity)

const Optional{T} = Union{Nothing,T}

import Base: write, show, showerror, ==

const magic_number = 0x07230203

# generated SPIR-V wrapper
include("generated/enums.jl")
include("generated/instructions.jl")

include("utils.jl")
include("bijection.jl")
include("ssa.jl")
include("parse.jl")
include("disassemble.jl")
include("spir_types.jl")
include("functions.jl")
include("ir.jl")
include("cfg.jl")
include("assemble.jl")
include("validate.jl")

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

        # CFG
        control_flow_graph,

        # validation
        validate

include("Spells/Spells.jl")
@reexport using .Spells

end
