mutable struct Decorations
  defined::Set{Decoration}
  spec_id::UInt32
  array_stride::UInt32
  matrix_stride::UInt32
  builtin::BuiltIn
  uniform_id::Scope
  stream::UInt32
  location::UInt32
  component::UInt32
  index::UInt32
  binding::UInt32
  descriptor_set::UInt32
  offset::UInt32
  xfb_buffer::UInt32
  xfb_stride::UInt32
  func_param_attr::FunctionParameterAttribute
  fp_rounding_mode::FPRoundingMode
  fp_fast_math_mode::FPFastMathMode
  linkage_attribute::Pair{String, LinkageType}
  input_attachment_index::UInt32
  alignment::UInt32
  max_byte_offset::UInt32
  alignment_id::ResultID
  max_byte_offset_id::ResultID
  counter_buffer::ResultID
  user_semantic::String
  Decorations() = new(Set{Decoration}())
end

function Base.hash(decs::Decorations, h::UInt)
  for field in propertynames(Decorations)
    isdefined(decs, field) && (h += hash(getproperty(decs, field)))
  end
  h
end
Base.:(==)(x::Decorations, y::Decorations) = hash(x) == hash(y)

Decorations(dec::Decoration, args...) = Decorations().decorate!(dec, args...)

Base.getproperty(decs::Decorations, symbol::Symbol) = symbol === :decorate! ? decorate!(decs) : getfield(decs, symbol)

function decorate!(decs::Decorations)
  function _decorate!(dec::Decoration, args...)
    decorate!(decs, dec, args...)
  end
end

has_decoration(decs::Decorations, dec::Decoration) = dec in decs.defined

function decorate!(decs::Decorations, dec::Decoration, args...)
  info = get(enum_infos, dec, nothing)
  if isnothing(info)
    @error "Unknown decoration $dec($(join([arg, args...], ", ")))"
    return decs
  end
  if length(args) ≠ length(info.parameters)
    # No variable-length parameters or optional parameters are available as of this writing in SPIR-V.
    throw(ArgumentError(string("Invalid number of arguments for ", dec, ": expected ", iszero(length(info.parameters)) ? "no arguments" : join(format_parameter.(info.parameters), ", "), ", got ", length(args), " arguments")))
  end

  push!(decs.defined, dec)
  isempty(args) && return decs

  (arg, args...) = args
  @switch dec begin
    @case &DecorationSpecId              ; setproperty!(decs, :spec_id, arg)
    @case &DecorationArrayStride         ; setproperty!(decs, :array_stride, arg)
    @case &DecorationMatrixStride        ; setproperty!(decs, :matrix_stride, arg)
    @case &DecorationBuiltIn             ; setproperty!(decs, :builtin, arg)
    @case &DecorationUniformId           ; setproperty!(decs, :uniform_id, arg)
    @case &DecorationStream              ; setproperty!(decs, :stream, arg)
    @case &DecorationLocation            ; setproperty!(decs, :location, arg)
    @case &DecorationComponent           ; setproperty!(decs, :component, arg)
    @case &DecorationIndex               ; setproperty!(decs, :index, arg)
    @case &DecorationBinding             ; setproperty!(decs, :binding, arg)
    @case &DecorationDescriptorSet       ; setproperty!(decs, :descriptor_set, arg)
    @case &DecorationOffset              ; setproperty!(decs, :offset, arg)
    @case &DecorationXfbBuffer           ; setproperty!(decs, :xfb_buffer, arg)
    @case &DecorationXfbStride           ; setproperty!(decs, :xfb_stride, arg)
    @case &DecorationFuncParamAttr       ; setproperty!(decs, :func_param_attr, arg)
    @case &DecorationFPRoundingMode      ; setproperty!(decs, :fp_rounding_mode, arg)
    @case &DecorationFPFastMathMode      ; setproperty!(decs, :fp_fast_math_mode, arg)
    @case &DecorationLinkageAttributes   ; setproperty!(decs, :linkage_attribute, arg => first(args))
    @case &DecorationInputAttachmentIndex; setproperty!(decs, :input_attachment_index, arg)
    @case &DecorationAlignment           ; setproperty!(decs, :alignment, arg)
    @case &DecorationMaxByteOffset       ; setproperty!(decs, :max_byte_offset, arg)
    @case &DecorationAlignmentId         ; setproperty!(decs, :alignment_id, arg)
    @case &DecorationMaxByteOffsetId     ; setproperty!(decs, :max_byte_offset_id, arg)
    @case &DecorationCounterBuffer       ; setproperty!(decs, :counter_buffer, arg)
    @case &DecorationUserSemantic        ; setproperty!(decs, :user_semantic, arg)
    @case _                              ; error("Not implemented for ", dec)
  end
  decs
end

function Base.merge!(x::Decorations, y::Decorations)
  for dec in y.defined
    extract(x.decorate!, y, dec)
  end
  x
end

function Base.merge(xs::Decorations...)
  res = Decorations()
  for decs in xs
    merge!(res, decs)
  end
  res
end

function Base.show(io::IO, decs::Decorations)
  print(io, Decorations, '(')
  extract_args(dec) = nothing
  extract_args(dec, value) = value
  for (i, dec) in enumerate(sort(collect(decs.defined)))
    i > 1 && print(io, ", ")
    print(io, dec)
    value = extract(extract_args, decs, dec)
    !isnothing(value) && print(io, " = ", value)
  end
  print(io, ')')
end

append_decorations!(insts, id::ResultID, decs::Decorations, member_index::Signed) = append_decorations!(insts, id, decs, UInt32(member_index - 1))
function append_decorations!(insts, id::ResultID, decs::Decorations, member_index::Optional{UInt32} = nothing)
  for dec in sort(collect(decs.defined))
    inst = instruction(decs, dec, member_index)
    if !isnothing(inst)
      pushfirst!(inst.arguments, id)
      push!(insts, inst)
    end
  end
end

function extract(f, decs::Decorations, dec::Decoration)
  nargs_max = length(enum_infos[Decoration].enumerants[UInt32(dec)].parameters)
  iszero(nargs_max) && return f(dec)
  @match dec begin
    &DecorationSpecId               => f(dec, decs.spec_id)
    &DecorationArrayStride          => f(dec, decs.array_stride)
    &DecorationMatrixStride         => f(dec, decs.matrix_stride)
    &DecorationBuiltIn              => f(dec, decs.builtin)
    &DecorationUniformId            => f(dec, decs.uniform_id)
    &DecorationStream               => f(dec, decs.stream)
    &DecorationLocation             => f(dec, decs.location)
    &DecorationComponent            => f(dec, decs.component)
    &DecorationIndex                => f(dec, decs.index)
    &DecorationBinding              => f(dec, decs.binding)
    &DecorationDescriptorSet        => f(dec, decs.descriptor_set)
    &DecorationOffset               => f(dec, decs.offset)
    &DecorationXfbBuffer            => f(dec, decs.xfb_buffer)
    &DecorationXfbStride            => f(dec, decs.xfb_stride)
    &DecorationFuncParamAttr        => f(dec, decs.func_param_attr)
    &DecorationFPRoundingMode       => f(dec, decs.fp_rounding_mode)
    &DecorationFPFastMathMode       => f(dec, decs.fp_fast_math_mode)
    &DecorationLinkageAttributes    => f(dec, decs.linkage_attribute...)
    &DecorationInputAttachmentIndex => f(dec, decs.input_attachment_index)
    &DecorationAlignment            => f(dec, decs.alignment)
    &DecorationMaxByteOffset        => f(dec, decs.max_byte_offset)
    &DecorationAlignmentId          => f(dec, decs.alignment_id)
    &DecorationMaxByteOffsetId      => f(dec, decs.max_byte_offset_id)
    &DecorationCounterBuffer        => f(dec, decs.counter_buffer)
    &DecorationUserSemantic         => f(dec, decs.user_semantic)
    _ => @error "Unknown decoration $dec"
  end
end

function instruction(decs::Decorations, dec::Decoration, member_index::Optional{UInt32} = nothing)
  op = isnothing(member_index) ? OpDecorate : OpMemberDecorate
  inst = extract((dec, args...) -> @inst(op(dec, args...)), decs, dec)
  isnothing(inst) && return
  !isnothing(member_index) && pushfirst!(inst.arguments, member_index)
  inst
end

mutable struct Metadata
  name::Symbol
  decorations::Decorations
  "Metadata for structure members, if any."
  member_metadata::Dictionary{Int, Metadata}
  Metadata() = new()
end

function Metadata(decs::Decorations)
  meta = Metadata()
  meta.decorations = decs
  meta
end

Metadata(name::Symbol, decs::Decorations) = Metadata(decs).set_name!(name)
Metadata(name::Symbol) = Metadata().set_name!(name)

Base.getproperty(meta::Metadata, symbol::Symbol) = symbol === :set_name! ? set_name!(meta) : symbol === :decorate! ? decorate!(meta) : getfield(meta, symbol)

function decorations!(meta::Metadata)
  isdefined(meta, :decorations) && return meta.decorations
  setproperty!(meta, :decorations, Decorations())
end

decorations!(meta::Metadata, member_index::Int) = decorations!(metadata!(meta, member_index))

function metadata!(meta::Metadata, member_index::Int)
  !isdefined(meta, :member_metadata) && setproperty!(meta, :member_metadata, Dictionary{Int,Metadata}())
  get!(Metadata, meta.member_metadata, member_index)
end

function decorate!(meta::Metadata)
  function _decorate!(args...)
    decorate!(meta, args...)
  end
end

function set_name!(meta::Metadata)
  function _set_name!(args...)
    set_name!(meta, args...)
  end
end

function Base.merge!(x::Metadata, y::Metadata)
  isdefined(y, :name) && setproperty!(x, :name, y.name)
  if isdefined(y, :decorations)
    merge!(decorations!(x), y.decorations)
  end
  if isdefined(y, :member_metadata)
    !isdefined(x, :member_metadata) && setproperty!(x, :member_metadata, Dictionary{Int,Metadata}())
    mergewith!(merge!, x.member_metadata, y.member_metadata)
  end
  x
end

function Base.merge(xs::Metadata...)
  res = Metadata()
  for meta in xs
    merge!(res, meta)
  end
  res
end

function decorate!(meta::Metadata, dec::Decoration, args...)
  decorate!(decorations!(meta), dec, args...)
  meta
end

function decorate!(meta::Metadata, member_index::Int, dec::Decoration, args...)
  decorate!(decorations!(meta, member_index), dec, args...)
  meta
end

decorations(meta::Metadata) = isdefined(meta, :decorations) ? meta.decorations : nothing
decorations(meta::Metadata, member_index::Int) = isdefined(meta, :member_metadata) ? decorations(get(meta.member_metadata, member_index, nothing)) : nothing

function has_decoration(meta::Metadata, member_index::Int, dec::Decoration)
  decs = decorations(meta, member_index)
  isnothing(decs) && return false
  has_decoration(decs, dec)
end

function has_decoration(meta::Metadata, dec::Decoration)
  decs = decorations(meta)
  isnothing(decs) && return false
  has_decoration(decs, dec)
end

function append_decorations!(insts, id::ResultID, meta::Metadata)
  if isdefined(meta, :decorations)
    append_decorations!(insts, id, meta.decorations)
  end
  if isdefined(meta, :member_metadata)
    for (member_index, member_meta) in pairs(meta.member_metadata)
      isdefined(member_meta, :decorations) || continue
      append_decorations!(insts, id, member_meta.decorations, member_index)
    end
  end
end

function append_debug_annotations!(insts, id::ResultID, meta::Metadata)
  isdefined(meta, :name) && push!(insts, @inst OpName(id, String(meta.name)))
  if isdefined(meta, :member_metadata)
    for (member_index, member_meta) in pairs(meta.member_metadata)
      isdefined(member_meta, :name) && push!(insts, @inst OpMemberName(id, UInt32(member_index - 1), String(member_meta.name)))
    end
  end
end

function set_name!(meta::Metadata, name::Symbol)
  setproperty!(meta, :name, name)
  meta
end

function set_name!(meta::Metadata, member_index::Int, name::Symbol)
  set_name!(metadata!(meta, member_index), name)
  meta
end

metadata!(meta::Dictionary{T,Metadata}, key::T) where {T} = get!(Metadata, meta, key)
metadata!(meta::Dictionary{T,Metadata}, key::T, i::Int) where {T} = metadata!(metadata!(meta, key), i)
decorate!(meta::Dictionary{T,Metadata}, key::T, args...) where {T} = decorate!(metadata!(meta, key), args...)
decorate!(meta::Dictionary{T,Metadata}, key::T, i::Int, args...) where {T} = decorate!(metadata!(meta, key, i), args...)

function has_decoration(meta::Dictionary{T,Metadata}, key::T, dec::Decoration) where {T}
  meta = get(meta, key, nothing)
  isnothing(meta) && return false
  has_decoration(meta, dec)
end

function has_decoration(meta::Dictionary{T,Metadata}, key::T, i::Int, dec::Decoration) where {T}
  meta = get(meta, key, nothing)
  isnothing(meta) && return false
  has_decoration(meta, dec, i)
end

function decorations(meta::Dictionary{T,Metadata}, key::T) where {T}
  meta = get(meta, key, nothing)
  isnothing(meta) && return nothing
  decorations(meta)
end

function decorations(meta::Dictionary{T,Metadata}, key::T, i::Int) where {T}
  meta = get(meta, key, nothing)
  isnothing(meta) && return nothing
  decorations(meta, i)
end

set_name!(meta::Dictionary{T,Metadata}, key::T, i::Int, name::Symbol) where {T} = set_name!(metadata!(meta, key), i, name)

function append_annotations!(insts, metadata::ResultDict{Metadata})
  for (id, meta) in pairs(metadata)
    append_decorations!(insts, id, meta)
  end
end

function append_debug_instructions!(insts, metadata::ResultDict{Metadata})
  for (id, meta) in pairs(metadata)
    append_debug_annotations!(insts, id, meta)
  end
end
