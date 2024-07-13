let red = Base.text_colors[:red]
  green = Base.text_colors[:green]
  yellow = Base.text_colors[:yellow]
  magenta = Base.text_colors[:magenta]
  salmon = Base.text_colors[168]
  cyan = Base.text_colors[:cyan]
  default = Base.text_colors[:default]

  function arg(type, storage, builtin="", attributes=[])
    str = "$yellow::$type$green::$storage$default"
    isempty(builtin) && isempty(attributes) && return str * cyan
    str *= "$green{"
    !isempty(builtin) && (str *= "$magenta$builtin$default")
    str *= "$salmon"
    start = isempty(builtin)
    for attribute in attributes
      !start && (str *= ", ")
      str *= attribute
      start = false
    end
    str *= "$green}$cyan"
    str
  end
  global DOCSTRING_SIGNATURE_PATTERN = """
  `f($(arg("Type", "StorageClass", "[BuiltIn]", ["[@Decoration [= value]...]"])), ...)`
  """
  global DOCSTRING_SYNTAX_REFERENCE = """
  ## Syntax reference

  The following syntax allows one to annotate function arguments with shader-specific information:

  $DOCSTRING_SIGNATURE_PATTERN

  For each argument, the following is to be provided:
  - *$(yellow)REQUIRED$default* An argument type.
  - *$(green)REQUIRED$default* A SPIR-V [storage class](https://registry.khronos.org/SPIR-V/specs/unified1/SPIRV.html#_storage_class) (required).
  - *$(magenta)OPTIONAL$default* A SPIR-V built-in category, see the [Vulkan built-in variables](https://registry.khronos.org/vulkan/specs/1.3-extensions/html/chap15.html#interfaces-builtin-variables).
  - *$(salmon)OPTIONAL$default* One or more SPIR-V [decorations](https://registry.khronos.org/SPIR-V/specs/unified1/SPIRV.html#_decoration). Arguments to such decorations may be interpolated with `\$`.

  This syntax is processed via [`SPIRV.compile_shader`](@ref).

  ### Examples

  Here are a few examples using the described syntax:

  `@vertex ... f($(arg("Vec4", "Output", "Position")), $(arg("UInt32", "Input", "VertexIndex")))`

  `@fragment ... f($(arg("Vec4", "Input")), $(arg("InvocationData", "PushConstant")))`

  `@fragment ... f($(arg("Vec4", "Output")), $(arg("Vec4", "Input", "FragCoord")), $(arg("Vec2", "Input", "", ["@Flat ..."])))`

  `@compute ... f($(arg("UInt32", "Workgroup")))`

  `@compute ... f($(arg("Arr{256, Float32}", "Workgroup")), $(arg("UInt32", "Input", "LocalInvocationIndex")))`
  """
  @eval function macro_docstring(stage)
    execution_opts = ShaderExecutionOptions(EXECUTION_MODELS[stage])
    name = nameof(typeof(execution_opts))
    execution_opts_default, T = :($name()), name

    other_macros = ["@$other_stage" for other_stage in filter(≠(stage), keys(EXECUTION_MODELS))]

    """
        @$stage supported_features [option = val...] f(::Type1::StorageClass1[{...}], ...)

    Compile the provided signature `f(args...)` into a $stage shader.

    `supported_features` is a [`SPIRV.FeatureSupport`](@ref) structure informing the SPIR-V compiler
    what capabilities and extensions are allowed. In application code, this should generally be a [`SupportedFeatures`](@ref) structure coming from the client API.
    For instance, a package extension for Vulkan.jl exists which provides `SupportedFeatures(physical_device, api_version, device_extensions, device_features)`.

    The supported parameters are the following:
    - `options = $execution_opts_default`: a [`$T`](@ref) structure providing $stage-specific options.
    - `layout = VulkanLayout()`: a [`VulkanLayout`](@ref) to use to compute alignments, strides and offsets in structures and arrays.
    - `cache = nothing`: an optional [`ShaderCompilationCache`](@ref) used to cache [`ShaderSource`](@ref)s to prevent repeated compilation of SPIR-V modules.
    - `interpreter = SPIRVInterpreter()`: a [`SPIRVInterpreter`](@ref) containing method tables and optimization options for the computation. If a cache is provided, this interpreter must be identical to the one used to compile all previous cache entries.
    - `assemble = false`: a boolean flag indicating whether to assemble the resulting module into a [`ShaderSource`](@ref), or leave it as a [`Shader`](@ref) for further introspection. If a cache is provided, `assemble` must be set to `true` for caching to be possible.

    See also: $(join("[`" .* other_macros .* "`](@ref)", ", "))

    # Extended help

    $DOCSTRING_SYNTAX_REFERENCE
    """
  end
end
