using Documenter
using BatteryDynamics

# Set up the documentation
makedocs(
    sitename = "BatteryDynamics.jl",
    authors = "W. Dhammika Widanage and contributors",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://WDWidanage.github.io/BatteryDynamics.jl",
        assets = String[],
    ),
    source = "src",
    build = "build",
    clean = true,
    pages = [
        "Home" => "index.md",
        "Installation" => "installation.md",
        "Getting Started" => "getting_started.md",
        "API Reference" => [
            "PyBaMM Interface" => "api/pybamm_interface.md",
            "OCV Data Processing" => "api/ocv_dataframes.md",
        ],
        "Examples" => "examples.md",
        "Contributing" => "contributing.md",
    ],
    checkdocs = :none,  # Skip documentation checking for faster builds
    modules = [BatteryDynamics],
    warnonly = [:missing_docs, :cross_references],
)

# Deploy documentation to GitHub Pages (only in CI)
if get(ENV, "CI", "false") == "true"
    deploydocs(
        repo = "github.com/WDWidanage/BatteryDynamics.jl.git",
        devbranch = "main",
        push_preview = true,
    )
end
