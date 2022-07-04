"""
Declare an entry point named `:main` that calls the provided method instance.
"""
function FunctionDefinition(ir::IR, name::Symbol)
  for (id, val) in pairs(ir.debug.names)
    if val == name && haskey(ir.fdefs, id)
      return ir.fdefs[id]
    end
  end
  error("No function named '$name' could be found.")
end

FunctionDefinition(ir::IR, mi::MethodInstance) = FunctionDefinition(ir, make_name(mi))

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
Wrap a given method instance for use in a shader.

All function arguments from the given method instance will be filled with global variables.
The provided interface describes storage locations and decorations for those global variables.

It is assumed that the function arguments are typed to use same storage classes.
"""
function make_shader!(ir::IR, mi::MethodInstance, interface::ShaderInterface, variables)
  fdef = FunctionDefinition(ir, mi)
  main_t = FunctionType(VoidType(), [])
  main = FunctionDefinition(main_t)
  ep = EntryPoint(:main, emit!(ir, main), interface.execution_model, [], fdef.global_vars)
  interface.execution_model == ExecutionModelFragment && push!(ep.modes, @inst OpExecutionMode(ep.func, ExecutionModeOriginUpperLeft))
  insert!(ir.entry_points, ep.func, ep)

  add_variable_decorations!(ir, variables, interface)
  add_type_layouts!(ir, interface.layout)
  add_type_metadata!(ir, interface)
  add_align_operands!(ir, fdef, interface.layout)

  # Fill function body.
  blk = new_block!(main, next!(ir.ssacounter))

  # The dictionary loses some of its elements to #undef values.
  #TODO: fix this hack in Dictionaries.jl
  fid = findfirst(==(fdef), ir.fdefs.forward)

  push!(blk, @inst next!(ir.ssacounter) = OpFunctionCall(fid)::SSAValue(ir, fdef.type.rettype))
  push!(blk, @inst OpReturn())
  satisfy_requirements!(ir, interface.features)
  ep
end

function add_variable_decorations!(ir::IR, variables, interface::ShaderInterface)
  for (i, decs) in pairs(interface.variable_decorations)
    merge_metadata!(ir, ir.global_vars[variables[i]], Metadata(decs))
  end
end

function add_type_metadata!(ir::IR, interface::ShaderInterface)
  for (target, meta) in pairs(interface.type_metadata)
    merge_metadata!(ir, target, meta)
  end
end

function find_definition(id::SSAValue, insts)
  idx = findfirst(has_result_id(id), insts)
  if !isnothing(idx)
    insts[idx]
  end
end

function add_align_operands!(ir::IR, fdef::FunctionDefinition, layout::LayoutStrategy)
  insts = body(fdef)
  for inst in insts
    (; opcode, arguments) = inst
    @tryswitch opcode begin
      @case &OpLoad || &OpStore
      pointer_id = first(inst.arguments)
      def = @something(
        get(ir.global_vars, pointer_id, nothing),
        find_definition(pointer_id, fdef.local_vars),
        find_definition(pointer_id, insts),
      )
      isnothing(def) && error("Could not retrieve definition for $pointer_id")
      pointer = @match def begin
        ::Instruction => ir.types[def.type_id::SSAValue]
        ::Variable => def.type
      end
      (; type, storage_class) = pointer
      if storage_class == StorageClassPhysicalStorageBuffer
        # We assume that no other storage class uses the pointer.
        push!(inst.arguments, MemoryAccessAligned, UInt32(alignment(layout, type, [storage_class], false)))
      end
      @case &OpFunctionCall
      # Recurse into function calls.
      callee = ir.fdefs[first(arguments)]
      add_align_operands!(ir, callee, layout)
    end
  end
end

struct MemoryResource
  address::SSAValue
  type::SSAValue
end

struct Shader
  mod::Module
  entry_point::SSAValue
  memory_resources::SSADict{MemoryResource}
end

Module(shader::Shader) = shader.mod

validate(shader::Shader) = validate_shader(IR(Module(shader); satisfy_requirements = false))

function Shader(target::SPIRVTarget, interface::ShaderInterface)
  ir = IR()
  variables = Dictionary{Int,Variable}()
  for (i, sc) in enumerate(interface.storage_classes)
    if sc ≠ StorageClassFunction
      t = spir_type(target.mi.specTypes.parameters[i + 1], ir; storage_class = sc)
      if sc in (StorageClassPushConstant, StorageClassUniform, StorageClassStorageBuffer)
        decorate!(ir, emit!(ir, t), DecorationBlock)
      end
      ptr_type = PointerType(sc, t)
      var = Variable(ptr_type)
      insert!(variables, i, var)
    end
  end
  compile!(ir, target, variables)
  ep = make_shader!(ir, target.mi, interface, variables)
  mod = Module(ir)
  Shader(mod, ep.func, memory_resources(mod, ep.func))
end

struct MemoryResourceExtraction
  conversions::SSADict{Instruction}
  loaded_addresses::SSADict{InterpretationFrame}
  resources::SSADict{MemoryResource}
end

MemoryResourceExtraction() = MemoryResourceExtraction(SSADict(), Set(), SSADict())

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
    loaded = inst.arguments[1]::SSAValue
    c = get(extract.conversions, loaded, nothing)
    !isnothing(c) && insert!(extract.loaded_addresses, c.arguments[1]::SSAValue, frame)
  end
end

function memory_resources(mod::Module, fid::SSAValue)
  memory_resources = SSADict{MemoryResource}()
  return memory_resources
  amod = annotate(mod)
  af = amod.annotated_functions[find_function(amod, fid)]

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
      insert!(memory_resources, address, MemoryResource(inst.result_id::SSAValue, inst.type_id::SSAValue))
    end
  end
end
