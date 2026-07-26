"""
PyBaMM interface for BatteryDynamics package
Provides Julia functions to work with PyBaMM parameter sets via PythonCall
"""

# PyBaMM is imported on first use rather than in `__init__` so that loading
# BatteryDynamics does not pay the cost of starting Python, and so that a
# missing or broken PyBaMM installation degrades to a warning instead of
# preventing the package from loading at all.
const PYBAMM = Ref{Union{Py,Nothing}}(nothing)
const PYBAMM_IMPORT_ATTEMPTED = Ref(false)

"""
    pybamm() -> Union{Py, Nothing}

Return the `pybamm` Python module, importing it on first use.

Returns `nothing` (and warns once) if PyBaMM cannot be imported, so that callers
can degrade gracefully rather than error.
"""
function pybamm()
    if !PYBAMM_IMPORT_ATTEMPTED[]
        PYBAMM_IMPORT_ATTEMPTED[] = true
        try
            PYBAMM[] = pyimport("pybamm")
        catch e
            @warn "Failed to import PyBaMM. PyBaMM-dependent functionality is unavailable." exception = e
            PYBAMM[] = nothing
        end
    end
    return PYBAMM[]
end

"""
    get_available_parameter_sets()

Get list of available parameter sets in PyBaMM.

# Returns
- `Vector{String}`: List of available parameter set names, or an empty vector if
  PyBaMM is unavailable
"""
function get_available_parameter_sets()
    pb = pybamm()
    if pb === nothing
        @warn "PyBaMM is not available. Returning empty list."
        return String[]
    end
    # Get the parameter sets list directly from PyBaMM
    param_set_names = pyconvert(Vector{String}, pb.parameter_sets)
    return param_set_names
end

"""
    get_pybamm_parameter_set(parameter_set_name::String = "Chen2020")

Load a specific parameter set by name and convert it to Julia types.

# Arguments
- `parameter_set_name::String`: Name of the parameter set to load

# Returns
- `NamedTuple`: Contains `scalars` (`Dict{String, Float64}`) and `functions`
  (`Dict{String, Function}`), or `nothing` if PyBaMM is unavailable or the
  parameter set could not be loaded

# Example
```julia
params = get_pybamm_parameter_set("Chen2020")
```
"""
function get_pybamm_parameter_set(parameter_set_name::String="Chen2020")
    pb = pybamm()
    if pb === nothing
        @warn "PyBaMM is not available. Cannot load parameter set '$parameter_set_name'."
        return nothing
    end
    try
        params = pb.ParameterValues(parameter_set_name)
        return convert_pybamm_parameter_set_to_julia(params)
    catch e
        @warn "Error loading parameter set '$parameter_set_name': $e"
        println("Available parameter sets: ", pb.parameter_sets)
        return nothing
    end
end


"""
    convert_pybamm_parameter_set_to_julia(params)

Convert a PyBaMM parameter set to Julia types, separating scalars and functions.

# Arguments
- `params`: PyBaMM `ParameterValues` object

# Returns
- `NamedTuple`: Contains `scalars` (`Dict{String, Float64}`) and `functions`
  (`Dict{String, Function}`)

# Example
```julia
julia_params = get_pybamm_parameter_set("Chen2020")
# Access scalars: julia_params.scalars["Electrode height [m]"]
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

Get only the scalar parameters from a converted parameter set.

# Arguments
- `params::NamedTuple`: Converted parameter set as returned by
  [`get_pybamm_parameter_set`](@ref) or [`convert_pybamm_parameter_set_to_julia`](@ref)

# Returns
- `Dict{String, Float64}`: Dictionary of parameter names to scalar values
"""
get_scalar_parameters(params::NamedTuple) = params.scalars

"""
    get_function_parameters(params)

Get only the function parameters from a converted parameter set, as Julia functions.

# Arguments
- `params::NamedTuple`: Converted parameter set as returned by
  [`get_pybamm_parameter_set`](@ref) or [`convert_pybamm_parameter_set_to_julia`](@ref)

# Returns
- `Dict{String, Function}`: Dictionary of parameter names to Julia functions
"""
get_function_parameters(params::NamedTuple) = params.functions

# `get_pybamm_parameter_set` returns `nothing` when PyBaMM is unavailable or the
# parameter set name is unknown; give a pointed error rather than a bare
# "type Nothing has no field scalars".
const NO_PARAMETER_SET_MESSAGE = "Received `nothing` instead of a parameter set. " *
    "This usually means `get_pybamm_parameter_set` failed, either because PyBaMM " *
    "is not installed or the parameter set name is unknown."

get_scalar_parameters(::Nothing) = throw(ArgumentError(NO_PARAMETER_SET_MESSAGE))
get_function_parameters(::Nothing) = throw(ArgumentError(NO_PARAMETER_SET_MESSAGE))
