module BatteryDynamics

__precompile__(true)

using ModelingToolkit
using DataFrames

# Include OCV-related functionality
include("ocv_dataframes.jl")

export read_ocv_data
export dataframe_to_dict

end