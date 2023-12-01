mutable struct MutableTest1
  x::Int32
  y::UInt32
end

mutable struct MutableTest2
  a::Float32
  b::MutableTest1
end

@testset "Mutability tests" begin
  @test execute(quote
    x = Vec3(1F, 2F, 3F)
    y = Vec3(4F, 5F, 6F)
    y[] = x
    y.y
  end) === 2F

  @test execute(quote
    x = MutableTest1(1, 2)
    y = MutableTest1(3, 4)
    y.x = 5
    (x.y, y.x)
  end) === (UInt32(2), Int32(5))

  @test execute(quote
    x = MutableTest1(3, 4)
    a = MutableTest2(2.0, x)
    a.a = 5.0
    a.a
  end) === 5f0

  @test_throws "`setfield!` not supported at the moment" execute(quote
    x = MutableTest1(3, 4)
    a = MutableTest2(2.0, x)
    a.b.x = 5
    a.b.x
  end) === Int32(5)

  @test_throws "`setfield!` not supported at the moment" execute(quote
    x = MutableTest1(3, 4)
    a = MutableTest2(2.0, x)
    (; b) = a
    b.x = 5
    a.b.x
  end) === Int32(5)

  @test execute(quote
    x = Ref(one(Vec2))
    x.x = 2 .* one(Vec2)
    x.x
  end) == Vec2(2, 2)

  @test execute(quote
    x = Ref(one(Vec2))
    v = x.x
    v.x = 2
    x.x.x
  end) === 2f0
end;
