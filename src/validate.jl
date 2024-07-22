struct ValidationError <: Exception
  msg::String
end

Base.showerror(io::IO, err::ValidationError) = print(io, "ValidationError:\n\n$(err.msg)")

function validate(mod::Module)
  ret = validate_types(mod)
  iserror(ret) && return ret
  validate(PhysicalModule(mod))
end

function validate_types(mod::Module)::Result{Bool,ValidationError}
  for inst in mod
    for arg in [inst.arguments; filter(!isnothing, [inst.type_id, inst.result_id])]
      T = typeof(arg)
      T in spirv_types || return ValidationError("""
          Argument $(repr(arg)) of type $(repr(T)) is not a SPIR-V type.
          Offending instruction: $(sprintc(emit, inst))
          """)
    end
  end
  true
end

const spirv_types = Set([
  String,
  Int8, Int16, Int32, Int64,
  UInt8, UInt16, UInt32, UInt64,
  Float16, Float32, Float64,
  ResultID,
  collect(enum_types)...,
  OpCode, OpCodeGLSL,
])

validate(pmod::PhysicalModule) = validate_khronos(pmod; flags = ["--target-env", "spv1.6"])

"""
Validate a SPIR-V module using [Khronos' reference validator](https://github.com/KhronosGroup/SPIRV-Tools#validator).
"""
function validate_khronos(pmod::PhysicalModule; flags = [])::Result{Bool,ValidationError}
  input = IOBuffer()
  write(input, pmod)
  seekstart(input)
  err = IOBuffer()

  try
    run(pipeline(`$spirv_val $flags -`, stdin = input, stderr = err))
  catch e
    if e isa ProcessFailedException
      return ValidationError(String(take!(err)))
    else
      rethrow(e)
    end
  end

  true
end

validate(ir::IR) = validate(Module(work_around_missing_entry_point(ir)))
validate(amod::AnnotatedModule) = validate(Module(work_around_missing_entry_point(amod)))

function work_around_missing_entry_point(ir::IR)
  !isempty(ir.entry_points) && return ir
  # Add the Linkage capability to work around the requirement of having at least one entry point.
  ir = @set ir.capabilities = union(ir.capabilities, [CapabilityLinkage])
end

function work_around_missing_entry_point(amod::AnnotatedModule)
  !isempty(amod.entry_points) && return amod
  # Add the Linkage capability to work around the requirement of having at least one entry point.
  for i in amod.capabilities
    inst = amod[i]
    capability = inst.arguments[1]::Capability
    capability === CapabilityLinkage && return amod
  end
  diff = Diff(amod)
  insert!(diff, lastindex(amod.capabilities) => @inst Capability(CapabilityLinkage))
  apply(amod, diff)
end

function validate_shader(ir::IR; flags = [])
  !isempty(ir.entry_points) || error("At least one entry point must be defined.")
  mod = Module(ir)
  ret = validate_types(mod)
  iserror(ret) && return ret
  union!(flags, ["--target-env", "vulkan1.3"])
  pmod = PhysicalModule(mod)
  validate_khronos(pmod; flags)
end
