# Getting Started

This guide will help you get started with BatteryDynamics.jl by walking through the main features and usage patterns.

## Loading the Package

```julia
using BatteryDynamics
```

## Working with PyBaMM Parameter Sets

### Getting Available Parameter Sets

First, let's see what parameter sets are available:

```julia
available_sets = get_available_parameter_sets()
println("Available parameter sets:")
for set in available_sets
    println("  - $set")
end
```

### Loading a Parameter Set

Load a specific parameter set (default is "Chen2020"):

```julia
# Load the default Chen2020 parameter set
params = get_pybamm_parameter_set()

# Or specify a different parameter set
params = get_pybamm_parameter_set("Ai2020")
```

### Working with Scalar Parameters

Scalar parameters are numeric values like capacities, conductivities, etc.:

```julia
# Get all scalar parameters
scalars = get_scalar_parameters(params)

# Access specific parameters
cell_capacity = scalars["Cell capacity [A.h]"]
println("Cell capacity: $cell_capacity A.h")

# Find parameters by keyword
capacity_params = filter(x -> occursin("capacity", lowercase(x)), keys(scalars))
println("Capacity-related parameters: $capacity_params")
```

### Working with Function Parameters

Function parameters are temperature or state-of-charge dependent functions:

```julia
# Get all function parameters
functions = get_function_parameters(params)

# List available functions
println("Available functions:")
for name in keys(functions)
    println("  - $name")
end

# Use an OCP (Open Circuit Potential) function
if haskey(functions, "Negative electrode OCP [V]")
    ocp_func = functions["Negative electrode OCP [V]"]
    
    # Evaluate at different states of charge
    soc_values = [0.0, 0.25, 0.5, 0.75, 1.0]
    println("Negative electrode OCP:")
    for soc in soc_values
        ocp_value = ocp_func(soc)
        println("  SOC = $soc, OCP = $ocp_value V")
    end
end
```

## Working with OCV Data

### Loading OCV Data

Load OCV (Open Circuit Voltage) data from a JSON file:

```julia
# Load OCV data
ocv_data, meta_data = read_ocv_data("path/to/your/ocv_data.json")

# Examine the data structure
println("OCV data columns: ", names(ocv_data))
println("Meta data columns: ", names(meta_data))

# Display first few rows
println("First 5 rows of OCV data:")
println(first(ocv_data, 5))
```

### Converting DataFrames to Dictionaries

Convert DataFrames to dictionaries for easier parameter passing:

```julia
# Convert to dictionary
ocv_dict = dataframe_to_dict(ocv_data)

# Access specific columns
state_of_lithiation = ocv_dict["state_of_lithiation"]
voltage_mean = ocv_dict["voltage_mean_V"]

# Plot the data (if Plots.jl is available)
using Plots
plot(state_of_lithiation, voltage_mean, 
     xlabel="State of Lithiation", 
     ylabel="Voltage (V)", 
     title="OCV Curve")
```

## Complete Example

Here's a complete example that combines both features:

```julia
using BatteryDynamics

# 1. Load PyBaMM parameters
println("=== Loading PyBaMM Parameters ===")
params = get_pybamm_parameter_set("Chen2020")

# 2. Extract and display key parameters
scalars = get_scalar_parameters(params)
functions = get_function_parameters(params)

println("Number of scalar parameters: $(length(scalars))")
println("Number of function parameters: $(length(functions))")

# 3. Show some key parameters
if haskey(scalars, "Cell capacity [A.h]")
    println("Cell capacity: $(scalars["Cell capacity [A.h]"]) A.h")
end

# 4. Demonstrate function usage
if haskey(functions, "Negative electrode OCP [V]")
    ocp_func = functions["Negative electrode OCP [V]"]
    println("Negative electrode OCP at 50% SOC: $(ocp_func(0.5)) V")
end

# 5. Load OCV data (if available)
println("\n=== Loading OCV Data ===")
try
    ocv_data, meta_data = read_ocv_data("test/OCV_20Si50Gr.json")
    println("OCV data loaded successfully!")
    println("Data shape: $(size(ocv_data))")
    println("Columns: $(names(ocv_data))")
catch e
    println("OCV data not available: $e")
end
```

## Next Steps

- Explore the [API Reference](@ref) for detailed function documentation
- Check out the [Examples](@ref) page for more advanced usage patterns
- See the [Contributing](@ref) guide if you'd like to contribute to the package
