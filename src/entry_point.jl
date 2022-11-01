@refbroadcast mutable struct EntryPoint
  name::Symbol
  func::SSAValue
  model::ExecutionModel
  modes::Vector{Instruction}
  interfaces::Vector{SSAValue}
end
