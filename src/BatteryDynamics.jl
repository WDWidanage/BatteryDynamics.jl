module BatteryDynamics

using JSON
using ModelingToolkit
using DataFrames


export OCV, load_ocv_from_json
export read_ocv_data

abstract type AbstractOCV end

"""
    read_ocv_data(filepath::String) -> Tuple{DataFrame, DataFrame}

Load OCV (Open Circuit Voltage) data from a JSON file and return it as a tuple of DataFrames.

# Arguments
- `filepath::String`: Path to the JSON file containing OCV data

# Returns
- `Tuple{DataFrame, DataFrame}`: A tuple containing:
  - `ocv_data`: DataFrame with OCV measurements including columns:
    - `state_of_lithiation`: State of lithiation values
    - `capacity_vector_As`: Capacity values in Ampere-seconds
    - `voltage_mean_V`: Mean voltage values in Volts
    - `voltage_delithiate_V`: Delithiation voltage values in Volts
    - `voltage_lithiate_V`: Lithiation voltage values in Volts
    - `hysteresis_voltage_V`: Hysteresis voltage values in Volts
  - `meta_data`: DataFrame containing metadata from the JSON file

# Examples
```julia
ocv_data, meta_data = read_ocv_data("path/to/ocv_data.json")
```

# Throws
- `ArgumentError`: If the file path is empty
- `SystemError`: If the file cannot be read
- `JSON.ParseError`: If the JSON file is malformed
"""
function read_ocv_data(filepath::String)
    # Validate input
    isempty(filepath) && throw(ArgumentError("File path cannot be empty"))
    
    # Load and parse JSON data
    data = JSON.parsefile(filepath)
    
    # Extract the meta data from the JSON file
    meta_data = DataFrame(data["meta_data"])
    
    # Extract required fields and create DataFrame
    ocv_data = DataFrame(
        state_of_lithiation = data["state_of_lithiation"],
        capacity_vector_As = data["capacity_vector_As"],
        voltage_mean_V = data["voltage_mean_V"],
        voltage_delithiate_V = data["voltage_delithiate_V"],
        voltage_lithiate_V = data["voltage_lithiate_V"],
        hysteresis_voltage_V = data["hysteresis_voltage_V"]
    )
    return ocv_data, meta_data
end
end