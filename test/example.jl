using SPIRV

add(x, y) = x + y

add_shader = SPIRV.compile(add, (Int32,Int32), ExecutionModelFragment)
