using RasterShadow
using Test
using JLD

@testset "basic input" begin
    flat = ones(20,10)
    flat_sh = shadowing(flat,45,45,1)
    @test size(flat_sh) == size(flat)
    @test flat_sh == ones(20,10)
end

testdata = JLD.load("testdata\\testdata.jld")
dem = testdata["dem"]
@testset "shadowing" begin
    @test testdata["sh_30_30"] == shadowing(dem,30,30,0.5)
    @test testdata["sh_150_80"] == shadowing(dem,150,80,0.5)
    @test testdata["sh_150_80"] == shadowing(dem,150,80,0.5)
end
