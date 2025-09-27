# OCV Data Processing

The OCV data processing module provides functions to load and manipulate Open Circuit Voltage (OCV) data from JSON files and convert between DataFrames and dictionaries.

## Functions

```@docs
read_ocv_data
dataframe_to_dict
```

## Usage Examples

### Loading OCV Data

```julia
using BatteryDynamics

# Load OCV data from JSON file
ocv_data, meta_data = read_ocv_data("path/to/ocv_data.json")

# Examine the data structure
println("OCV data columns: ", names(ocv_data))
println("Data shape: ", size(ocv_data))

# Display first few rows
println(first(ocv_data, 5))
```

### Converting DataFrames to Dictionaries

```julia
# Convert DataFrame to dictionary
ocv_dict = dataframe_to_dict(ocv_data)

# Access specific columns as vectors
state_of_lithiation = ocv_dict["state_of_lithiation"]
voltage_mean = ocv_dict["voltage_mean_V"]

# This is useful for passing data to other functions
# or for plotting with different plotting packages
```

### Working with OCV Data

```julia
# Extract specific voltage measurements
delithiation_voltage = ocv_data.voltage_delithiate_V
lithiation_voltage = ocv_data.voltage_lithiate_V
mean_voltage = ocv_data.voltage_mean_V
hysteresis = ocv_data.hysteresis_voltage_V

# Calculate voltage difference
voltage_difference = delithiation_voltage .- lithiation_voltage
```

## Data Structure

The `read_ocv_data` function returns a tuple of two DataFrames:

### OCV Data DataFrame
- `state_of_lithiation`: State of lithiation values
- `capacity_vector_As`: Capacity values in Ampere-seconds  
- `voltage_mean_V`: Mean voltage values in Volts
- `voltage_delithiate_V`: Delithiation voltage values in Volts
- `voltage_lithiate_V`: Lithiation voltage values in Volts
- `hysteresis_voltage_V`: Hysteresis voltage values in Volts

### Meta Data DataFrame
Contains metadata from the JSON file, structure depends on the specific OCV data file.

## Error Handling

- Empty file paths will throw an `ArgumentError`
- File read errors will throw a `SystemError`
- Malformed JSON will throw a `JSON.ParseError`
- Empty DataFrames will throw an `ArgumentError` when converting to dictionary
