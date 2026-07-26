module BatteryDynamics
__precompile__(true)

using DataFrames
using PythonCall

# Include OCV-related functionality
include("ocv_dataframes.jl")

# Include PyBaMM interface
include("pybamm_interface.jl")

export read_ocv_data
export dataframe_to_dict

# Export PyBaMM interface functions
export get_available_parameter_sets
export get_pybamm_parameter_set
export convert_pybamm_parameter_set_to_julia
export get_scalar_parameters
export get_function_parameters

end
