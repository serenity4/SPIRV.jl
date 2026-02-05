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
  max_vertices::UInt32 = 0
end

Base.@kwdef struct TessellationExecutionOptions <: ShaderExecutionOptions
  common::CommonExecutionOptions = CommonExecutionOptions()
  spacing::Symbol = :equal
  vertex_order::Symbol = :cw
  point_mode::Bool = false
  generate::Symbol = :triangles
  max_vertices::Optional{UInt32} = nothing
end

struct MeshExecutionOptions <: ShaderExecutionOptions
  common::CommonExecutionOptions
  local_size::Union{NTuple{3,UInt32},NTuple{3,ResultID}}
  output::Symbol
  max_vertices::UInt32
  max_primitives::UInt32
end

function MeshExecutionOptions(; common::CommonExecutionOptions = CommonExecutionOptions(),
                                   local_size::NTuple{3, <:Union{ResultID, Integer}} = (8, 8, 1),
                                   output::Symbol = :points,
                                   max_vertices::Integer = 1,
                                   max_primitives::Integer = 1)
  eltype(local_size) !== ResultID && (local_size = UInt32.(local_size))
  MeshExecutionOptions(common, local_size, output, max_vertices, max_primitives)
end


function ShaderExecutionOptions(model::ExecutionModel)
  model == ExecutionModelFragment && return FragmentExecutionOptions()
  model == ExecutionModelGeometry && return GeometryExecutionOptions()
  model == ExecutionModelGLCompute && return ComputeExecutionOptions()
  model in (ExecutionModelTessellationControl, ExecutionModelTessellationEvaluation) && return TessellationExecutionOptions()
  model in (ExecutionModelMeshNV, ExecutionModelMeshEXT) && return MeshExecutionOptions()
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

function add_local_size!(ep::EntryPoint, options::ShaderExecutionOptions)
  (; local_size) = options
  isa(local_size, NTuple{3,UInt32}) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeLocalSize, local_size...))
  isa(local_size, NTuple{3,ResultID}) && push!(ep.modes, @inst ExecutionModeId(ep.func, ExecutionModeLocalSizeId, local_size...))
end

function add_options!(ep::EntryPoint, options::ComputeExecutionOptions)
  add_options!(ep, options.common)
  add_local_size!(ep, options)
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
  !isnothing(options.max_vertices) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputVertices, options.max_vertices))
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
  !isnothing(options.max_vertices) && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputVertices, options.max_vertices))
  ep
end

function validate(options::MeshExecutionOptions)
  check_value(options, :output, (:points, :lines, :triangles))
end

function add_options!(ep::EntryPoint, options::MeshExecutionOptions)
  add_options!(ep, options.common)
  options.output === :points && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputPoints))
  options.output === :lines && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputLinesEXT))
  options.output === :triangles && push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputTrianglesEXT))
  push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputVertices, options.max_vertices))
  push!(ep.modes, @inst ExecutionMode(ep.func, ExecutionModeOutputPrimitivesEXT, options.max_primitives))
  add_local_size!(ep, options)
  ep
end

function validate_options_type(options::ShaderExecutionOptions, execution_model::ExecutionModel, T::DataType)
  isa(options, T) || throw(InvalidExecutionOptions("The type of shader execution options ($(typeof(options))) does not match the requested execution model `$execution_model`. Execution options are expected to be of type `$T`.", options))
  true
end

function validate(options::ShaderExecutionOptions, execution_model::ExecutionModel)
  validate(options)
  execution_model == ExecutionModelFragment && return validate_options_type(options, execution_model, FragmentExecutionOptions)
  execution_model == ExecutionModelGLCompute && return validate_options_type(options, execution_model, ComputeExecutionOptions)
  execution_model == ExecutionModelGeometry && return validate_options_type(options, execution_model, GeometryExecutionOptions)
  if execution_model in (ExecutionModelTessellationControl, ExecutionModelTessellationEvaluation)
    execution_model === ExecutionModelTessellationEvaluation && check_value(options, :max_vertices, (nothing,))
    return validate_options_type(options, execution_model, TessellationExecutionOptions)
  end
  execution_model in (ExecutionModelMeshNV, ExecutionModelMeshEXT) && return validate_options_type(options, execution_model, MeshExecutionOptions)
  validate_options_type(options, execution_model, CommonExecutionOptions)
end
