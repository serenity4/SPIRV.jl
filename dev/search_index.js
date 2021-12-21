var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"","category":"page"},{"location":"api/","page":"API","title":"API","text":"Modules = [SPIRV]\nPrivate = false","category":"page"},{"location":"api/#SPIRV.CFG","page":"API","title":"SPIRV.CFG","text":"Control Flow Graph (CFG)\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.DeltaGraph","page":"API","title":"SPIRV.DeltaGraph","text":"Graph whose vertices and edges remain identical after deletion of other vertices.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.Instruction","page":"API","title":"SPIRV.Instruction","text":"Parsed SPIR-V instruction. It represents an instruction of the form %result_id = %opcode(%arguments...)::%type_id.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.PhysicalInstruction","page":"API","title":"SPIRV.PhysicalInstruction","text":"SPIR-V instruction in binary format.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.PhysicalModule","page":"API","title":"SPIRV.PhysicalModule","text":"SPIR-V module, as a series of headers followed by a stream of instructions. The header embeds two magic numbers, one for the module itself and one for the tool that generated it (e.g. glslang). It also contains the version of the specification applicable to the module, the maximum ID number and an optional instruction schema.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.SSAValue","page":"API","title":"SPIRV.SSAValue","text":"SSA value used in a SPIR-V context.\n\nDiffers from Core.SSAValue in that all SPIR-V constructs will use this SSAValue type to differentiate with Julia SSA values.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.StructType","page":"API","title":"SPIRV.StructType","text":"SPIR-V aggregate type.\n\nEquality is defined in terms of identity, since different aggregate types have in principle different semantics.\n\n\n\n\n\n","category":"type"},{"location":"api/#SPIRV.compact_reducible_bbs!-Tuple{Any, Any}","page":"API","title":"SPIRV.compact_reducible_bbs!","text":"Compact reducible basic blocks.\n\n1 -> 2 -> 3 becomes 1\n\n\n\n\n\n","category":"method"},{"location":"api/#SPIRV.disassemble-Tuple{IO, SPIRV.Module}","page":"API","title":"SPIRV.disassemble","text":"disassemble(io, spir_module)\n\nTransform the content of spir_module into a human-readable format and prints it to io.\n\n\n\n\n\n","category":"method"},{"location":"api/#SPIRV.infer!-Tuple{CFG}","page":"API","title":"SPIRV.infer!","text":"Run type inference on the provided CFG and wrap inferred code with a new CFG.\n\nThe internal MethodInstance of the original CFG gets mutated in the process.\n\n\n\n\n\n","category":"method"},{"location":"api/#SPIRV.infer!-Tuple{Core.MethodInstance}","page":"API","title":"SPIRV.infer!","text":"Run type inference on the given MethodInstance.\n\n\n\n\n\n","category":"method"},{"location":"api/#SPIRV.merge_mutually_recursive!-Tuple{Any, Any}","page":"API","title":"SPIRV.merge_mutually_recursive!","text":"Merge mutually recursive blocks into caller.\n\n\n\n\n\n","category":"method"},{"location":"api/#SPIRV.rem_head_recursion!-Tuple{Any, Any}","page":"API","title":"SPIRV.rem_head_recursion!","text":"Remove head-controlled recursion.\n\n\n\n\n\n","category":"method"},{"location":"intro/#Introduction","page":"Introduction","title":"Introduction","text":"","category":"section"},{"location":"#SPIRV.jl","page":"Home","title":"SPIRV.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Tooling around the manipulation of the binary format SPIR-V defined by the Khronos Group.","category":"page"},{"location":"#Status","page":"Home","title":"Status","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package is currently a work in progress. The source code and public API may change at any moment. Use at your own risk.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pages = [\"intro.md\", \"api.md\"]","category":"page"}]
}
