# PyBaMM Interface

The PyBaMM interface provides functions to work with PyBaMM parameter sets in Julia, converting Python objects to native Julia types for easier manipulation and integration with other Julia packages.

## Functions

```@docs
get_available_parameter_sets
get_pybamm_parameter_set
convert_pybamm_parameter_set_to_julia
get_scalar_parameters
get_function_parameters
```

## Usage Examples

### Basic Parameter Set Loading

```julia
using BatteryDynamics

# Get available parameter sets
available_sets = get_available_parameter_sets()
println("Available parameter sets: ", available_sets)

# Load a specific parameter set
params = get_pybamm_parameter_set("Chen2020")
```

### Working with Scalar Parameters

```julia
# Get scalar parameters
scalars = get_scalar_parameters(params)

# Access specific parameters
cell_capacity = scalars["Cell capacity [A.h]"]
electrode_thickness = scalars["Negative electrode thickness [m]"]

# Find all parameters containing "capacity"
capacity_params = filter(x -> occursin("capacity", lowercase(x)), keys(scalars))
```

### Working with Function Parameters

```julia
# Get function parameters
functions = get_function_parameters(params)

# Use OCP functions
if haskey(functions, "Negative electrode OCP [V]")
    ocp_func = functions["Negative electrode OCP [V]"]
    
    # Evaluate at different states of charge
    soc_values = 0.0:0.1:1.0
    ocp_values = [ocp_func(soc) for soc in soc_values]
end
```

## Parameter Set Structure

When you load a parameter set using `get_pybamm_parameter_set()`, you get a `NamedTuple` with two fields:

- `scalars`: A `Dict{String, Float64}` containing numeric parameters
- `functions`: A `Dict{String, Function}` containing state-dependent functions

This structure allows you to easily separate and work with different types of parameters in your battery models.

## Error Handling

The functions include comprehensive error handling:

- Invalid parameter set names will show available options
- Function evaluation errors are caught and return `NaN`
- Non-convertible parameters are silently skipped with debug messages
