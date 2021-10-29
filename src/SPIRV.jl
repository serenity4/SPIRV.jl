module SPIRV

using CEnum
using MLStyle
using UnPack
using Graphs
using Reexport
using Dictionaries
using AutoHashEquals
using Accessors

const Optional{T} = Union{Nothing,T}

import Base: write, show, showerror, ==

const magic_number = 0x07230203

# generated SPIR-V wrapper
include("generated/enums.jl")
include("generated/instructions.jl")

include("utils.jl")
include("ssa.jl")
include("parse.jl")
include("disassemble.jl")
include("functions.jl")
include("spir_types.jl")
include("ir.jl")
include("assemble.jl")

# include("StructuredCFG/StructuredCFG.jl")
# @reexport using .StructuredCFG

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
        ID,
        SSAValue,
        Metadata,
        SSADict,
        @inst
end
