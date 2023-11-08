@struct_hash_equal struct ShaderInterface
  execution_model::ExecutionModel
  storage_classes::Vector{StorageClass}
  variable_decorations::Dictionary{Int,Decorations}
  type_metadata::Dictionary{DataType, Metadata}
  features::FeatureSupport
  execution_options::ShaderExecutionOptions
end

function ShaderInterface(execution_model::ExecutionModel; storage_classes = [], variable_decorations = Dictionary(),
  type_metadata = Dictionary(), features = AllSupported(), execution_options = ShaderExecutionOptions(execution_model))
  @assert validate(execution_options, execution_model)
  ShaderInterface(execution_model, storage_classes, variable_decorations, type_metadata, features, execution_options)
end

function Base.show(io::IO, interface::ShaderInterface)
  print(io, ShaderInterface, '(', interface.execution_model, ", ", interface.execution_options)
  print(io, ')')
end

function IR(target::SPIRVTarget, interface::ShaderInterface)
  mt = ModuleTarget()
  tr = Translation()
  variables = Dictionary{Int,Variable}()
  for (i, sc) in enumerate(interface.storage_classes)
    if sc ≠ StorageClassFunction
      T = target.mi.specTypes.parameters[i + 1]
      isa(T, Type) && continue
      t = spir_type(T, tr.tmap; storage_class = sc)
      if sc in (StorageClassPushConstant, StorageClassUniform, StorageClassStorageBuffer)
        decorate!(mt, emit!(mt, tr, t), DecorationBlock)
      end
      ptr_type = PointerType(sc, t)
      var = Variable(ptr_type)
      insert!(variables, i, var)
    end
  end
  compile!(mt, tr, target, variables)
  fdef = FunctionDefinition(mt, target.mi)
  ep = define_entry_point!(mt, tr, fdef, interface.execution_model, interface.execution_options)
  ir = IR(mt, tr)
  ir.addressing_model = AddressingModelPhysicalStorageBuffer64
  insert!(ir.entry_points, ep.func, ep)
  make_shader!(ir, fdef, interface, variables)
end

"""
Wrap a given function definition for use in a shader.

All function arguments will be filled with global variables.
The provided interface describes storage locations and decorations for those global variables.

It is assumed that the function arguments are typed to use the same storage classes.
"""
function make_shader!(ir::IR, fdef::FunctionDefinition, interface::ShaderInterface, variables)
  add_variable_decorations!(ir, variables, interface)
  emit_types!(ir)
  add_type_metadata!(ir, interface)

  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)
  restructure_loop_header_conditionals!(ir)

  ir
end

function define_entry_point!(mt::ModuleTarget, tr::Translation, fdef::FunctionDefinition, model::ExecutionModel, options::ShaderExecutionOptions)
  main = FunctionDefinition(FunctionType(VoidType(), []))
  ep = EntryPoint(:main, emit!(mt, tr, main), model, [], fdef.global_vars)

  # Fill function body.
  blk = new_block!(main, next!(mt.idcounter))
  # The dictionary loses some of its elements to #undef values.
  #TODO: fix this hack in Dictionaries.jl
  fid = findfirst(==(fdef), mt.fdefs.forward)
  push!(blk, @ex next!(mt.idcounter) = OpFunctionCall(fid)::fdef.type.rettype)
  push!(blk, @ex OpReturn())

  model == ExecutionModelFragment && return add_options!(ep, options::FragmentExecutionOptions)
  model == ExecutionModelGeometry && return add_options!(ep, options::GeometryExecutionOptions)
  model in (ExecutionModelTessellationControl, ExecutionModelTessellationEvaluation) && return add_options!(ep, options::TessellationExecutionOptions)
  model == ExecutionModelGLCompute && return add_options!(ep, options::ComputeExecutionOptions)
  model in (ExecutionModelMeshNV, ExecutionModelMeshEXT) && return add_options!(ep, options::MeshExecutionOptions)
  add_options!(ep, options::CommonExecutionOptions)
end

function add_variable_decorations!(ir::IR, variables, interface::ShaderInterface)
  for (i, decs) in pairs(interface.variable_decorations)
    merge_metadata!(ir, ir.global_vars[variables[i]], Metadata(decs))
  end
end

function add_type_metadata!(ir::IR, interface::ShaderInterface)
  for (target, meta) in pairs(interface.type_metadata)
    merge_metadata!(ir, ir.types[ir.tmap[target]], meta)
  end
end
