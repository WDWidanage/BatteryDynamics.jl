"""
Example demonstrating how to convert PyBaMM parameter sets to Julia types
"""

using BatteryDynamics

# Load a parameter set
params = get_pybamm_parameter_set("Chen2020");


println("=== PyBaMM Parameter Set Conversion Example ===")
println()

# Display some scalar parameters
println("Scalar Parameters (first 10):")
scalar_items = collect(params.scalars)
for i in 1:min(10, length(scalar_items))
    name, value = scalar_items[i]
    println("  $name: $value")
end
println("... and $(length(params.scalars) - 10) more scalar parameters")
println()

# Display function parameters
println("Function Parameters:")
for (name, func) in params.functions
    println("  $name: $(typeof(func))")
end
println()

# Demonstrate using the functions
if !isempty(params.functions)
    println("=== Testing Function Parameters ===")
    
    # Test OCP function if available
    ocp_key = "Negative electrode OCP [V]"
    if haskey(params.functions, ocp_key)
        ocp_func = params.functions[ocp_key]
        println("Testing $ocp_key function:")
        
        soc_values = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
        for soc in soc_values
            try
                ocp_value = ocp_func(soc)
                println("  SOC = $soc, OCP = $ocp_value V")
            catch e
                println("  SOC = $soc, Error: $e")
            end
        end
    end
end
