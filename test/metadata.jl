using SPIRV, Test
using SPIRV: append_decorations!, append_debug_annotations!

@testset "Metadata" begin
  @testset "Decoration interface" begin
    decs = Decorations()
    @test !has_decoration(decs, SPIRV.DecorationOffset)
    @test !has_decoration(decs, SPIRV.DecorationBlock)
    decorate!(decs, SPIRV.DecorationOffset, 4)
    decorate!(decs, SPIRV.DecorationBlock)
    @test has_decoration(decs, SPIRV.DecorationOffset)
    @test has_decoration(decs, SPIRV.DecorationBlock)
    @test decs.offset == 4

    meta = Metadata()
    @test !isdefined(meta, :decorations)
    @test !has_decoration(meta, SPIRV.DecorationOffset)
    @test !has_decoration(meta, SPIRV.DecorationBlock)
    @test isnothing(decorations(meta))
    decorate!(meta, SPIRV.DecorationOffset, 4)
    decorate!(meta, SPIRV.DecorationBlock)
    @test has_decoration(meta, SPIRV.DecorationOffset)
    @test has_decoration(meta, SPIRV.DecorationBlock)
    decs = decorations(meta)
    @test decs isa Decorations
    @test decs.offset == 4

    @test !has_decoration(meta, 1, SPIRV.DecorationOffset)
    @test !has_decoration(meta, 1, SPIRV.DecorationBlock)
    @test isnothing(decorations(meta, 1))
    decorate!(meta, 1, SPIRV.DecorationOffset, 8)
    decorate!(meta, 1, SPIRV.DecorationBlock)
    @test has_decoration(meta, 1, SPIRV.DecorationOffset)
    @test has_decoration(meta, 1, SPIRV.DecorationBlock)
    decs = decorations(meta, 1)
    @test decs isa Decorations
    @test decs.offset == 8
  end

  @testset "Instructions" begin
    insts = Instruction[]
    decs = Decorations()
    id = SSAValue(1)
    append_decorations!(insts, id, decs)
    @test isempty(insts)
    decorate!(decs, SPIRV.DecorationOffset, 4)
    decorate!(decs, SPIRV.DecorationBlock)
    append_decorations!(insts, id, decs)
    @test !isempty(insts)
    @test insts[1] == @inst SPIRV.OpDecorate(id, SPIRV.DecorationBlock)
    @test insts[2] == @inst SPIRV.OpDecorate(id, SPIRV.DecorationOffset, 4U)
    @test length(insts) == 2

    meta = Metadata()
    insts = Instruction[]
    id = SSAValue(1)
    append_decorations!(insts, id, meta)
    @test isempty(insts)
    decorate!(meta, SPIRV.DecorationOffset, 4)
    decorate!(meta, SPIRV.DecorationBlock)
    append_decorations!(insts, id, meta)
    @test !isempty(insts)
    @test insts == [
      (@inst SPIRV.OpDecorate(id, SPIRV.DecorationBlock)),
      (@inst SPIRV.OpDecorate(id, SPIRV.DecorationOffset, 4U)),
    ]
    decorate!(meta, 1, SPIRV.DecorationOffset, 4)
    decorate!(meta, 1, SPIRV.DecorationBlock)
    insts = Instruction[]
    append_decorations!(insts, id, meta)
    @test insts == [
      (@inst SPIRV.OpDecorate(id, SPIRV.DecorationBlock)),
      (@inst SPIRV.OpDecorate(id, SPIRV.DecorationOffset, 4U)),
      (@inst SPIRV.OpMemberDecorate(id, 0U, SPIRV.DecorationBlock)),
      (@inst SPIRV.OpMemberDecorate(id, 0U, SPIRV.DecorationOffset, 4U)),
    ]
    insts = Instruction[]
    meta = Metadata(:debug)
    append_debug_annotations!(insts, id, meta)
    @test insts == [@inst SPIRV.OpName(id, "debug")]
    insts = Instruction[]
    meta = Metadata()
    set_name!(meta, 1, :debug)
    append_debug_annotations!(insts, id, meta)
    @test insts == [@inst SPIRV.OpMemberName(id, 0U, "debug")]
  end

  @testset "Merging & .decorate! syntax" begin
    x = Decorations(SPIRV.DecorationOffset, 4).
      decorate!(SPIRV.DecorationBlock)

    y = Decorations(SPIRV.DecorationBinding, 1).
      decorate!(SPIRV.DecorationLocation, 2)

    for z in (merge(x, y), (merge!(x, y); x))
      @test has_decoration(z, SPIRV.DecorationOffset)
      @test has_decoration(z, SPIRV.DecorationBlock)
      @test has_decoration(z, SPIRV.DecorationLocation)
      @test has_decoration(z, SPIRV.DecorationBinding)
      @test length(z.defined) == 4
      @test z.offset == 4
      @test z.binding == 1
      @test z.location == 2
    end

    x = Metadata(:x).
      decorate!(SPIRV.DecorationOffset, 4).
      decorate!(1, SPIRV.DecorationOffset, 12)

    y = Metadata(:y).
      decorate!(SPIRV.DecorationOffset, 8).
      set_name!(1, :y1).
      decorate!(1, SPIRV.DecorationComponent, 2)

    for z in (merge(x, y), (merge!(x, y); x))
      @test has_decoration(z, SPIRV.DecorationOffset)
      @test has_decoration(z, 1, SPIRV.DecorationOffset)
      @test has_decoration(z, 1, SPIRV.DecorationComponent)
      @test decorations(z).offset == 8
      @test decorations(z, 1).offset == 12
      @test decorations(z, 1).component == 2
      @test z.name == :y
      @test z.member_metadata[1].name == :y1
    end
  end
end;
