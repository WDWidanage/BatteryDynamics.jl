# BatteryDynamics.jl

[![Build Status](https://github.com/WDWidanage/BatteryDynamics.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/WDWidanage/BatteryDynamics.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/WDWidanage/BatteryDynamics.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/WDWidanage/BatteryDynamics.jl)
[![Documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://WDWidanage.github.io/BatteryDynamics.jl)

A Julia package for battery dynamics modeling and simulation, providing interfaces to PyBaMM parameter sets and OCV data processing capabilities.

## Features

- **PyBaMM Integration**: Seamless conversion of PyBaMM parameter sets to Julia types
- **OCV Data Processing**: Load and process Open Circuit Voltage data from JSON files
- **Parameter Management**: Separate scalar and function parameters for easy access
- **DataFrame Integration**: Convert between DataFrames and dictionaries for flexible data handling

## Installation

```julia
using Pkg
Pkg.add("BatteryDynamics")
```

Or add it to your environment:

```julia
using Pkg
Pkg.add(url="https://github.com/WDWidanage/BatteryDynamics.jl")
```

## Quick Start

### Loading PyBaMM Parameter Sets

```julia
using BatteryDynamics

# Get available parameter sets
available_sets = get_available_parameter_sets()
println("Available parameter sets: ", available_sets)

# Load a specific parameter set
params = get_pybamm_parameter_set("Chen2020")

# Access scalar parameters
scalars = get_scalar_parameters(params)
cell_capacity = scalars["Cell capacity [A.h]"]

# Access function parameters
functions = get_function_parameters(params)
ocp_func = functions["Negative electrode OCP [V]"]

# Use the function
ocp_value = ocp_func(0.5)  # State of charge = 0.5
```

### Processing OCV Data

```julia
using BatteryDynamics

# Load OCV data from JSON file
ocv_data, meta_data = read_ocv_data("path/to/ocv_data.json")

# Convert DataFrame to dictionary
ocv_dict = dataframe_to_dict(ocv_data)
```

## API Reference

### PyBaMM Interface Functions

- `get_available_parameter_sets()`: Get list of available PyBaMM parameter sets
- `get_pybamm_parameter_set(name)`: Load a specific parameter set by name
- `get_scalar_parameters(params)`: Extract scalar parameters from a parameter set
- `get_function_parameters(params)`: Extract function parameters from a parameter set

### OCV Data Functions

- `read_ocv_data(filepath)`: Load OCV data from JSON file
- `dataframe_to_dict(df)`: Convert DataFrame to dictionary

## Examples

See the `examples/` directory for detailed usage examples:
- `parameter_conversion_example.jl`: Demonstrates PyBaMM parameter set conversion

## Dependencies

- **CondaPkg**: Python environment management
- **DataFrames**: Data manipulation
- **JSON**: JSON file parsing
- **ModelingToolkit**: Symbolic modeling
- **Plots**: Plotting capabilities
- **PythonCall**: Python-Julia interface

## Requirements

- Julia 1.11+
- Python with PyBaMM installed (managed via CondaPkg)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Citation

If you use BatteryDynamics.jl in your research, please cite:

```bibtex
@software{batterydynamics2024,
  title={BatteryDynamics.jl: A Julia package for battery dynamics modeling},
  author={Widanage, W. D.},
  year={2024},
  url={https://github.com/WDWidanage/BatteryDynamics.jl}
}
```
