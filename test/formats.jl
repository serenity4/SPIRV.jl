using Vulkan: Vk

@testset "Image formats" begin
  spv_formats = [getproperty(SPIRV, prop) for prop in names(SPIRV, all = true) if !isnothing(match(r"ImageFormat\w+", string(prop)))]
  vk_formats = Vk.Format.(spv_formats)
  @test vk_formats isa Vector{Vk.Format}
  @test length(unique(vk_formats)) == length(spv_formats)
  @test SPIRV.ImageFormat.(vk_formats) == spv_formats
end;
