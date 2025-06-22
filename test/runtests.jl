using BatteryDynamics
using Test

@testset "BatteryDynamics.jl" begin # test the BatteryDynamics.jl package


    df, meta_data = read_ocv_data("/Users/wdwidanage/Library/CloudStorage/OneDrive-Personal/Data/Battery_Data/OCV_Database/OCV_20Si50Gr.json")
    @test round(df.state_of_lithiation[1], digits=3) == 0.002
    @test meta_data.active_material[1] == "20Si50Gr"


end
