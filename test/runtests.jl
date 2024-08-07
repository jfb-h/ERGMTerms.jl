using ERGMTerms
using Test

const el = [Edge(1, 2), Edge(1, 3), Edge(2, 3), Edge(3, 2), Edge(4, 1), Edge(4, 2), Edge(4, 5),]
const g = SimpleDiGraph(el)
const a = [[1], [1], [2], [1, 2], [2]]

@testset "GWESP" begin
    #TODO: Test other specifications
    decay = 0.4
    stat = GWESP(NoGroups(), decay, outneighbors)
    # test against statnet
    s = 3.0
    cs = [2.0, 1.0, 1.0, 1.0, 3.0, 1.0, 1.0, 0.32968, 2.0, 1.0, 1.65936, 0.0, 0.32968, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 0.0]
    @test statistic(stat, g) ≈ s
    @test all(isapprox.(changestats(stat, g), cs; atol=1e-7))

    stat = GWESP(StructuralFold(a), decay, outneighbors)
end

@testset "NodeMatch" begin
    stat = NodeMatch(a)
    cs = changestats(stat, g)
    @test statistic(stat, g) == 4
    @test cs[[1, 3, 6]] == [1, 1, 0]
end

@testset "Reciprocity" begin
    stat = Reciprocity()
    @test statistic(stat, g) == 2
end
