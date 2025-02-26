@enum SPIRTypeName begin
  SPIR_TYPE_VOID
  SPIR_TYPE_INTEGER
  SPIR_TYPE_FLOAT
  SPIR_TYPE_BOOLEAN
  SPIR_TYPE_VECTOR
  SPIR_TYPE_MATRIX
  SPIR_TYPE_ARRAY
  SPIR_TYPE_IMAGE
  SPIR_TYPE_SAMPLER
  SPIR_TYPE_SAMPLED_IMAGE
  SPIR_TYPE_OPAQUE
  SPIR_TYPE_STRUCT
  SPIR_TYPE_POINTER
  SPIR_TYPE_FUNCTION
end

"""
SPIR-V aggregate type.

Equality is defined in terms of identity, since different aggregate
types have in principle different semantics.
"""
SPIR_TYPE_STRUCT

struct SPIRType
  typename::SPIRTypeName
  data::Any

  function SPIRType(typename::SPIRTypeName, args...)
    assert_nargs(n) = length(args) == n || throw(ArgumentError("$n arguments are required, but $(length(args)) were provided"))
    @match typename begin
      &SPIR_TYPE_VOID => begin
        assert_nargs(0)
        new(typename, nothing)
      end
      &SPIR_TYPE_FLOAT => begin
        assert_nargs(1)
        width = convert(Int, args[1])
        new(typename, width)
      end
      &SPIR_TYPE_INTEGER => begin
        assert_nargs(2)
        width = convert(Int, args[1])
        signed = convert(Bool, args[2])
        new(typename, (width, signed))
      end
      &SPIR_TYPE_BOOLEAN => begin
        assert_nargs(0)
        new(typename, nothing)
      end
      &SPIR_TYPE_VECTOR => begin
        assert_nargs(2)
        eltype = convert(SPIRType, args[1])
        n = convert(Int, args[2])
        is_scalar(eltype) || throw(ArgumentError("SPIR-V vectors only accept scalar types as element type"))
        new(typename, (eltype, n))
      end
      &SPIR_TYPE_MATRIX => begin
        length(args) == 2 && (args = (args..., true))
        assert_nargs(3)
        eltype = convert(SPIRType, args[1])
        n = convert(Int, args[2])
        is_column_major = convert(Bool, args[3])
        istype(eltype, SPIR_TYPE_VECTOR) || throw(ArgumentError("A vector type must be provided as matrix column type"))
        new(typename, (eltype, n, is_column_major))
      end
      &SPIR_TYPE_ARRAY => begin
        if length(args) == 2
          eltype = convert(SPIRType, args[1])
          size = convert(Optional{Constant}, args[2])
          info = ArrayTypeInfo(eltype, size)
        else
          assert_nargs(1)
          info = convert(ArrayTypeInfo, args[1])
        end
        new(typename, info)
      end
      &SPIR_TYPE_OPAQUE => begin
        assert_nargs(1)
        name = convert(Symbol, args[1])
        new(typename, name)
      end
      &SPIR_TYPE_IMAGE => begin
        assert_nargs(1)
        info = convert(ImageTypeInfo, args[1])
        new(typename, info)
      end
      &SPIR_TYPE_SAMPLER => begin
        assert_nargs(0)
        new(typename, nothing)
      end
      &SPIR_TYPE_SAMPLED_IMAGE => begin
        assert_nargs(1)
        type = convert(SPIRType, args[1])
        type.typename == SPIR_TYPE_IMAGE || throw(ArgumentError("A sampled image type must wrap an image type"))
        new(typename, type)
      end
      &SPIR_TYPE_FUNCTION => begin
        assert_nargs(2)
        rettype = convert(SPIRType, args[1])
        argtypes = convert(Vector{SPIRType}, args[2])
        new(typename, (rettype, argtypes))
      end
      &SPIR_TYPE_STRUCT => begin
        assert_nargs(2)
        id = convert(UUID, args[1])
        members = convert(Vector{SPIRType}, args[2])
        new(typename, (id, members))
      end
      &SPIR_TYPE_POINTER => begin
        assert_nargs(2)
        storage_class = convert(StorageClass, args[1])
        type = convert(SPIRType, args[2])
        new(typename, (storage_class, type))
      end
    end
  end
end

istype(type::SPIRType, typename::SPIRTypeName) = type.typename === typename

function assert_type(type::SPIRType, typename::SPIRTypeName)
  istype(type, typename) || error("Expected a SPIRType with typename `$typename`, got typename `$(type.typename)`")
end

function Base.getproperty(type::SPIRType, name::Symbol)
  name === :float && return @NamedTuple{width::Int}((type.data::Int,))
  name === :integer && return @NamedTuple{width::Int, signed::Bool}(type.data::Tuple{Int, Bool})
  name === :vector && return @NamedTuple{eltype::SPIRType, n::Int}(type.data::Tuple{SPIRType, Int})
  name === :matrix && return @NamedTuple{eltype::SPIRType, n::Int, is_column_major::Bool}(type.data::Tuple{SPIRType, Int, Bool})
  name === :array && return type.data::ArrayTypeInfo
  name === :opaque && return @NamedTuple{name::Symbol}((type.data::Symbol,))
  name === :image && return type.data::ImageTypeInfo
  name === :image_type && return type.data::SPIRType
  name === :struct && return @NamedTuple{uuid::UUID, members::Vector{SPIRType}}(type.data::Tuple{UUID, Vector{SPIRType}})
  name === :pointer && return @NamedTuple{storage_class::StorageClass, type::SPIRType}(type.data::Tuple{StorageClass, SPIRType})
  name === :function && return @NamedTuple{rettype::SPIRType, argtypes::Vector{SPIRType}}(type.data::Tuple{SPIRType, Vector{SPIRType}})
  getfield(type, name)
end

function SPIRType(inst::Instruction, types::BijectiveMapping, constants::BijectiveMapping)
  @match inst.opcode begin
    &OpTypeVoid => void_type()
    &OpTypeFloat => begin
      width = inst.arguments[1]::Union{Int, UInt32}
      float_type(width)
    end
    &OpTypeInt => begin
      width = inst.arguments[1]::Union{Int, UInt32}
      signed = Bool(inst.arguments[2]::Union{UInt32, Bool})
      integer_type(width, signed)
    end
    &OpTypeBool => boolean_type()
    &OpTypeVector => begin
      eltype = types[inst.arguments[1]::ResultID]
      n = inst.arguments[end]::Union{Int, UInt32}
      vector_type(eltype, n)
    end
    &OpTypeMatrix => begin
      eltype = types[inst.arguments[1]::ResultID]
      n = inst.arguments[end]::Union{Int, UInt32}
      matrix_type(eltype, n)
    end
    &OpTypeArray => begin
      eltype = types[inst.arguments[1]::ResultID]
      size = constants[inst.arguments[end]::ResultID]
      array_type(ArrayTypeInfo(eltype, size))
    end
    &OpTypeRuntimeArray => begin
      eltype = types[inst.arguments[1]::ResultID]
      array_type(ArrayTypeInfo(eltype, nothing))
    end
    &OpTypeOpaque => begin
      name = Symbol(inst.arguments[1]::String)
      opaque_type(name)
    end
    &OpTypeImage => begin
      sampled_type = types[inst.arguments[1]::ResultID]
      dim = inst.arguments[2]::Dim
      depth = inst.arguments[3]::UInt32
      arrayed = Bool(inst.arguments[4]::Union{UInt32, Bool})
      multisampled = inst.arguments[5]::UInt32
      sampled = inst.arguments[6]::UInt32
      format = inst.arguments[7]::ImageFormat
      access_qualifier = length(inst.arguments) > 7 ? inst.arguments[end]::AccessQualifier : nothing
      sampled = sampled == 0 ? nothing : Bool(2 - sampled)
      depth == 2 && (depth = nothing)
      info = ImageTypeInfo(sampled_type, dim, depth, arrayed, multisampled, sampled, format, access_qualifier)
      image_type(info)
    end
    &OpTypeSampler => sampler_type()
    &OpTypeSampledImage => begin
      type = types[inst.arguments[1]::ResultID]
      sampled_image_type(type)
    end
    &OpTypeStruct => begin
      members = SPIRType[types[id] for id::ResultID in inst.arguments]
      struct_type(members)
    end
    &OpTypePointer => begin
      storage_class = inst.arguments[1]::StorageClass
      type = types[inst.arguments[end]::ResultID]
      pointer_type(storage_class, type)
    end
    _ => error("$(inst.op) does not represent a SPIR-V type or parsing was not implemented for the corresponding type.")
  end
end

is_scalar(type::SPIRType) = in(type.typename, (SPIR_TYPE_FLOAT, SPIR_TYPE_INTEGER, SPIR_TYPE_BOOLEAN))

void_type() = SPIRType(SPIR_TYPE_VOID)
boolean_type() = SPIRType(SPIR_TYPE_BOOLEAN)
integer_type(width, signed) = SPIRType(SPIR_TYPE_INTEGER, width, signed)
float_type(width) = SPIRType(SPIR_TYPE_FLOAT, width)
vector_type(eltype, n) = SPIRType(SPIR_TYPE_VECTOR, eltype, n)
matrix_type(eltype, n, is_column_major = true) = SPIRType(SPIR_TYPE_MATRIX, eltype, n, is_column_major)
array_type(eltype, size) = array_type(ArrayTypeInfo(eltype, size))
array_type(info) = SPIRType(SPIR_TYPE_ARRAY, info)
image_type(info) = SPIRType(SPIR_TYPE_IMAGE, info)
sampler_type() = SPIRType(SPIR_TYPE_SAMPLER)
sampled_image_type(image_type) = SPIRType(SPIR_TYPE_SAMPLED_IMAGE, image_type)
opaque_type(name) = SPIRType(SPIR_TYPE_OPAQUE, name)
pointer_type(storage_class, t) = SPIRType(SPIR_TYPE_POINTER, storage_class, t)
struct_type(members) = struct_type(uuid1(), members)
struct_type(uuid, members) = SPIRType(SPIR_TYPE_STRUCT, uuid, members)
function_type(rettype, argtypes) = SPIRType(SPIR_TYPE_FUNCTION, rettype, argtypes)

function is_descriptor_backed(type::SPIRType)
  @match type.typename begin
    &SPIR_TYPE_IMAGE || &SPIR_TYPE_SAMPLER || &SPIR_TYPE_SAMPLED_IMAGE => true
    &SPIR_TYPE_ARRAY => is_descriptor_backed(type.array.eltype)
    &SPIR_TYPE_STRUCT => any(is_descriptor_backed, t.struct.members)
  end
end

function Base.:(≈)(x::SPIRType, y::SPIRType)
  tx = x.typename
  ty = y.typename
  tx ≠ ty && return false
  @match tx begin
    &SPIR_TYPE_ARRAY => begin
      x, y = x.array, y.array
      x.eltype ≈ y.eltype && x.size == y.size
    end
    &SPIR_TYPE_IMAGE || &SPIR_TYPE_SAMPLED_IMAGE => begin
      x, y = x.image, y.image
      x.sampled_type ≈ y.sampled_type && x.dim == y.dim && x.depth === y.depth && x.arrayed == y.arrayed && x.multisampled == y.multisampled && x.sampled === y.sampled && x.format == y.format && x.access_qualifier === y.access_qualifier
    end
    &SPIR_TYPE_POINTER => begin
      x, y = x.pointer, y.pointer
      x.storage_class == y.storage_class && x.type ≈ y.type
    end
    &SPIR_TYPE_STRUCT => all(subx ≈ suby for (subx, suby) in zip(x.struct.members, y.struct.members))
    &SPIR_TYPE_FUNCTION => begin
      x, y = x.function, y.function
      x.rettype ≈ y.rettype && length(x.argtypes) == length(y.argtypes) && all(ax ≈ ay for (ax, ay) in zip(x.argtypes, y.argtypes))
    end
    _ => x == y
  end
end

function Base.:(==)(x::SPIRType, y::SPIRType)
  x.typename == y.typename || return false
  if istype(x, SPIR_TYPE_FUNCTION)
    x, y = x.function, y.function
    return x.rettype == y.rettype && x.argtypes == y.argtypes
  end
  x.data == y.data
end

function Base.hash(type::SPIRType, h::UInt)
  h = hash(SPIRType, hash(type.typename, h))
  @match type.typename begin
    &SPIR_TYPE_FUNCTION => begin
      (; rettype, argtypes) = type.function
      hash(rettype, hash(argtypes, h))
    end
    &SPIR_TYPE_STRUCT => hash(type.struct.uuid, h)
    _ => hash(type.data, h)
  end
end

const IS_SPEC_CONST_FALSE = Ref(false)
const IS_SPEC_CONST_TRUE = Ref(true)

@struct_hash_equal struct Constant
  value::Any
  type::SPIRType
  # Use a `Ref` so that specialization constants are unique.
  # Do NOT modify the underlying value.
  is_spec_const::Base.RefValue{Bool}
end

function Constant(value::T) where {T}
  isprimitivetype(T) && return Constant(value, spir_type(T))
  isa(value, QuoteNode) && return Constant(value.value)
  # Disallow composite types, as we don't want to generate new structures.
  error("A type must be provided for the constant $value")
end

Constant(value, type) = Constant(value, type, IS_SPEC_CONST_FALSE)
Constant(node::QuoteNode, type) = Constant(node.value, type)

struct ArrayTypeInfo
  eltype::SPIRType
  size::Optional{Constant}
end

@struct_hash_equal struct ImageTypeInfo
  sampled_type::SPIRType
  dim::Dim
  depth::Optional{Bool}
  arrayed::Bool
  multisampled::Bool
  sampled::Optional{Bool}
  format::ImageFormat
  access_qualifier::Optional{AccessQualifier}
end

function scalar_julia_type(type::SPIRType)
  @match type.typename begin
    &SPIR_TYPE_BOOLEAN => Bool
    &SPIR_TYPE_INTEGER => @match Tuple(type.integer) begin
      (8,  false) => UInt8
      (16, false) => UInt16
      (32, false) => UInt32
      (64, false) => UInt64
      (8,   true) => Int8
      (16,  true) => Int16
      (32,  true) => Int32
      (64,  true) => Int64
      (width, _) => throw(ArgumentError("Integer type width ($width) must be a multiple of two between 8 and 64"))
    end
    &SPIR_TYPE_FLOAT => @match type.float.width begin
      16 => Float16
      32 => Float32
      64 => Float64
      width => throw(ArgumentError("Floating-point type width ($width) must be a multiple of two between 16 and 64"))
    end
  end
end

function iscomposite(type::SPIRType)
  (; typename) = type
  typename == SPIR_TYPE_STRUCT && return true
  typename == SPIR_TYPE_VECTOR && return true
  typename == SPIR_TYPE_MATRIX && return true
  typename == SPIR_TYPE_ARRAY && return true
  false
end

"Return either a column or a row vector type for column-major and row-major layouts respectively."
function eltype_major(type::SPIRType)
  assert_type(type, SPIR_TYPE_MATRIX)
  (; matrix) = type
  matrix.is_column_major && return matrix.eltype
  vector_type(matrix.eltype.vector.eltype, matrix.n)
end

@refbroadcast @struct_hash_equal struct TypeMap
  d::Dictionary{DataType,SPIRType}
end

TypeMap() = TypeMap(Dictionary())

@forward_interface TypeMap field = :d interface = dict omit = [getindex, setindex!]
Base.setindex!(tmap::TypeMap, type::SPIRType, T::DataType) = set!(tmap.d, T, type)

function Base.merge!(x::TypeMap, y::TypeMap)
  merge!(x.d, y.d)
  x
end

struct UnknownType <: Exception
  msg::String
  T::DataType
end

Base.showerror(io::IO, exc::UnknownType) = print(io, "UnknownType: ", exc.msg)

function Base.getindex(tmap::TypeMap, T::DataType)
  t = get(tmap.d, T, nothing)
  !isnothing(t) && return t
  t = spir_type(T, tmap; fill_tmap = false)
  # If we get a struct, it should have been obtained via the TypeMap,
  # as we would otherwise get a brand new struct with a new ID.
  t.typename == SPIR_TYPE_STRUCT && throw(UnknownType("Type $T has no known mapping to SPIR-V within this `TypeMap`", T))
  t
end

assert_type_known(type::SPIRType) = type.typename ≠ SPIR_TYPE_OPAQUE || error("Unknown type `$(type.typename)` encountered. This suggests that an error was encoutered in the Julia function during its compilation.")

error_type_not_known(type::Type) = error("Type `$type` does not have a corresponding SPIR-V type.")

function spir_type(T::Union, tmap::Optional{TypeMap} = nothing; kwargs...)
  throw(ArgumentError("Can't get a SPIR-V type for $T; unions are not supported at the moment."))
end

spir_type(::Type{Union{}}, tmap::Optional{TypeMap} = nothing; kwargs...) = opaque_type(Symbol("Union{}"))

"""
Get a SPIR-V type from a Julia type, caching the mapping in the `IR` if one is provided.
"""
function spir_type(::Type{T}, tmap::Optional{TypeMap} = nothing; storage_class = nothing, fill_tmap = true) where {T}
  T === Core.SSAValue && throw_compilation_error("a `Core.SSAValue` slipped in, while it shouldn'T have")
  ismutable = ismutabletype(T)

  isa(T, DataType) && !isnothing(tmap) && isnothing(storage_class) && haskey(tmap, T) && return tmap[T]

  type = @match T begin
    &Float16 => float_type(16)
    &Float32 => float_type(32)
    &Float64 => float_type(64)
    &Nothing => struct_type(UUID(0), SPIRType[])
    &Bool => boolean_type()
    &UInt8 => integer_type(8, false)
    &UInt16 => integer_type(16, false)
    &UInt32 => integer_type(32, false)
    &UInt64 => integer_type(64, false)
    &Int8 => integer_type(8, true)
    &Int16 => integer_type(16, true)
    &Int32 => integer_type(32, true)
    &Int64 => integer_type(64, true)
    ::Type{<:Mutable} => pointer_type(something(storage_class, StorageClassFunction), spir_type(T.parameters[1], tmap))
    ::Type{<:Array} => begin
      eltype, n = T.parameters
      @match n begin
        1 => array_type(spir_type(eltype, tmap), nothing)
        _ => array_type(spir_type(Array{eltype,n - 1}, tmap), nothing)
      end
    end
    GuardBy(isabstracttype) => throw(ArgumentError("Abstract types cannot be mapped to SPIR-V types (type: $T)."))
    GuardBy(!isconcretetype) => throw(ArgumentError("Non-concrete types are not supported in SPIR-V."))
    ::Type{Tuple} => error("Unsized tuple types are not supported")
    ::Type{<:Tuple} => if fieldcount(T) > 1 && allequal(fieldtypes(T))
      array_type(spir_type(eltype(T), tmap), Constant(UInt32(fieldcount(T))))
    else
      # Generate structure on the fly.
      struct_type([spir_type(member_type, tmap) for member_type in fieldtypes(T)])
    end
    ::Type{<:Pointer} => pointer_type(StorageClassPhysicalStorageBuffer, spir_type(eltype(T), tmap))
    ::Type{<:SVector} && GuardBy(is_spirv_vector) => vector_type(spir_type(eltype(T), tmap), length(T))
    ::Type{<:SVector} => array_type(spir_type(eltype(T), tmap), Constant(UInt32(length(T))))
    ::Type{<:SMatrix} && GuardBy(is_spirv_matrix) => matrix_type(spir_type(Vec{nrows(T),eltype(T)}, tmap), ncols(T))
    ::Type{Sampler} => sampler_type()
    ::Type{<:Image} => image_type(ImageTypeInfo(spir_type(component_type(T), tmap), dim(T), is_depth(T), is_arrayed(T), is_multisampled(T), is_sampled(T), format(T), nothing))
    ::Type{<:SampledImage} => sampled_image_type(spir_type(image_type(T), tmap))
    GuardBy(isstructtype) || ::Type{<:NamedTuple} => struct_type(spir_type.(T.types, tmap))
    GuardBy(isprimitivetype) => begin
      T′ = primitive_type_to_spirv(T)
      isa(T′, SPIRType) ? T′ : spir_type(T′, tmap)
    end
    ::Type{Any} => throw(ArgumentError("Type Any is not a valid SPIR-V type; type inference must have failed."))
    _ => error_type_not_known(T)
  end

  #TODO: WIP, need to insert an `OpCompositeExtract` for all uses if the type changed.
  promoted_type = promote_to_interface_block(type, storage_class)
  if type ≠ promoted_type
    error("The provided type `$type` for storage class `$storage_class` must be a struct or an array of structs. The automation of this requirement is a work in progress.")
  end

  if !isnothing(tmap) && fill_tmap
    tmap[T] = type
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
primitive_type_to_spirv(::Union{Type{<:Enum{T}}, Type{<:Cenum{T}}}) where {T} = spir_type(T)

function promote_to_interface_block(type, storage_class)
  @match storage_class begin
    # Type must be a struct.
    &StorageClassPushConstant => type.typename == SPIR_TYPE_STRUCT ? type : struct_type([type])
    # Type must be a struct or an array of structs.
    &StorageClassUniform || &StorageClassStorageBuffer => @match type.typename begin
        &SPIR_TYPE_STRUCT => type
        &SPIR_TYPE_ARRAY => begin
          (; array) = type
          array.eltype.name == SPIR_TYPE_STRUCT ? type : array_type(struct_type([array.eltype]), array.size)
        end
        _ => struct_type([type])
    end
    _ => type
  end
end
