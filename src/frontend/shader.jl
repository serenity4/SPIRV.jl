"""
Declare an entry point named `:main` that calls the provided method instance.
"""
function FunctionDefinition(mt::ModuleTarget, name::Symbol)
  for (id, val) in pairs(mt.debug.names)
    if val == name && haskey(mt.fdefs, id)
      return mt.fdefs[id]
    end
  end
  error("No function named '$name' could be found.")
end

FunctionDefinition(mt::ModuleTarget, mi::MethodInstance) = FunctionDefinition(mt, make_name(mi))

struct ShaderInterface
  execution_model::ExecutionModel
  storage_classes::Vector{StorageClass}
  variable_decorations::Dictionary{Int,Decorations}
  type_metadata::Dictionary{DataType, Metadata}
  layout::LayoutStrategy
  features::FeatureSupport
  function ShaderInterface(execution_model::ExecutionModel, storage_classes = [], variable_decorations = Dictionary(),
    type_metadata = Dictionary(), layout = VulkanLayout(), features = AllSupported())
    new(execution_model, storage_classes, variable_decorations, type_metadata, layout, features)
  end
end

function ShaderInterface(; execution_model = ExecutionModelVertex, storage_classes = [], variable_decorations = Dictionary(),
  type_metadata = Dictionary(), layout = VulkanLayout(), features = AllSupported())
  ShaderInterface(execution_model, storage_classes, variable_decorations, type_metadata, layout, features)
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
  add_type_layouts!(ir, interface.layout)
  add_type_metadata!(ir, interface)
  add_align_operands!(ir, fdef, interface.layout)

  restructure_merge_blocks!(ir)
  add_merge_headers!(ir)

  satisfy_requirements!(ir, interface.features)
  ir
end

function define_entry_point!(mt::ModuleTarget, tr::Translation, fdef::FunctionDefinition, execution_model::ExecutionModel)
  main = FunctionDefinition(FunctionType(VoidType(), []))
  ep = EntryPoint(:main, emit!(mt, tr, main), execution_model, [], fdef.global_vars)

  # Fill function body.
  blk = new_block!(main, next!(mt.idcounter))
  # The dictionary loses some of its elements to #undef values.
  #TODO: fix this hack in Dictionaries.jl
  fid = findfirst(==(fdef), mt.fdefs.forward)
  push!(blk, @ex next!(mt.idcounter) = OpFunctionCall(fid)::fdef.type.rettype)
  push!(blk, @ex OpReturn())

  execution_model == ExecutionModelFragment && push!(ep.modes, @inst OpExecutionMode(ep.func, ExecutionModeOriginUpperLeft))
  ep
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

struct MemoryResource
  address::ResultID
  type::ResultID
end

struct Shader
  mod::Module
  entry_point::ResultID
  memory_resources::ResultDict{MemoryResource}
end

Module(shader::Shader) = shader.mod

validate(shader::Shader) = validate_shader(IR(Module(shader); satisfy_requirements = false))

function Shader(target::SPIRVTarget, interface::ShaderInterface)
  ir = IR(target, interface)
  ep = entry_point(ir, :main).func
  mod = Module(ir)
  Shader(renumber_ssa(mod), ep, memory_resources(ir, ep))
end

assemble(shader::Shader) = assemble(shader.mod)

function IR(target::SPIRVTarget, interface::ShaderInterface)
  mt = ModuleTarget()
  tr = Translation()
  variables = Dictionary{Int,Variable}()
  for (i, sc) in enumerate(interface.storage_classes)
    if sc ≠ StorageClassFunction
      t = spir_type(target.mi.specTypes.parameters[i + 1], tr.tmap; storage_class = sc)
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
  ep = define_entry_point!(mt, tr, fdef, interface.execution_model)
  ir = IR(mt, tr)
  ir.addressing_model = AddressingModelPhysicalStorageBuffer64
  insert!(ir.entry_points, ep.func, ep)
  make_shader!(ir, fdef, interface, variables)
end

struct MemoryResourceExtraction
  conversions::ResultDict{Instruction}
  loaded_addresses::ResultDict{InterpretationFrame}
  resources::ResultDict{MemoryResource}
end

MemoryResourceExtraction() = MemoryResourceExtraction(ResultDict(), Set(), ResultDict())

function (extract::MemoryResourceExtraction)(interpret::AbstractInterpretation, frame::InterpretationFrame)
  nothing
end

function (extract::MemoryResourceExtraction)(interpret::AbstractInterpretation, frame::InterpretationFrame, inst::Instruction)
  @tryswitch opcode(inst) begin
    @case &OpConvertUToPtr
    if !in(inst, extract.conversions)
      insert!(extract.conversions, inst.result_id, inst)
    else
      interpret.converged = true
    end

    @case &OpLoad || &OpAccessChain
    # TODO: Use a def-use chain to make it more robust.
    # For example, one may pass the pointer to a function call
    # and a different ID (associated with an `OpFunctionParameter`) would be used as operand.
    loaded = inst.arguments[1]::ResultID
    c = get(extract.conversions, loaded, nothing)
    !isnothing(c) && insert!(extract.loaded_addresses, c.arguments[1]::ResultID, frame)
  end
end

function memory_resources(ir::IR, fid::ResultID)
  memory_resources = ResultDict{MemoryResource}()
  return memory_resources
  fdef = ir.fdefs[fid]

  #=

  Query:

  Find all defining variables for loaded pointers originating from a conversion from an unsigned integer.

  1. Find pointers that:
    - Are the target of `OpLoad` or `OpAccessChain` instructions.
    - Are traceable to the result of a conversion converted from an unsigned integer.
  2. Iterate through their root variable, by propagating through (standard) pointer instructions and unsigned integer operations that involve constant arguments besides the defining variable.

  =#

  extract = MemoryResourceExtraction()
  interpret(extract, amod, af)
  chains = UseDefChain[]
  for (address, frame) in enumerate(extract.loaded_addresses)
    chain = UseDefChain(amod, frame.af, address, frame.stacktrace)
    for leaf in Leaves(chain)
      inst = nodevalue(leaf)
      opcode(inst) == OpConstant && continue
      insert!(memory_resources, address, MemoryResource(inst.result_id::ResultID, inst.type_id::ResultID))
    end
  end
end
