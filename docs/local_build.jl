# Local documentation build script
# Run this from the docs/ directory to test documentation locally

using Pkg
Pkg.activate(".")
Pkg.instantiate()

# Build documentation locally
include("make.jl")

println("Documentation built successfully!")
println("Open docs/build/index.html in your browser to view the documentation.")
