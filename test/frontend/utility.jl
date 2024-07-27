using SPIRV, Test

function loop1_julia(range)
  res = 0F
  for i in range
    res += (i)F
  end
  res
end

function loop1_macro(range)
  res = 0F
  @for i in range begin
    res += (i)F
  end
  res
end

function loop2_julia(range)
  res = 0F
  for i in range
    if res > 5F
      res += 35000F
      continue
    end
    res += (i)F
  end
  res
end

function loop2_macro(range)
  res = 0F
  @for i in range begin
    if res > 5F
      res += 35000F
      continue
    end
    res += (i)F
  end
  res
end

function loop3_julia(range)
  res = 0F
  for i in range
    res > 5F && break
    res += (i)F
  end
  res
end

function loop3_macro(range)
  res = 0F
  @for i in range begin
    res > 5F && break
    res += (i)F
  end
  res
end

function loop4_julia(range)
  res = 0F
  for i in range
    for j in range
      res += (i*j)F
    end
  end
  res
end

function loop4_macro(range)
  res = 0F
  @for i in range begin
    @for j in range begin
      res += (i*j)F
    end
  end
  res
end

function loop4_macro2(range)
  res = 0F
  @for i in range, j in range begin
    res += (i*j)F
  end
  res
end

function loop5_julia(range)
  res = 0F
  for i in range, j in range
    res > 100F && break
    res += (i*j)F
  end
  res
end

function loop5_macro(range)
  res = 0F
  @for i in range, j in range begin
    res > 100F && break
    res += (i*j)F
  end
  res
end

function loop6_julia(range)
  res = 0F
  for i in range
    for j in range
      res > 100F && break
      res += (i*j)F
    end
    res += 1F
  end
  res
end

function loop6_macro(range)
  res = 0F
  @for i in range begin
    @for j in range begin
      res > 100F && break
      res += (i*j)F
    end
    res += 1F
  end
  res
end

@testset "Utilities" begin
  @testset "@for loops" begin
    @testset "Ranges" begin
      ranges = (0U:50U, 4U:-Int32(1):0U, 0F:1.2F:6F, 3:-1:1, 1:1, 6.2:-1.1:1.9)
      for range in ranges
        step = Base.step_hp(range)
        is_hp = sizeof(typeof(step)) > sizeof(eltype(range))
        @test loop1_julia(range) === loop1_macro(range)
        @test loop2_julia(range) === loop2_macro(range)
        if is_hp
          @test loop3_julia(range) ≈ loop3_macro(range)
        else
          @test loop3_julia(range) === loop3_macro(range)
        end
        @test loop4_julia(range) === loop4_macro(range)
        @test loop4_macro(range) === loop4_macro2(range)
        @test loop5_julia(range) === loop5_macro(range)
        @test loop6_julia(range) === loop6_macro(range)
      end
    end
  end
end;
