Bool = TypeBool()
Float32 = TypeFloat(32)
c_0f0 = Constant(0f0)::Float32
c_1f0 = Constant(1f0)::Float32

@function f(x::Bool, y::Bool)::Float32 begin
  b1 = Label()
  SelectionMerge(b3, SPIRV.SelectionControlNone)
  BranchConditional(x, b3, b2)

  b2 = Label()
  ReturnValue(c_1f0)

  b3 = Label()
  Branch(loop_header_block)

  loop_header_block = Label()
  LoopMerge(loop_merge_block, loop_continue_target, SPIRV.LoopControlNone)
  BranchConditional(y, loop_body, loop_merge_block)

  loop_body = Label()
  Branch(loop_continue_target)

  loop_continue_target = Label()
  Branch(loop_header_block)

  loop_merge_block = Label()
  ReturnValue(c_0f0)
end
