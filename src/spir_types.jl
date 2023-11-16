abstract type SPIRType end

struct VoidType <: SPIRType end

abstract type ScalarType <: SPIRType end

struct IntegerType <: ScalarType
  width::Int
  signed::Bool
end

function IntegerType(inst::Instruction)
  (width, signed) = inst.arguments
  IntegerType(width, signed)
end

struct FloatType <: ScalarType
  width::Int
end

FloatType(inst::Instruction) = FloatType(inst.arguments[])

struct BooleanType <: ScalarType end

struct VectorType <: SPIRType
  eltype::ScalarType
  n::Int
end

function VectorType(inst::Instruction, eltype::ScalarType)
  VectorType(eltype, last(inst.arguments))
end

struct MatrixType <: SPIRType
  eltype::VectorType
  n::Int
  is_column_major::Bool
end
MatrixType(eltype::VectorType, n::Integer) = MatrixType(eltype, n, true)

"Return either a column `VectorType` or a row `VectorType` for column-major and row-major layouts respectively."
eltype_major(mat::MatrixType) = mat.is_column_major ? mat.eltype : VectorType(mat.eltype.eltype, mat.n)

function MatrixType(inst::Instruction, eltype::VectorType)
  MatrixType(eltype, last(inst.arguments))
end

@struct_hash_equal struct ImageType <: SPIRType
  sampled_type::SPIRType
  dim::Dim
  depth::Optional{Bool}
  arrayed::Bool
  multisampled::Bool
  sampled::Optional{Bool}
  format::ImageFormat
  access_qualifier::Optional{AccessQualifier}
end

function ImageType(inst::Instruction, sampled_type::SPIRType)
  @assert inst.opcode == OpTypeImage
  (sampled_type_id, dim, depth, arrayed, multisampled, sampled, format) = inst.arguments[1:7]
  access_qualifier = length(inst.arguments) > 7 ? last(inst.arguments) : nothing
  sampled = sampled == 0 ? nothing : Bool(2 - sampled)
  if depth == 2
    depth = nothing
  end
  ImageType(sampled_type, dim, depth, arrayed, multisampled, sampled, format, access_qualifier)
end

struct SamplerType <: SPIRType end

struct SampledImageType <: SPIRType
  image_type::ImageType
end

@struct_hash_equal struct Constant
  value::Any
  type::SPIRType
  is_spec_const::Bool
end
function Constant(value::T) where {T}
  isprimitivetype(T) && return Constant(value, spir_type(T))
  isa(value, QuoteNode) && return Constant(value.value)
  # Disallow composite types, as we don't want to generate new `StructTypes`.
  error("A type must be provided for the constant $value")
end
Constant(value, type) = Constant(value, type, false)
Constant(node::QuoteNode, type) = Constant(node.value, type)

struct ArrayType <: SPIRType
  eltype::SPIRType
  "Constant expression giving the size of the array, if determined at compile-time. SPIR-V runtime arrays will have this field set to `nothing`."
  size::Optional{Constant}
end

struct OpaqueType <: SPIRType
  name::Symbol
end

const DecorationData = Dictionary{Decoration,Vector{Any}}

"""
SPIR-V aggregate type.

Equality is defined in terms of identity, since different aggregate
types have in principle different semantics.
"""
struct StructType <: SPIRType
  id::UUID
  members::Vector{SPIRType}
end
StructType(members) = StructType(uuid1(), members)

Base.:(≈)(x::SPIRType, y::SPIRType) = typeof(x) == typeof(y) && x == y
Base.:(≈)(x::StructType, y::StructType) = length(x.members) == length(y.members) && all(subx ≈ suby for (subx, suby) in zip(x.members, y.members))
Base.:(≈)(x::ArrayType, y::ArrayType) = x.eltype ≈ y.eltype && x.size == y.size
Base.:(≈)(x::ImageType, y::ImageType) = x.sampled_type ≈ y.sampled_type && x.dim == y.dim && x.depth === y.depth && x.arrayed == y.arrayed && x.multisampled == y.multisampled && x.sampled === y.sampled && x.format == y.format && x.access_qualifier === y.access_qualifier

struct PointerType <: SPIRType
  storage_class::StorageClass
  type::SPIRType
end

PointerType(inst::Instruction, type::SPIRType) = PointerType(first(inst.arguments), type)
Base.:(≈)(x::PointerType, y::PointerType) = x.storage_class == y.storage_class && x.type ≈ y.type

@struct_hash_equal struct FunctionType <: SPIRType
  rettype::SPIRType
  argtypes::Vector{SPIRType}
end

function Base.parse(::Type{SPIRType}, inst::Instruction, types::BijectiveMapping, constants::BijectiveMapping)
  @match op = inst.opcode begin
    &OpTypeVoid => VoidType()
    &OpTypeInt => IntegerType(inst)
    &OpTypeFloat => FloatType(inst)
    &OpTypeBool => BooleanType()
    &OpTypeVector => VectorType(inst, types[inst.arguments[1]::ResultID])
    &OpTypeMatrix => MatrixType(inst, types[inst.arguments[1]::ResultID])
    &OpTypeImage => ImageType(inst, types[inst.arguments[1]::ResultID])
    &OpTypeSampler => SamplerType()
    &OpTypeSampledImage => SampledImageType(types[inst.arguments[1]::ResultID])
    &OpTypeArray => ArrayType(types[inst.arguments[1]::ResultID], constants[inst.arguments[end]::ResultID])
    &OpTypeRuntimeArray => ArrayType(types[inst.arguments[1]::ResultID], nothing)
    &OpTypeStruct => StructType([types[id] for id in inst.arguments])
    &OpTypeOpaque => OpaqueType(Symbol(inst.arguments::String))
    &OpTypePointer => PointerType(inst, types[inst.arguments[end]::ResultID])
    _ => error("$op does not represent a SPIR-V type or the corresponding type is not implemented.")
  end
end

function julia_type(@nospecialize(t::SPIRType))
  @match t begin
    &(IntegerType(8, false)) => UInt8
    &(IntegerType(16, false)) => UInt16
    &(IntegerType(32, false)) => UInt32
    &(IntegerType(64, false)) => UInt64
    &(IntegerType(8, true)) => Int8
    &(IntegerType(16, true)) => Int16
    &(IntegerType(32, true)) => Int32
    &(IntegerType(64, true)) => Int64
    &(FloatType(16)) => Float16
    &(FloatType(32)) => Float32
    &(FloatType(64)) => Float64
  end
end

iscomposite(@nospecialize(t::SPIRType)) =  isa(t, StructType) || isa(t, VectorType) || isa(t, MatrixType) || isa(t, ArrayType)

@refbroadcast @struct_hash_equal struct TypeMap
  d::Dictionary{DataType,SPIRType}
end

struct UnknownType <: Exception
  msg::String
  T::DataType
end

Base.showerror(io::IO, exc::UnknownType) = print(io, "UnknownType: ", exc.msg)

TypeMap() = TypeMap(Dictionary())

@forward_interface TypeMap field = :d interface = dict omit = [getindex, setindex!]
Base.setindex!(tmap::TypeMap, type::SPIRType, T::DataType) = set!(tmap.d, T, type)
function Base.merge!(x::TypeMap, y::TypeMap)
  merge!(x.d, y.d)
  x
end

function Base.getindex(tmap::TypeMap, T::DataType)
  t = get(tmap.d, T, nothing)
  !isnothing(t) && return t
  isstructtype(T) && !(T <: Vec || T <: Arr || T <: Mat || T <: Vector) && return throw(UnknownType("Type $T has no known mapping to SPIR-V within this `TypeMap`", T))
  spir_type(T, tmap; fill_tmap = false)
end

assert_type_known(t::SPIRType) = !isa(t, OpaqueType) || error("Unknown type `$(t.name)` reached. This suggests that an error was encoutered in the Julia function during its compilation.")

function spir_type(@nospecialize(t::Union{Union, Type{Union{}}}), tmap::Optional{TypeMap} = nothing; kwargs...)
  t === Union{} && return OpaqueType(Symbol("Union{}"))
  error("Can't get a SPIR-V type for $t; unions are not supported at the moment.")
end

remap_type(@nospecialize(t::DataType)) = t

"""
Get a SPIR-V type from a Julia type, caching the mapping in the `IR` if one is provided.

If `wrap_mutable` is set to true, then a pointer with class `StorageClassFunction` will wrap the result.
"""
function spir_type(@nospecialize(t::DataType), tmap::Optional{TypeMap} = nothing; wrap_mutable = false, storage_class = nothing, fill_tmap = true)
  t = remap_type(t)
  wrap_mutable && ismutabletype(t) && return PointerType(StorageClassFunction, spir_type(t, tmap))
  !isnothing(tmap) && isnothing(storage_class) && haskey(tmap, t) && return tmap[t]
  type = @match t begin
    &Float16 => FloatType(16)
    &Float32 => FloatType(32)
    &Float64 => FloatType(64)
    &Nothing => VoidType()
    &Bool => BooleanType()
    &UInt8 => IntegerType(8, false)
    &UInt16 => IntegerType(16, false)
    &UInt32 => IntegerType(32, false)
    &UInt64 => IntegerType(64, false)
    &Int8 => IntegerType(8, true)
    &Int16 => IntegerType(16, true)
    &Int32 => IntegerType(32, true)
    &Int64 => IntegerType(64, true)
    ::Type{<:Array} => begin
      eltype, n = t.parameters
      @match n begin
        1 => ArrayType(spir_type(eltype, tmap), nothing)
        _ => ArrayType(spir_type(Array{eltype,n - 1}, tmap), nothing)
      end
    end
    ::Type{<:Tuple} => if fieldcount(t) > 1 && allequal(fieldtypes(t))
      ArrayType(spir_type(eltype(t), tmap), Constant(UInt32(fieldcount(t))))
    else
      # Generate structure on the fly.
      StructType([spir_type(subt, tmap) for subt in fieldtypes(t)])
    end
    ::Type{<:Pointer} => PointerType(StorageClassPhysicalStorageBuffer, spir_type(eltype(t), tmap))
    ::Type{<:Vec} => VectorType(spir_type(eltype(t), tmap), length(t))
    ::Type{<:Mat} => MatrixType(spir_type(Vec{nrows(t),eltype(t)}, tmap), ncols(t))
    ::Type{<:Arr} => ArrayType(spir_type(eltype(t), tmap), Constant(UInt32(length(t))))
    ::Type{Sampler} => SamplerType()
    ::Type{<:Image} => ImageType(spir_type(component_type(t), tmap), dim(t), is_depth(t), is_arrayed(t), is_multisampled(t), is_sampled(t), format(t), nothing)
    ::Type{<:SampledImage} => SampledImageType(spir_type(image_type(t), tmap))
    GuardBy(isstructtype) || ::Type{<:NamedTuple} => StructType(spir_type.(t.types, tmap))
    GuardBy(isprimitivetype) => primitive_type_to_spirv(t)
    ::Type{Any} => error("Type Any is not a valid SPIR-V type; type inference must have failed.")
    GuardBy(isabstracttype) => error("Abstract types cannot be mapped to SPIR-V types (type: $t).")
    _ => error("Type $t does not have a corresponding SPIR-V type.")
  end

  #TODO: WIP, need to insert an `OpCompositeExtract` for all uses if the type changed.
  promoted_type = promote_to_interface_block(type, storage_class)
  if type ≠ promoted_type
    error("The provided type `$type` for storage class `$storage_class` must be a struct or an array of structs. The automation of this requirement is a work in progress.")
  end

  if type == promoted_type && !isnothing(tmap) && fill_tmap
    tmap[t] = type
  end

  promoted_type
end

"""
    primitive_type_to_spirv(::Type{T})::SPIRType where {T}

Specify which SPIR-V type corresponds to a given primitive type.
Both types must have the same number of bits.
"""
function primitive_type_to_spirv end

primitive_type_to_spirv(T::DataType) = error("Primitive type $T has no known SPIR-V type. This function must be extended to choose which SPIR-V type to map this primitive type to.")

function promote_to_interface_block(type, storage_class)
  @tryswitch storage_class begin
    @case &StorageClassPushConstant
    # Type must be a struct.
    !isa(type, StructType) && return StructType([type])
    @case &StorageClassUniform || &StorageClassStorageBuffer
    # Type must be a struct or an array of structs.
    @tryswitch type begin
      @case ::StructType
      nothing
      @case ::ArrayType
      !isa(type.eltype, StructType) && return @set type.eltype = StructType([type.eltype])
      @case _
      return StructType([type])
    end
  end
  type
end

function SPIRType(c::Constant, tmap::TypeMap)
  @match c.value begin
    (_, type::SPIRType) || (_, type::SPIRType) => type
    val => spir_type(typeof(val), tmap)
  end
end
