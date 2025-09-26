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
    println("✓ Default parameter set loaded successfully")
    
    # Test 2: Get available parameter sets
    println("\nTest 2: Getting available parameter sets...")
    available_sets = get_available_parameter_sets()
    println("✓ Found $(length(available_sets)) parameter sets")
    println("Available sets: $(available_sets[1:min(3, length(available_sets))])...")
    
    # Test 3: Get a parameter value
    println("\nTest 3: Getting parameter value...")
    value = get_scalar_parameters(params)
    println("✓ Electrode height: $(value["Electrode height [m]"]) m ")

    return true
    
end
