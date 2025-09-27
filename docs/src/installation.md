# Installation

## Requirements

- Julia 1.11 or higher
- Python with PyBaMM installed (managed automatically via CondaPkg)

## Installing BatteryDynamics.jl

### From the Julia Package Manager

```julia
using Pkg
Pkg.add("BatteryDynamics")
```

### From GitHub (development version)

```julia
using Pkg
Pkg.add(url="https://github.com/WDWidanage/BatteryDynamics.jl")
```

### For development

```julia
using Pkg
Pkg.develop("BatteryDynamics")
```

## Python Dependencies

BatteryDynamics.jl uses CondaPkg to manage Python dependencies automatically. The following Python packages will be installed:

- `pybamm`: Python Battery Mathematical Modeling package

These dependencies are installed automatically when you first use the package, so no manual Python installation is required.

## Verification

To verify your installation, run:

```julia
using BatteryDynamics

# Check if PyBaMM is available
available_sets = get_available_parameter_sets()
println("Available parameter sets: ", available_sets)
```

If you see a list of parameter sets, your installation is successful!
