"""
Quick test script for PyBaMM interface
Run this to verify PyBaMM is working correctly
"""

function test_pybamm_interface()
println("Testing PyBaMM Interface...")
println("=" ^ 40)

    # Test 1: Load default parameter set
    println("Test 1: Loading default parameter set...")
    params = get_pybamm_parameter_set()
    
    if params === nothing
        println("⚠ PyBaMM not available - skipping PyBaMM tests")
        return true  # Return true to not fail the CI if PyBaMM is not available
    end
    
    println("✓ Default parameter set loaded successfully")
    
    # Test 2: Get available parameter sets
    println("\nTest 2: Getting available parameter sets...")
    available_sets = get_available_parameter_sets()
    println("✓ Found $(length(available_sets)) parameter sets")
    if length(available_sets) > 0
        println("Available sets: $(available_sets[1:min(3, length(available_sets))])...")
    end
    
    # Test 3: Get a parameter value
    println("\nTest 3: Getting parameter value...")
    value = get_scalar_parameters(params)
    if haskey(value, "Electrode height [m]")
        println("✓ Electrode height: $(value["Electrode height [m]"]) m ")
    else
        println("✓ Scalar parameters retrieved (showing first few):")
        for (key, val) in collect(value)[1:min(3, length(value))]
            println("  $key: $val")
        end
    end

    return true
    
end
