@testset "read_ocv_data" begin
    filepath = joinpath(@__DIR__, "OCV_20Si50Gr.json")
    @test isfile(filepath)

    ocv_data, meta_data = read_ocv_data(filepath)

    @test names(ocv_data) == [
        "state_of_lithiation",
        "capacity_vector_As",
        "voltage_mean_V",
        "voltage_delithiate_V",
        "voltage_lithiate_V",
        "hysteresis_voltage_V",
    ]
    @test nrow(ocv_data) > 0
    @test round(ocv_data.state_of_lithiation[1], digits=3) == 0.002
    @test meta_data.active_material[1] == "20Si50Gr"

    @test_throws ArgumentError read_ocv_data("")
end

@testset "dataframe_to_dict" begin
    df = DataFrame(a=[1, 2, 3], b=["x", "y", "z"])
    dict = dataframe_to_dict(df)

    @test Set(keys(dict)) == Set(["a", "b"])
    @test dict["a"] == [1, 2, 3]
    @test dict["b"] == ["x", "y", "z"]

    @test_throws ArgumentError dataframe_to_dict(DataFrame())
end
