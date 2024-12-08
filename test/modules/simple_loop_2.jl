Bool = TypeBool()
Int32 = TypeInt(32, true)
Float32 = TypeFloat(32)
PtrInt32 = TypePointer(SPIRV.StorageClassFunction, Int32)
c_1f0 = Constant(1f0)::Float32
c_1 = Constant(Int32(1))::Int32
c_5f0 = Constant(5f0)::Float32

@function f(x::Int32, y::Int32)::Float32 begin
  b1 = Label()
  x_plus_y = IAdd(x, y)::Int32
  to_b3 = SLessThan(x_plus_y, c_1)::Bool
  SelectionMerge(b3, SPIRV.SelectionControlNone)
  BranchConditional(to_b3, b3, b2)

  b2 = Label()
  ReturnValue(c_1f0)

  b3 = Label()
  x_plus_y_float = ConvertSToF(x_plus_y)::Float32
  z = FAdd(x_plus_y_float, c_1f0)::Float32
  z2 = FSub(z, c_5f0)::Float32
  z_int = ConvertFToS(z2)::Int32
  v = Variable(SPIRV.StorageClassFunction)::PtrInt32
  Store(v, z_int)
  Branch(loop_header_block)

  loop_header_block = Label()
  _v = Load(v)::Int32
  cond = SLessThan(_v, c_1)::Bool
  LoopMerge(loop_merge_block, loop_continue_target, SPIRV.LoopControlNone)
  BranchConditional(cond, loop_body, loop_merge_block)

  loop_body = Label()
  Branch(loop_continue_target)

  loop_continue_target = Label()
  _v2 = Load(v)::Int32
  next_v = IAdd(_v2, c_1)::Int32
  Store(v, next_v)
  Branch(loop_header_block)

  loop_merge_block = Label()
  _v3 = OpLoad(v)::Int32
  v_float = ConvertSToF(_v3)::Float32
  ReturnValue(v_float)
end
