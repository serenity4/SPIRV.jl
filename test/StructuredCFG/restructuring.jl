@testset "CFG restructuring" begin
    @testset "Merge return nodes" begin
        cfg = CFG(f, Tuple{Float64})
        restructured = merge_return_blocks(cfg)
        verify(restructured)
    end
end
