using BatteryDynamics
using FiniteDifferences
using Plots

params = get_pybamm_parameter_set("Xu2019");

scalars = get_scalar_parameters(params);
functions = get_function_parameters(params)


ocv_negative(z) = functions["Negative electrode OCP [V]"].(z);
derivative_ocv_negative(z) = central_fdm(5, 1).(ocv_negative, z);

ocv_positive(z) = functions["Positive electrode OCP [V]"].(z);
derivative_ocv_positive(z) = central_fdm(5, 1).(ocv_positive, z);


# Stay inside (0, 1): graphite OCP has 1/z and log(z) terms, and a 5-point
# central stencil around 0 or 1 samples negative / >1 stoichiometry.
soc_values = 0.05:0.01:0.95;

plot(soc_values, ocv_negative(soc_values))
plot!(soc_values, ocv_positive(soc_values))


plot(soc_values, derivative_ocv_negative(soc_values))
plot!(soc_values, derivative_ocv_positive(soc_values))

plot(ocv_negative(0.05:0.01:0.7), -1.0 ./ derivative_ocv_negative(0.05:0.01:0.7))
plot(ocv_positive(soc_values), -1.0 ./ derivative_ocv_positive(soc_values))

1/derivative_ocv_negative(soc_values)
ocv_negative(soc_values)



negative_electrode_thickness = scalars["Negative electrode thickness [m]"]
positive_electrode_thickness = scalars["Positive electrode thickness [m]"]
separator_thickness = scalars["Separator thickness [m]"]
electrode_area = scalars["Electrode height [m]"] * scalars["Electrode width [m]"]
# Chen2020 has this key; Ramadass2004 does not — fall back to sandwich geometry.
cell_volume = get(scalars, "Cell volume [m3]") do
    electrode_area * (
        scalars["Negative electrode thickness [m]"] +
        scalars["Separator thickness [m]"] +
        scalars["Positive electrode thickness [m]"]
    )
end

negative_porosity = scalars["Negative electrode porosity"]
positive_porosity = scalars["Positive electrode porosity"]

negative_particle_radius = scalars["Negative particle radius [m]"]
positive_particle_radius = scalars["Positive particle radius [m]"]



