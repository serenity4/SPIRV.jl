struct SpecializationData{T}
  data::Vector{UInt8}
  info::T
end

function specialize_shader(source, specializations)
  (isnothing(specializations) || isempty(specializations)) && return C_NULL
  SpecializationData(source, specializations)
end

Base.convert(::Type{Union{Ptr{Cvoid}, T}}, data::SpecializationData{T}) where {T} = data.info

function add_specialization!(specializations::Dictionary, mt::ModuleTarget, name::Symbol, constant::Constant)
  haskey(specializations, name) && !is_builtin_specialization_constant(name) && error("Multiple arguments are bound to the same specialization constant name `$name`")
  ids = ResultID[]
  add_specialization!(ids, mt, constant)
  set!(specializations, name, ids)
end

function add_specialization!(ids, mt::ModuleTarget, constant::Constant)
  !constant.is_spec_const[] && return
  (; value) = constant
  if isa(value, Vector{ResultID})
    for id in value
      add_specialization!(ids, mt, mt.constants[id])
    end
  else
    id = mt.constants[constant]
    get!(Metadata, mt.metadata, id).decorate!(DecorationSpecId, UInt32(id))
    push!(ids, id)
  end
end

is_builtin_specialization_constant(name) = name === :local_size

@struct_hash_equal struct ShaderInterface
  execution_model::ExecutionModel
  storage_classes::Vector{StorageClass}
  variable_decorations::Dictionary{Int,Decorations}
  type_metadata::Dictionary{DataType, Metadata}
  features::FeatureSupport
  execution_options::ShaderExecutionOptions
end

function ShaderInterface(execution_model::ExecutionModel;
                         storage_classes = StorageClass[],
                         variable_decorations = Dictionary{Int, Decorations}(),
                         type_metadata = Dictionary{DataType, Metadata}(),
                         features = AllSupported(),
                         execution_options = ShaderExecutionOptions(execution_model))
  @assert validate(execution_options, execution_model)
  ShaderInterface(execution_model, storage_classes, variable_decorations, type_metadata, features, execution_options)
end

function Base.show(io::IO, interface::ShaderInterface)
  print(io, ShaderInterface, '(', interface.execution_model, ", ", interface.execution_options)
  print(io, ')')
end

function IR(target::SPIRVTarget, interface::ShaderInterface, specializations)
  mt = ModuleTarget()
  tr = Translation(target)
  globals = Dictionary{Int,Union{Constant,Variable}}()
  variables_to_load = Variable[]
  for (i, storage_class) in enumerate(interface.storage_classes)
    if represents_constant(storage_class)
      T = tr.argtypes[i]
      t = spir_type(T, tr.tmap; storage_class)
      decs = interface.variable_decorations[i]
      name, value = @match storage_class begin
        &StorageClassConstantINTERNAL => (nothing, decs.internal)
        &StorageClassSpecConstantINTERNAL => decs.internal
      end
      id = emit_constant!(mt, tr, value; is_specialization_constant = storage_class == StorageClassSpecConstantINTERNAL)
      constant = mt.constants[id]
      constant.type === t || error("For constant argument $i, a value of type `$(typeof(value))` was provided, but its declared type is `$T`")
      !isnothing(name) && add_specialization!(specializations, mt, name, constant)
      insert!(globals, i, constant)
    elseif storage_class ≠ StorageClassFunction
      t = spir_type(tr.argtypes[i], tr.tmap; storage_class)
      if in(storage_class, (StorageClassPushConstant, StorageClassUniform, StorageClassStorageBuffer))
        decorate!(mt, emit!(mt, tr, t), DecorationBlock)
      end
      readonly = !isa(t, PointerType)
      ptr_t = readonly ? PointerType(storage_class, t) : @set(t.storage_class = storage_class)
      variable = Variable(ptr_t)
      readonly && !(isa(t, ArrayType) && is_descriptor_backed(ptr_t.type)) && push!(variables_to_load, variable)
      insert!(globals, i, variable)
      emit!(mt, tr, variable)
    end
  end
  compile!(mt, tr, target, globals)
  fdef = FunctionDefinition(mt, target.mi)
  ep = define_entry_point!(mt, tr, specializations, fdef, globals, variables_to_load, interface.execution_model, interface.execution_options)
  ir = IR(mt, tr)
  insert!(ir.entry_points, ep.func, ep)
  make_shader!(ir, fdef, interface, globals)
end

"""
Wrap a given function definition for use in a shader.

All function arguments will be filled with global variables.
The provided interface describes storage locations and decorations for those global variables.

It is assumed that the function arguments are typed to use the same storage classes.
"""
function make_shader!(ir::IR, fdef::FunctionDefinition, interface::ShaderInterface, globals)
  add_variable_decorations!(ir, globals, interface)
  emit_types!(ir)
  add_type_metadata!(ir, interface)

  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  restructure_loop_header_conditionals!(ir)

  ir
end

function define_entry_point!(mt::ModuleTarget, tr::Translation, specializations, fdef::FunctionDefinition, globals, variables_to_load, model::ExecutionModel, options::ShaderExecutionOptions)
  main = FunctionDefinition(FunctionType(VoidType(), []))
  ep = EntryPoint(:main, emit!(mt, tr, main), model, [], ResultID[])

  # Fill function body.
  blk = new_block!(main, next!(mt.idcounter))
  # The dictionary loses some of its elements to #undef values.
  #TODO: fix this hack in Dictionaries.jl if it is still needed.
  fid = findfirst(==(fdef), mt.fdefs.forward)
  arguments = ResultID[]
  for x in globals
    isa(x, Variable) || continue
    id = mt.global_vars[x]
    push!(ep.interfaces, id)
    if in(x, variables_to_load)
      t = x.type.type
      loaded_id = next!(mt.idcounter)
      push!(blk, @ex loaded_id = Load(id)::t)
      push!(arguments, loaded_id)
    end
  end
  push!(blk, @ex next!(mt.idcounter) = OpFunctionCall(fid, arguments...)::fdef.type.rettype)
  push!(blk, @ex OpReturn())

  add_options!(ep, mt, tr, options, specializations)
end

function add_options!(ep, mt, tr, options, specializations)
  (; model) = ep
  model == ExecutionModelFragment && return add_options!(ep, options::FragmentExecutionOptions)
  model == ExecutionModelGeometry && return add_options!(ep, options::GeometryExecutionOptions)
  model in (ExecutionModelTessellationControl, ExecutionModelTessellationEvaluation) && return add_options!(ep, options::TessellationExecutionOptions)
  if model == ExecutionModelGLCompute
    # Add `local_size` built-in specialization constant, and
    # set the execution mode to be `LocalSizeId` pointing to it.
    options::ComputeExecutionOptions
    (; local_size) = options
    eltype(local_size) === UInt32 || error("IDs are not allowed in `options.local_size`. You should instead use specialization constants to set the local size at pipeline creation time, if that was your intent.")
    ids = get!(specializations, :local_size) do
      res = ResultID[]
      for i in 1:3
        id = emit_constant!(mt, tr, local_size[i]; is_specialization_constant = true)
        add_specialization!(res, mt, mt.constants[id])
      end
      res
    end
    for (i, id) in enumerate(ids)
      constant = mt.constants[id]
      constant.value::UInt32 ≠ local_size[i] && (mt.constants[id] = @set constant.value = local_size[i])
    end
    return add_options!(ep, @set options.local_size = ntuple(i -> ids[i], 3))
  end
  model in (ExecutionModelMeshNV, ExecutionModelMeshEXT) && return add_options!(ep, options::MeshExecutionOptions)
  add_options!(ep, options::CommonExecutionOptions)
end

function add_variable_decorations!(ir::IR, globals, interface::ShaderInterface)
  for (i, decs) in pairs(interface.variable_decorations)
    x = globals[i]
    isa(x, Constant) && continue
    merge_metadata!(ir, ir.global_vars[x], Metadata(decs))
  end
end

function add_type_metadata!(ir::IR, interface::ShaderInterface)
  for (target, meta) in pairs(interface.type_metadata)
    merge_metadata!(ir, ir.types[ir.tmap[target]], meta)
  end
end

const EXECUTION_MODELS = dictionary([
  :vertex => ExecutionModelVertex,
  :geometry => ExecutionModelGeometry,
  :tessellation_control => ExecutionModelTessellationControl,
  :tessellation_evaluation => ExecutionModelTessellationEvaluation,
  :fragment => ExecutionModelFragment,
  :compute => ExecutionModelGLCompute,
  :ray_generation => ExecutionModelRayGenerationKHR,
  :intersection => ExecutionModelIntersectionKHR,
  :closest_hit => ExecutionModelClosestHitKHR,
  :any_hit => ExecutionModelAnyHitKHR,
  :miss => ExecutionModelMissKHR,
  :callable => ExecutionModelCallableKHR,
  :task => ExecutionModelTaskEXT,
  :mesh => ExecutionModelMeshEXT,
])
