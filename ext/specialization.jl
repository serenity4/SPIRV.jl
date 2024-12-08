function SPIRV.SpecializationData(source::ShaderSource, specializations)
  data = UInt8[]
  entries = Vk.SpecializationMapEntry[]
  for (name, value) in pairs(specializations)
    ids = get(source.specializations, name, nothing)
    isnothing(ids) && error("No specialization constant found for `$name`")
    serialize_entries!(entries, data, value, name, ids, source.info.layout, length(entries))
  end
  info = Vk.SpecializationInfo(entries, UInt(length(data)), Ptr{Cvoid}(pointer(data)))
  SpecializationData{Vk.SpecializationInfo}(data, info)
end

"Serialize `value` in `data` and add the corresponding set of `Vk.SpecializationMapEntry` to `entries`."
function serialize_entries!(entries, data, value, name, ids, layout, start)
  # Booleans must be serialized as UInt32.
  isa(value, Bool) && (value = UInt32(value))
  T = typeof(value)
  type = layout[T]
  if !iscomposite(type)
    index = 1 + length(entries) - start
    in(index, eachindex(ids)) || error("More leaf values are present than there are specialization constant slots for the specialization constant `$name`; you may have provided a value of a different type than the declared specialization constant.")
    id = ids[index]
    offset = lastindex(data)
    serialize!(data, value, layout)
    size = lastindex(data) - offset
    @assert size == datasize(layout, type) "Serialized size and computed data size do not match!"
    push!(entries, Vk.SpecializationMapEntry(id, offset, size))
  else
    if istype(type, SPIR_TYPE_STRUCT)
      for field in fieldnames(T)
        serialize_entries!(entries, data, getproperty(value, field), name, ids, layout, start)
      end
    elseif istype(type, SPIR_TYPE_VECTOR) || istype(type, SPIR_TYPE_ARRAY)
      istype(type, SPIR_TYPE_ARRAY) && type.array.eltype && isnothing(eltype) && error("Only arrays of known sizes can be used as specialization constants")
      for x in value
        serialize_entries!(entries, data, x, name, ids, layout, start)
      end
    else
      assert_type(type, SPIR_TYPE_MATRIX)
      for col in value.cols
        serialize_entries!(entries, data, col, name, ids, layout, start)
      end
    end
  end
end
