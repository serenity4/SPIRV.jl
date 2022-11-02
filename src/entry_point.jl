@refbroadcast mutable struct EntryPoint
  name::Symbol
  func::ResultID
  model::ExecutionModel
  modes::Vector{Instruction}
  interfaces::Vector{ResultID}
end
