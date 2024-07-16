module SPIRVVulkanExt

using Dictionaries: dictionary
using MLStyle: @match
using SPIRV
using SPIRV: iscomposite, SpecializationData
using Vulkan: Vk

include("features.jl")
include("formats.jl")
include("shader.jl")
include("specialization.jl")

end
