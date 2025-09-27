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

## Quick Start

```julia
using BatteryDynamics

# Get available PyBaMM parameter sets
available_sets = get_available_parameter_sets()

# Load a parameter set
params = get_pybamm_parameter_set("Chen2020")

# Access parameters
scalars = get_scalar_parameters(params)
functions = get_function_parameters(params)
```

## Installation

See the [Installation](@ref) page for detailed installation instructions.

## Getting Started

See the [Getting Started](@ref) guide for a comprehensive introduction to using BatteryDynamics.jl.

## API Reference

- [PyBaMM Interface](@ref): Functions for working with PyBaMM parameter sets
- [OCV Data Processing](@ref): Functions for loading and processing OCV data

## Examples

Check out the [Examples](@ref) page for detailed usage examples and tutorials.
