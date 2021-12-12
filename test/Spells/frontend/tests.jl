using SPIRV

const spv = SPIRV

meta = Metadata(spv.magic_number, 0x0f0f0f0f, v"0.1", 0)

capabilities = [SPIRV.CapabilityShader]
exts = []
extinst_imports = SSADict{Symbol}()
source = SPIRV
memory_model = SPIRV.MemoryModelVulkan
addressing_model = SPIRV.AddressingModelLogical
entry_points = SSADict(SPIRV.EntryPoint(:main, 1, SPIRV.ExecutionModelFragment, []))
types = SSADict()
constants = SSADict{Instruction}()
global_vars = SSADict{Instruction}()
globals = SSADict{Instruction}()
fdefs = SSADict{FunctionDefinition}()
results = SSADict{Any}()

function module()
end

ir = IR(
    meta,

)

