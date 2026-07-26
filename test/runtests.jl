using BatteryDynamics
using DataFrames
using Test

@testset "BatteryDynamics.jl" begin
    include("test_ocv_dataframes.jl")
    include("test_pybamm_interface.jl")
end
