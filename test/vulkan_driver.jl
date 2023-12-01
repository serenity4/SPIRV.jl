# Set libname for the loader (must be done before importing Vulkan).
# This is mandatory in cases where the default libname used by VulkanCore does not point to a valid Vulkan library.
import SwiftShader_jll
ENV["JULIA_VULKAN_LIBNAME"] = basename(SwiftShader_jll.libvulkan)
using Vulkan: Vk, set_driver
# Use SwiftShader for testing.
# XXX: Do that only when we support execution with it.
# set_driver(:SwiftShader)
