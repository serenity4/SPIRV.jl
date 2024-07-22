function optimize(shader::Shader; binary = false)::Result{Union{Vector{UInt8},Shader}, OptimizationError}
  bytes = @try optimize_shader(shader.ir)
  binary && return bytes
  @set shader.ir = IR(unwrap(bytes))
end

struct OptimizationError <: Exception
  msg::String
end

Base.showerror(io::IO, err::OptimizationError) = print(io, "OptimizationError:\n\n$(err.msg)")

optimize(mod::Module) = optimize(PhysicalModule(mod))
optimize(pmod::PhysicalModule) = optimize_khronos(pmod; flags = ["--target-env=spv1.6"])
optimize(ir::IR) = optimize(Module(work_around_missing_entry_point(ir)))

const OPTIMIZATION_OPTIONS = ScopedValue([
  "-O",
  "--skip-validation",
])

"""
Optimize a SPIR-V module using [Khronos' `spirv-opt` optimizer](https://github.com/KhronosGroup/SPIRV-Tools#optimizer).
"""
function optimize_khronos(pmod::PhysicalModule; flags = [])::Result{Vector{UInt8},OptimizationError}
  input = IOBuffer()
  write(input, pmod)
  seekstart(input)
  output = IOBuffer()
  err = IOBuffer()
  union!(flags, OPTIMIZATION_OPTIONS[])

  try
    run(pipeline(`$spirv_opt $flags - -o -`, stdin = input, stdout = output, stderr = err))
  catch e
    if e isa ProcessFailedException
      return OptimizationError(String(take!(err)))
    else
      rethrow(e)
    end
  end

  take!(output)
end

function optimize_shader(ir::IR; flags = [])
  !isempty(ir.entry_points) || error("At least one entry point must be defined.")
  union!(flags, ["--target-env=vulkan1.3"])
  pmod = PhysicalModule(Module(ir))
  optimize_khronos(pmod; flags)
end
