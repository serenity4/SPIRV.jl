using SPIRV, Test

@testset "Pointers" begin
  ptr = Pointer(Ref(5))
  @test ptr[] == 5
  ptr = Pointer(Ref((1, 2, 3)))
  @test ptr[2] == 2

  arr = [1, 2]
  GC.@preserve arr begin
    p = pointer(arr)
    ptr = Pointer{Vector{Int64}}(convert(UInt, p))
    @test eltype(ptr) == Vector{Int64}
    @test ptr[1] == 1
    @test ptr[2] == 2
  end
end
