"""
PyBaMM interface for BatteryDynamics package
Provides Julia functions to work with PyBaMM parameter sets via PythonCall
"""

# Import Python modules
const pb = Ref{Py}()

function __init__()
  try
    pb[] = pyimport("pybamm")
  catch e
    @warn "Failed to import PyBaMM: $e. Some functionality may not be available."
    pb[] = nothing
  end
end

"""
    get_available_parameter_sets()

Get list of available parameter sets in PyBaMM.

# Returns
- `Vector{String}`: List of available parameter set names
"""
function get_available_parameter_sets()
    if pb[] === nothing
        @warn "PyBaMM is not available. Returning empty list."
        return String[]
    end
    # Get the parameter sets list directly from PyBaMM
    param_set_names = pyconvert(Vector{String}, pb[].parameter_sets)
    return param_set_names
end

"""
    get_pybamm_parameter_set(parameter_set_name::String ="Chen2020")

Load a specific parameter set by name.

# Arguments
- `parameter_set_name::String`: Name of the parameter set to load

# Returns
- `NamedTuple`: The requested parameter set, or `nothing` if not found
"""
function get_pybamm_parameter_set(parameter_set_name::String="Chen2020")
    if pb[] === nothing
        @warn "PyBaMM is not available. Cannot load parameter set '$parameter_set_name'."
        return nothing
    end
    try
        params = pb[].ParameterValues(parameter_set_name)
        return convert_pybamm_parameter_set_to_julia(params)
    catch e
        @warn "Error loading parameter set '$parameter_set_name': $e"
        println("Available parameter sets: ", pb[].parameter_sets)
        return nothing
    end
end


"""
    convert_pybamm_parameter_set_to_julia(params)

Convert a PyBaMM parameter set to Julia types, separating scalars and functions.

# Arguments
- `params::PyObject`: PyBaMM ParameterValues object

# Returns
- `NamedTuple`: Contains `scalars` (Dict{String, Float64}) and `functions` (Dict{String, Function})

# Example
```julia
params = get_parameter_set()
julia_params = convert_pybamm_parameter_set_to_julia(params)
# Access scalars: julia_params.scalars["Cell capacity [A.h]"]
# Access functions: julia_params.functions["Negative electrode OCP [V]"]
```
"""
function convert_pybamm_parameter_set_to_julia(params)
    scalars = Dict{String, Float64}()
    functions = Dict{String, Function}()
    
    try
        # Get all parameter names from the parameter set using Python's keys() method
        param_names = pyconvert(Vector{String}, collect(params.keys()))
        
        for param_name in param_names
            try
                param_value = params[param_name]
                
                # Check if it's a callable (function)
                if pycallable(param_value)
                    # Convert Python function to Julia function
                    julia_func = function(x)
                        try
                            return pyconvert(Float64, param_value(x))
                        catch e
                            @warn "Error evaluating function '$param_name' at x=$x: $e"
                            return NaN
                        end
                    end
                    functions[param_name] = julia_func
                else
                    # Try to convert to scalar
                    try
                        scalar_value = pyconvert(Float64, param_value)
                        scalars[param_name] = scalar_value
                    catch e
                        # If conversion to Float64 fails, try other numeric types
                        try
                            if isa(param_value, Py)
                                # Try to convert to a general number first
                                num_value = pyconvert(Number, param_value)
                                scalars[param_name] = Float64(num_value)
                            else
                                # Silently skip non-convertible parameters (like lists, dicts, etc.)
                                @debug "Skipping non-numeric parameter '$param_name'"
                            end
                        catch e2
                            # Silently skip non-convertible parameters
                            @debug "Skipping non-convertible parameter '$param_name': $e2"
                        end
                    end
                end
            catch e
                @warn "Error processing parameter '$param_name': $e"
            end
        end
        
        return (scalars = scalars, functions = functions)
        
    catch e
        @error "Error converting parameter set to Julia: $e"
        return (scalars = Dict{String, Float64}(), functions = Dict{String, Function}())
    end
end

"""
    get_scalar_parameters(params)

Get only the scalar parameters from a PyBaMM parameter set as Julia floats.

# Arguments
- `params::NamedTuple`: PyBaMM ParameterValues object

# Returns
- `Dict{String, Float64}`: Dictionary of parameter names to scalar values
"""
function get_scalar_parameters(params)
    return params.scalars
end

"""
    get_function_parameters(julia_params)

Get only the function parameters from a PyBaMM parameter set as Julia functions.

# Arguments
    - `params::NamedTuple`: PyBaMM ParameterValues object

# Returns
- `Dict{String, Function}`: Dictionary of parameter names to Julia functions
"""
function get_function_parameters(params)
    return params.functions
end


