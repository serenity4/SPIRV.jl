var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"warning: Warning\nThis section is incomplete. Readers are kindly encouraged to go through the tests and source code for more information about the API usage.","category":"page"},{"location":"api/","page":"API","title":"API","text":"","category":"page"},{"location":"api/","page":"API","title":"API","text":"Modules = [SPIRV]\nPrivate = false","category":"page"},{"location":"api/#SPIRV.AnnotatedModule","page":"API","title":"SPIRV.AnnotatedModule","text":"Module annotated with instruction ranges for each logical SPIR-V section, suitable for read-only operations and analyses.\n\nAny desired modifications of annotated modules should be staged and applied via a Diff.\n\nwarn: Warn\nThis module should not be modified, and in particular must not have its structure affected in any way by the insertion or removal of instructions. Modifications can cause the annotations to become out of sync with the updated state of the module, yielding undefined behavior.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.ControlTree","page":"API","title":"SPIRV.ControlTree","text":"Control tree.\n\nThe leaves are labeled as REGION_BLOCK regions, with the distinguishing property that they have no children.\n\nChildren nodes of any given subtree are in reverse postorder according to the original control-flow graph.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.DeltaGraph","page":"API","title":"SPIRV.DeltaGraph","text":"Graph whose vertices and edges remain identical after deletion of other vertices.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.IR","page":"API","title":"SPIRV.IR","text":"Intermediate representation of SPIR-V modules.\n\nThe types and constants mappings can be updated at any time without explicitly notifying of the mutation behavior (i.e. functions may not end with !), so long as additions only are performed. Such additions are currently done upon construction of GlobalsInfo. The ID counter can also be incremented without notice.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.Image","page":"API","title":"SPIRV.Image","text":"SPIR-V image type.\n\nType parameters:\n\nFormat: SPIR-V ImageFormat enumerated value.\nDim: SPIR-V Dim enumerated value.\nDepth: 64-bit integer with value 0 (not a depth image), 1 (depth image) or 2 (unknown).\nArrayed: Bool indicating whether the image is a layer of an image array.\nMS: Bool indicating whether the image is multisampled.\nSampled: 64-bit integer with value 0 (unknown), 1 (may be sampled) or 2 (read-write, no sampling).\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.Instruction","page":"API","title":"SPIRV.Instruction","text":"Parsed SPIR-V instruction. It represents an instruction of the form %result_id = %opcode(%arguments...)::%type_id.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.LayoutStrategy","page":"API","title":"SPIRV.LayoutStrategy","text":"Layout strategy used to compute alignments, offsets and strides.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.NativeLayout","page":"API","title":"SPIRV.NativeLayout","text":"\" Julia layout, with a special handling of mutable fields for composite types.\n\nMutable fields are stored as 8-byte pointers in Julia, but in SPIR-V there is no such concept of pointer. Therefore, we treat mutable fields as if they were fully inlined - that imposes a few restrictions on the behavior of such mutable objects, but is necessary to keep some form of compatibility with GPU representations. The alternative would be to completely disallow structs which contain mutable fields.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.PhysicalInstruction","page":"API","title":"SPIRV.PhysicalInstruction","text":"SPIR-V instruction in binary format.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.PhysicalModule","page":"API","title":"SPIRV.PhysicalModule","text":"SPIR-V module, as a series of headers followed by a stream of instructions. The header embeds two magic numbers, one for the module itself and one for the tool that generated it (e.g. glslang). It also contains the version of the specification applicable to the module, the maximum ID number and an optional instruction schema.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.Pointer","page":"API","title":"SPIRV.Pointer","text":"Pointer that keeps its parent around to make sure its contents stay valid.\n\nUsed to represent the mutability of data structures in the type domain.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.Pointer-Union{Tuple{UInt64}, Tuple{T}} where T","page":"API","title":"SPIRV.Pointer","text":"Reconstruct a pointer from a memory address.\n\n\n\n\n\n","category":"method"},{"location":"api/#SPIRV.ResultID","page":"API","title":"SPIRV.ResultID","text":"Result ID used in a SPIR-V context, following single static assignment rules for valid modules.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.SPIRVTarget","page":"API","title":"SPIRV.SPIRVTarget","text":"SPIR-V target for compilation through the Julia frontend.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.ShaderLayout","page":"API","title":"SPIRV.ShaderLayout","text":"Shader-compatible layout strategy, where layout information is strictly read from shader decorations.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.StructType","page":"API","title":"SPIRV.StructType","text":"SPIR-V aggregate type.\n\nEquality is defined in terms of identity, since different aggregate types have in principle different semantics.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.SupportedFeatures","page":"API","title":"SPIRV.SupportedFeatures","text":"Extensions and capabilities supported by a client API.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.TypeMetadata","page":"API","title":"SPIRV.TypeMetadata","text":"Type metadata meant to be analyzed and modified to generate appropriate decorations.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.VulkanLayout","page":"API","title":"SPIRV.VulkanLayout","text":"Vulkan-compatible layout strategy.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.disassemble-Tuple{IO, SPIRV.Module}","page":"API","title":"SPIRV.disassemble","text":"disassemble(io, spir_module)\n\nTransform the content of spir_module into a human-readable format and prints it to io.\n\n\n\n\n\n","category":"method"},{"location":"api/#SPIRV.spir_type","page":"API","title":"SPIRV.spir_type","text":"Get a SPIR-V type from a Julia type, caching the mapping in the IR if one is provided.\n\nIf wrap_mutable is set to true, then a pointer with class StorageClassFunction will wrap the result.\n\n\n\n\n\n","category":"function"},{"location":"api/#SPIRV.@load-Tuple{Any}","page":"API","title":"SPIRV.@load","text":"@load address::T\n@load address[index]::T\n\nLoad a value of type T, either directly (if no index is specified) or at index - 1 elements from address. address should be a device address, i.e. a UInt64 value representing the address of a physical storage buffer.\n\nnote: Note\nAlthough @load address::T and @load address[1]::T look semantically the same, you should use whichever is appropriate given the underlying data; if you have an array pointer, use the latter, and if you have a pointer to a single element, use the former. Otherwise, executing this on the CPU will most likely crash if attempted with a T that is a mutable type, because mutable elements are stored as object pointers in arrays, requiring an extra bit of indirection that is expressed by @load address[1]::T if one wants to get the correct address.\n\n\n\n\n\n","category":"macro"},{"location":"api/#SPIRV.@store","page":"API","title":"SPIRV.@store","text":"@store value address::T\n@store value address[index]::T\n@store address::T = value\n@store address[index]::T = value\n\nStore a value of type T at the given address, either directly (if no index is specified) or at an offset of index - 1 elements from address.\n\nIf value is not of type T, a conversion will be attempted.\n\naddress should be a device address, i.e. a UInt64 value representing the address of a physical storage buffer.\n\n\n\n\n\n","category":"macro"},{"location":"intro/#Introduction","page":"Introduction","title":"Introduction","text":"","category":"section"},{"location":"intro/","page":"Introduction","title":"Introduction","text":"SPIR-V defines a binary format for GPU code. It is an intermediate representation (IR), similar in surface to LLVM IR for CPUs. It contains two major subsets, one being used by compute APIs (such as OpenCL and OneAPI), the other being used by graphics APIs (Vulkan and OpenGL, mostly). The two are incompatible with each other, but have enough overlap that they are expressed within the same format.","category":"page"},{"location":"intro/","page":"Introduction","title":"Introduction","text":"While most GPUs models expose a common vendor-specific assembly-like IR for compute APIs (such as PTX for NVIDIA and GCN for AMD), shaders used by graphics APIs rarely map to any clearly-defined assembly language. Notably, the way graphics shaders are run on the GPU is very often GPU-specific, not only specific to vendors but also to GPU models and architectures.","category":"page"},{"location":"intro/","page":"Introduction","title":"Introduction","text":"In the world of graphics, SPIR-V is the closest that one can get to an assembly language for most GPUs. This is partly owed to the fact that graphics shaders come with a lot of state, and a shader can in most cases be thought of a program and an execution environment bundled together. As a consequence, SPIR-V defines a format for specifying both the program and its execution environment through the use of features and special intrinsics.","category":"page"},{"location":"intro/","page":"Introduction","title":"Introduction","text":"This disparity between compute IRs and the lack of proper graphics IRs make it so that SPIR-V maps well to LLVM IR only for its compute subset. To understand that, graphics rendering rely a lot on shader-specific notions at the hardware level, like uniform buffers, textures, attachments, push constants, and more. This is difficult to properly express with LLVM IR, because those notions are only related to graphics processing; in fact, they are relevant mainly to speed up graphics rendering by expressing semantics that map to specialized hardware features.","category":"page"},{"location":"intro/","page":"Introduction","title":"Introduction","text":"This library currently targets the Vulkan-flavored version of SPIR-V, aimed at manipulating shaders. However, this library also contains general functionality such as assembling/disassembling SPIR-V, independently of the subset used.","category":"page"},{"location":"ir/#IR","page":"IR","title":"IR","text":"","category":"section"},{"location":"ir/","page":"IR","title":"IR","text":"No transformations are carried out on Julia typed IR.","category":"page"},{"location":"ir/","page":"IR","title":"IR","text":"This typed IR will be translated into unstructured SPIR-V IR by mapping instructions from one IR to the other. This unstructured IR will be restructured by applying the following transformations:","category":"page"},{"location":"ir/","page":"IR","title":"IR","text":"Node cloning to make turn irreducible control-flow into reducible control-flow.\nRestructuring with the help of a control tree from structural analysis. Insertion of selection and loop merge information will be incorporated into the IR.","category":"page"},{"location":"ir/","page":"IR","title":"IR","text":"This will turn SPIR-V IR into a standard format that will be assumed during the rest of the compilation pipeline, including optimizations and final introspection to exhibit implicit shader interfaces (e.g. an unsigned integer converted to a pointer and loaded from). Having a standardized and structured control-flow will enable simplifications and speed-ups in control-flow and data-flow analyses.","category":"page"},{"location":"features/#Features","page":"Features","title":"Features","text":"","category":"section"},{"location":"features/#Reading,-introspecting-into-and-writing-SPIR-V-modules","page":"Features","title":"Reading, introspecting into and writing SPIR-V modules","text":"","category":"section"},{"location":"features/","page":"Features","title":"Features","text":"SPIR-V can be read in its binary format (usually ending in .spv), or can be parsed as a human-understandable format (usually ending in .spvasm).","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"A SPIR-V module can be disassembled to an IO to print a human-understandable output.","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"It can also be assembled to a binary format, usually to be saved on disk or to be used by a consumer of SPIR-V code (e.g. Vulkan).","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"An IR structure is also available to reason about a given SPIR-V module globally, and not just as a stream of instructions. This form is suited for introspection and modification. It can then be converted back to a SPIR-V module. Note that a module converted to an IR which is converted back to a module will not be identical, even if no modification was made to the IR; the ordering of certain instructions (such as debugging instructions) may not be the same, although there will be no change of semantics.","category":"page"},{"location":"features/#Julia-to-SPIR-V-compiler","page":"Features","title":"Julia to SPIR-V compiler","text":"","category":"section"},{"location":"features/","page":"Features","title":"Features","text":"This library contains an experimental Julia to SPIR-V compiler, which only supports Vulkan-flavored SPIR-V. From a SPIR-V perspective, this is a Julia frontend, and from a Julia perspective, this is a SPIR-V backend (as opposed to the traditional LLVM backend used to execute CPU code).","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"warning: Warning\nThis functionality requires Julia 1.9 or higher.","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"This compiler supports:","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"Basic SPIR-V instructions, requiring special types (Arr, Vec, Mat).\nGLSL intrinsics (can be disabled).\nAutomatic computation of layout requirements according to a LayoutStrategy.\nAutomatic declaration of SPIR-V capabilities and extensions based on a user-provided FeatureSupport (see SupportedFeatures to manually specify features).","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"Current outstanding limitations are:","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"Loops are supported, but still considered experimental.\nOnly supports a subset of all possible SPIR-V instructions.\nNo real-world testing yet.","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"Furthermore, this compiler will never support:","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"Calls to any runtime logic (including dynamic dispatch and isa calls, used e.g. in union splitting). SPIR-V does not allow for calling external libraries.\nArbitrary Julia code. Any code used by SPIR-V should be written expressly for that purpose, or at least with a conscious effort to support compilation to SPIR-V.","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"However, any Julia program that you can write in perspective of being compiled to SPIR-V should be executable on the CPU directly, unless they rely on specific features from the SPIR-V execution environment (such as external shader resources).","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"With that in mind, one should note that code that is expected to compile will likely have to be hand-written. Do not expect to compile arbitrary functions.","category":"page"},{"location":"features/","page":"Features","title":"Features","text":"Please understand that this compiler is brittle and immature at the moment.","category":"page"},{"location":"#SPIRV.jl","page":"Home","title":"SPIRV.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Tooling around the manipulation of the binary format SPIR-V defined by the Khronos Group.","category":"page"},{"location":"#Status","page":"Home","title":"Status","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package is currently a work in progress. The source code and public API may change at any moment. Use at your own risk.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"intro.md\", \"api.md\"]","category":"page"},{"location":"devdocs/#Developer-documentation","page":"Developer documentation","title":"Developer documentation","text":"","category":"section"},{"location":"devdocs/#Regenerate-package-files","page":"Developer documentation","title":"Regenerate package files","text":"","category":"section"},{"location":"devdocs/","page":"Developer documentation","title":"Developer documentation","text":"A portion of this package relies on static code generation. To re-generate the files, execute gen/generator.jl in the environment specified in gen:","category":"page"},{"location":"devdocs/","page":"Developer documentation","title":"Developer documentation","text":"julia --color=yes --project=gen -e 'using Pkg; Pkg.instantiate(); include(\"gen/generator.jl\")'","category":"page"}]
}
