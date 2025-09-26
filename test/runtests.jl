using Revise
using BatteryDynamics
using Test

include("test_pybamm_interface.jl")


@testset "BatteryDynamics.jl" begin # test the BatteryDynamics.jl package

    filename = "test/OCV_20Si50Gr.json"
    if isfile(filename)
        df, meta_data = read_ocv_data("test/OCV_20Si50Gr.json")
        @test round(df.state_of_lithiation[1], digits=3) == 0.002
        @test meta_data.active_material[1] == "20Si50Gr"    
    else
        @warn "Test file $filename not found; skipping related tests."
    end

    @test test_pybamm_interface()
     

end
