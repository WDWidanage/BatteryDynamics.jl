using BatteryDynamics
using Test

@testset "BatteryDynamics.jl" begin
    # Write your tests here.
    @test BatteryDynamics.multiply() == 12
    @test BatteryDynamics.multiply(2) == 8
    @test BatteryDynamics.multiply(2, 3) == 6
end
