@testset "PyBaMM interface" begin
    @test_throws ArgumentError get_scalar_parameters(nothing)
    @test_throws ArgumentError get_function_parameters(nothing)

    if BatteryDynamics.pybamm() === nothing
        @warn "PyBaMM is unavailable; asserting graceful degradation only."

        @test get_available_parameter_sets() == String[]
        @test get_pybamm_parameter_set("Chen2020") === nothing
    else
        available_sets = get_available_parameter_sets()
        @test !isempty(available_sets)
        @test "Chen2020" in available_sets

        params = get_pybamm_parameter_set("Chen2020")
        @test params !== nothing

        scalars = get_scalar_parameters(params)
        @test scalars isa Dict{String, Float64}
        @test haskey(scalars, "Electrode height [m]")
        @test scalars["Electrode height [m]"] > 0

        functions = get_function_parameters(params)
        @test functions isa Dict{String, Function}
        @test haskey(functions, "Negative electrode OCP [V]")

        ocp = functions["Negative electrode OCP [V]"](0.5)
        @test isfinite(ocp)
        @test 0.0 < ocp < 2.0

        @test get_pybamm_parameter_set("NotARealParameterSet") === nothing
    end
end
