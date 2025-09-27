# Examples

This page contains detailed examples demonstrating various features of BatteryDynamics.jl.

## Basic Parameter Set Usage

```julia
using BatteryDynamics

# Load a parameter set
params = get_pybamm_parameter_set("Chen2020")

# Display parameter information
println("=== Parameter Set Information ===")
scalars = get_scalar_parameters(params)
functions = get_function_parameters(params)

println("Number of scalar parameters: $(length(scalars))")
println("Number of function parameters: $(length(functions))")

# Show some key parameters
key_params = ["Cell capacity [A.h]", "Nominal cell capacity [A.h]", "Current function [A]"]
for param in key_params
    if haskey(scalars, param)
        println("$param: $(scalars[param])")
    end
end
```

## Working with Function Parameters

```julia
# Demonstrate function parameter usage
println("\n=== Function Parameters ===")

# Find OCP functions
ocp_functions = filter(x -> occursin("OCP", x), keys(functions))
println("Available OCP functions:")
for func in ocp_functions
    println("  - $func")
end

# Use an OCP function if available
if !isempty(ocp_functions)
    ocp_func_name = ocp_functions[1]
    ocp_func = functions[ocp_func_name]
    
    println("\nTesting $ocp_func_name:")
    soc_values = 0.0:0.2:1.0
    for soc in soc_values
        ocp_value = ocp_func(soc)
        println("  SOC = $soc, OCP = $(round(ocp_value, digits=3)) V")
    end
end
```

## Parameter Analysis

```julia
# Analyze parameter ranges and types
println("\n=== Parameter Analysis ===")

# Find capacity-related parameters
capacity_params = filter(x -> occursin("capacity", lowercase(x)), keys(scalars))
println("Capacity-related parameters:")
for param in capacity_params
    println("  $param: $(scalars[param])")
end

# Find voltage-related parameters
voltage_params = filter(x -> occursin("voltage", lowercase(x)), keys(scalars))
println("\nVoltage-related parameters:")
for param in voltage_params
    println("  $param: $(scalars[param]) V")
end
```

## OCV Data Processing

```julia
using BatteryDynamics

# Load OCV data (using the test file as an example)
println("=== OCV Data Processing ===")

try
    ocv_data, meta_data = read_ocv_data("test/OCV_20Si50Gr.json")
    
    println("OCV data loaded successfully!")
    println("Data shape: $(size(ocv_data))")
    println("Columns: $(names(ocv_data))")
    
    # Display summary statistics
    println("\nSummary statistics:")
    for col in names(ocv_data)
        if eltype(ocv_data[!, col]) <: Number
            min_val = minimum(ocv_data[!, col])
            max_val = maximum(ocv_data[!, col])
            mean_val = mean(ocv_data[!, col])
            println("  $col: min=$min_val, max=$max_val, mean=$mean_val")
        end
    end
    
    # Convert to dictionary for analysis
    ocv_dict = dataframe_to_dict(ocv_data)
    println("\nDictionary conversion successful!")
    println("Dictionary keys: $(keys(ocv_dict))")
    
catch e
    println("Could not load OCV data: $e")
    println("Make sure the test data file exists or provide a valid path.")
end
```

## Plotting OCV Data

```julia
using Plots

# Plot OCV curves if data is available
try
    ocv_data, _ = read_ocv_data("test/OCV_20Si50Gr.json")
    
    # Create OCV plot
    p1 = plot(ocv_data.state_of_lithiation, ocv_data.voltage_mean_V,
              xlabel="State of Lithiation",
              ylabel="Voltage (V)",
              title="Mean OCV Curve",
              linewidth=2)
    
    # Plot hysteresis
    p2 = plot(ocv_data.state_of_lithiation, ocv_data.voltage_delithiate_V,
              label="Delithiation",
              xlabel="State of Lithiation",
              ylabel="Voltage (V)",
              title="Hysteresis",
              linewidth=2)
    plot!(p2, ocv_data.state_of_lithiation, ocv_data.voltage_lithiate_V,
          label="Lithiation",
          linewidth=2)
    
    # Combine plots
    plot(p1, p2, layout=(1,2), size=(800,400))
    
catch e
    println("Plotting example requires OCV data file and Plots.jl")
    println("Error: $e")
end
```

## Integration with Other Packages

```julia
using BatteryDynamics
using DataFrames
using Statistics

# Example: Statistical analysis of parameters
params = get_pybamm_parameter_set("Chen2020")
scalars = get_scalar_parameters(params)

# Convert to DataFrame for analysis
param_df = DataFrame(
    parameter_name = collect(keys(scalars)),
    value = collect(values(scalars))
)

# Add log scale for better visualization
param_df.log_value = log10.(param_df.value)

# Find parameters in different ranges
small_params = filter(row -> row.value < 1e-6, param_df)
medium_params = filter(row -> 1e-6 <= row.value < 1e-2, param_df)
large_params = filter(row -> row.value >= 1e-2, param_df)

println("Parameter distribution:")
println("  Small parameters (< 1e-6): $(nrow(small_params))")
println("  Medium parameters (1e-6 to 1e-2): $(nrow(medium_params))")
println("  Large parameters (>= 1e-2): $(nrow(large_params))")
```

## Error Handling Examples

```julia
# Demonstrate error handling
println("=== Error Handling Examples ===")

# Invalid parameter set name
try
    params = get_pybamm_parameter_set("NonExistentSet")
    if params === nothing
        println("Invalid parameter set handled gracefully")
    end
catch e
    println("Error caught: $e")
end

# Invalid file path for OCV data
try
    ocv_data, meta_data = read_ocv_data("nonexistent_file.json")
catch e
    println("File error handled: $e")
end

# Empty DataFrame conversion
try
    empty_df = DataFrame()
    dict = dataframe_to_dict(empty_df)
catch e
    println("Empty DataFrame error handled: $e")
end
```

## Advanced Usage: Custom Parameter Processing

```julia
# Custom function to extract parameters by category
function categorize_parameters(params)
    scalars = get_scalar_parameters(params)
    
    categories = Dict(
        "electrode" => String[],
        "electrolyte" => String[],
        "separator" => String[],
        "capacity" => String[],
        "conductivity" => String[]
    )
    
    for (name, value) in scalars
        name_lower = lowercase(name)
        
        if occursin("electrode", name_lower)
            push!(categories["electrode"], name)
        elseif occursin("electrolyte", name_lower)
            push!(categories["electrolyte"], name)
        elseif occursin("separator", name_lower)
            push!(categories["separator"], name)
        elseif occursin("capacity", name_lower)
            push!(categories["capacity"], name)
        elseif occursin("conductivity", name_lower)
            push!(categories["conductivity"], name)
        end
    end
    
    return categories
end

# Use the categorization function
params = get_pybamm_parameter_set("Chen2020")
categories = categorize_parameters(params)

println("Parameter categorization:")
for (category, params) in categories
    if !isempty(params)
        println("  $category: $(length(params)) parameters")
        for param in params[1:min(3, length(params))]  # Show first 3
            println("    - $param")
        end
        if length(params) > 3
            println("    ... and $(length(params) - 3) more")
        end
    end
end
```
