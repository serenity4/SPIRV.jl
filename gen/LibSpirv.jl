module LibSpirvCross

using CEnum

include("spirv.jl")

# export everything
foreach(names(@__MODULE__, all=true)) do s
   if startswith(string(s), r"spv|SPV|Spv")
      @eval export $s
   end
end

end # module
