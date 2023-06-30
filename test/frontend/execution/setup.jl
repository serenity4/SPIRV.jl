using Lava

instance, device = init(; with_validation = true)

DISPATCH_SIZE = (1, 1, 1)

function execute_shader(shader::Shader, device::Device)
  prog = Program(shader)
  dispatch = Dispatch(DISPATCH_SIZE)
  command_1 = compute_command(
    dispatch,
    prog,
    ²(),
    @resource_dependencies begin
      @read agents::Buffer::Physical
      @write forces::Buffer::Physical
    end
  )
end
