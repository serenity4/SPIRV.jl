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

abstract type ShaderExecutionOptions end

Base.@kwdef struct CommonExecutionOptions <: ShaderExecutionOptions
  xfb::Bool = false
  denorm_preserve::Optional{UInt32} = nothing
  denorm_flush_to_zero::Optional{UInt32} = nothing
  signed_zero_inf_nan_preserve::Optional{UInt32} = nothing
  rounding_mode_rte::Optional{UInt32} = nothing
  rounding_mode_rtz::Optional{UInt32} = nothing
end

Base.@kwdef struct FragmentExecutionOptions <: ShaderExecutionOptions
  common::CommonExecutionOptions = CommonExecutionOptions()
  pixel_center_integer::Bool = false
  origin::Symbol = :upper_left
  early_fragment_tests::Bool = false
  depth_replacing::Bool = false
  depth::Optional{Symbol} = nothing
end

struct ComputeExecutionOptions <: ShaderExecutionOptions
  common::CommonExecutionOptions
  local_size::Union{NTuple{3,UInt32},NTuple{3,ResultID}}
end

function ComputeExecutionOptions(; common::CommonExecutionOptions = CommonExecutionOptions(),
                                 local_size::NTuple{3, <:Union{ResultID, Integer}} = (8, 8, 1))
  eltype(local_size) !== ResultID && (local_size = UInt32.(local_size))
  ComputeExecutionOptions(common, local_size)
end

Base.@kwdef struct GeometryExecutionOptions <: ShaderExecutionOptions
  common::CommonExecutionOptions = CommonExecutionOptions()
  invocations::Optional{UInt32} = nothing
  input::Symbol = :triangles
  output::Symbol = :triangle_strip
  max_output_vertices::Optional{UInt32} = nothing
end

Base.@kwdef struct TessellationExecutionOptions <: ShaderExecutionOptions
  common::CommonExecutionOptions = CommonExecutionOptions()
  spacing::Symbol = :equal
  vertex_order::Symbol = :cw
  point_mode::Bool = false
  generate::Symbol = :triangles
  output_patch_size::Optional{UInt32} = nothing
end

Base.@kwdef struct MeshExecutionOptions <: ShaderExecutionOptions
  common::CommonExecutionOptions = CommonExecutionOptions()
  output::Symbol = :points
  max_output_vertices::Optional{UInt32} = nothing
end

function ShaderExecutionOptions(model::ExecutionModel)
  model == ExecutionModelFragment && return FragmentExecutionOptions()
  model == ExecutionModelGeometry && return GeometryExecutionOptions()
  model == ExecutionModelGLCompute && return ComputeExecutionOptions()
  model in (ExecutionModelTessellationControl, ExecutionModelTessellationEvaluation) && return TessellationExecutionOptions()
  model == ExecutionModelMeshNV && return MeshExecutionOptions()
  CommonExecutionOptions()
end

struct InvalidExecutionOptions <: Exception
  msg::String
  options::ShaderExecutionOptions
end
Base.showerror(io::IO, err::InvalidExecutionOptions) = print(io, "InvalidExecutionOptions: ", err.msg)

function check_value(options::ShaderExecutionOptions, field::Symbol, allowed_values)
  @assert hasproperty(options, field)
  value = getproperty(options, field)
  in(value, allowed_values) && return true
  msg = string("Invalid value `$(repr(value))` detected for option `$(typeof(options))::$field`; allowed values are $(join('`' .* repr.(allowed_values) .* '`', ", "))")
  throw(InvalidExecutionOptions(msg, options))
end

validate(options::CommonExecutionOptions) = true

function add_options!(ep::EntryPoint, options::CommonExecutionOptions)
  options.xfb && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeXfb))
  !isnothing(options.denorm_preserve) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeDenormPreserve, options.denorm_preserve))
  !isnothing(options.denorm_flush_to_zero) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeDenormFlushToZero, options.denorm_flush_to_zero))
  !isnothing(options.signed_zero_inf_nan_preserve) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeSignedZeroInfNanPreserve, options.signed_zero_inf_nan_preserve))
  !isnothing(options.rounding_mode_rte) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeRoundingModeRTE, options.rounding_mode_rte))
  !isnothing(options.rounding_mode_rtz) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeRoundingModeRTZ, options.rounding_mode_rtz))
  ep
end

function validate(options::FragmentExecutionOptions)
  check_value(options, :origin, (:upper_left, :lower_left))
  check_value(options, :depth, (nothing, :greater, :less, :unchanged))
end

function add_options!(ep::EntryPoint, options::FragmentExecutionOptions)
  add_options!(ep, options.common)
  options.pixel_center_integer && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModePixelCenterInteger))
  options.origin === :upper_left && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOriginUpperLeft))
  options.origin === :lower_left && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOriginLowerLeft))
  options.early_fragment_tests && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeEarlyFragmentTests))
  options.depth_replacing && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeDepthReplacing))
  options.depth === :greater && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeDepthGreater))
  options.depth === :less && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeDepthLess))
  options.depth === :unchanged && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeDepthUnchanged))
  ep
end

validate(options::ComputeExecutionOptions) = true

function add_options!(ep::EntryPoint, options::ComputeExecutionOptions)
  add_options!(ep, options.common)
  isa(options.local_size, NTuple{3,UInt32}) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeLocalSize, options.local_size...))
  isa(options.local_size, NTuple{3,ResultID}) && push!(ep.modes, @inst ExecutionModeId(ep.func, ExecutionModeLocalSizeId, options.local_size...))
  ep
end

function validate(options::GeometryExecutionOptions)
  check_value(options, :input, (:points, :lines, :lines_adjancency, :triangles, :triangles_adjacency))
  check_value(options, :output, (:points, :line_strip, :triangle_strip))
end

function add_options!(ep::EntryPoint, options::GeometryExecutionOptions)
  add_options!(ep, options.common)
  !isnothing(options.invocations) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeInvocations, options.invocations))
  options.input === :points && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeInputPoints))
  options.input === :lines && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeInputLines))
  options.input === :lines_adjancency && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeInputLinesAdjacency))
  options.input === :triangles && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeTriangles))
  options.input === :triangles_adjacency && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeInputTrianglesAdjacency))
  options.output === :points && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputPoints))
  options.output === :line_strip && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputLineStrip))
  options.output === :triangle_strip && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputTriangleStrip))
  !isnothing(options.max_output_vertices) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputVertices, options.max_output_vertices))
  ep
end

function validate(options::TessellationExecutionOptions)
  check_value(options, :spacing, (:equal, :fractional_even, :fractional_odd))
  check_value(options, :vertex_order, (:cw, :ccw))
  check_value(options, :generate, (:triangles, :quads, :isolines))
end

function add_options!(ep::EntryPoint, options::TessellationExecutionOptions)
  add_options!(ep, options.common)
  options.spacing === :equal && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeSpacingEqual))
  options.spacing === :fractional_even && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeSpacingFractionalEven))
  options.spacing === :fractional_odd && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeSpacingFractionalOdd))
  options.vertex_order === :cw && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeVertexOrderCw))
  options.vertex_order === :ccw && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeVertexOrderCcw))
  options.point_mode && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModePointMode))
  options.generate === :triangles && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeTriangles))
  options.generate === :quads && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeQuads))
  options.generate === :isolines && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeIsolines))
  !isnothing(options.output_patch_size) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputVertices, options.max_output_vertices))
  ep
end

function validate(options::MeshExecutionOptions)
  check_value(options, :output, (:points,))
end

function add_options!(ep::EntryPoint, options::MeshExecutionOptions)
  add_options!(ep, options.common)
  options.output === :points && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputPoints))
  !isnothing(options.max_output_vertices) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputVertices, options.max_output_vertices))
  ep
end

function validate_options_type(options::ShaderExecutionOptions, execution_model::ExecutionModel, T::DataType)
  isa(options, T) || throw(InvalidExecutionOptions("The type of shader execution options ($(typeof(options))) does not match the requested execution model `$execution_model`. Execution options are expected to be of type `$T`.", options))
  true
end

function validate(options::ShaderExecutionOptions, execution_model::ExecutionModel)
  execution_model == ExecutionModelFragment && return validate_options_type(options, execution_model, FragmentExecutionOptions)
  execution_model == ExecutionModelGLCompute && return validate_options_type(options, execution_model, ComputeExecutionOptions)
  execution_model == ExecutionModelGeometry && return validate_options_type(options, execution_model, GeometryExecutionOptions)
  if execution_model in (ExecutionModelTessellationControl, ExecutionModelTessellationEvaluation)
    execution_model === ExecutionModelTessellationEvaluation && check_value(options, :output_patch_size, (nothing,))
    return validate_options_type(options, execution_model, TessellationExecutionOptions)
  end
  execution_model == ExecutionModelMeshNV && return validate_options_type(options, execution_model, MeshExecutionOptions)
  validate_options_type(options, execution_model, CommonExecutionOptions)
end

struct ShaderInterface
  execution_model::ExecutionModel
  storage_classes::Vector{StorageClass}
  variable_decorations::Dictionary{Int,Decorations}
  type_metadata::Dictionary{DataType, Metadata}
  layout::LayoutStrategy
  features::FeatureSupport
  execution_options::ShaderExecutionOptions
end

function ShaderInterface(execution_model::ExecutionModel; storage_classes = [], variable_decorations = Dictionary(),
  type_metadata = Dictionary(), layout = VulkanLayout(), features = AllSupported(), execution_options = ShaderExecutionOptions(execution_model))
  @assert validate(execution_options, execution_model)
  ShaderInterface(execution_model, storage_classes, variable_decorations, type_metadata, layout, features, execution_options)
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
  model == ExecutionModelMeshNV && return add_options!(ep, options::MeshExecutionOptions)
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
  ep = define_entry_point!(mt, tr, fdef, interface.execution_model, interface.execution_options)
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
