mutable struct Mutable{T}
  value::T
end

const Mut{T} = Mutable{T}

Base.getindex(mut::Mutable) = Load(mut)
Base.getindex(mut::Mutable, index) = Load(mut)[index]

@noinline Load(mut) = mut.value

function Base.setindex!(mut::Mutable{T}, value::T) where {T}
  Store(mut, value)
end

Base.setindex!(mut::Mutable{T}, value) where {T} = setindex!(mut, convert(T, value))

function Base.setindex!(mut::Mutable{T}, value, index) where {T}
  current = mut[]
  mut[] = @set current[index] = value
end

@noinline function Store(mut::Mutable{T}, value::T) where {T}
  mut.value = value
  nothing
end

function Base.setproperty!(mut::Mutable, name::Symbol, value)
  name === :value && return setfield!(mut, name, value)
  optic = NamedTuple{(name,)}((value,))
  new = setproperties(mut[], optic)
  mut[] = new
  new
end

function Base.getproperty(mut::Mutable, name::Symbol)
  name === :value && return getfield(mut, name)
  getproperty(mut[], name)
end
