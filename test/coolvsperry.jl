using CoolProp
using CoolPropDefs

using ICapeThermoUniversalConstants
#molarGasConstant
println("$(getuniversalconstant("molarGasConstant")) VS $(PropsSI("Air",coolpropmapping["molarGasConstant"]))")

import ICapeThermoCompounds
compIds,formulae,names,boilTemps,molwts,casnos=getcompoundlist();
lnames=map(lowercase,names)
for fluid in coolpropfluids
  f=findfirst(names,fluid)
  f==0 && findfirst(lnames,lowercase(fluid));
  f==0 && println("not find $fluid");
end
for param in ["version", "gitrevision", "errstring", "warnstring", "FluidsList", "incompressible_list_pure", "incompressible_list_solution", "mixture_binary_pairs_list", "parameter_list", "predefined_mixtures", "HOME", "cubic_fluids_schema", "invalid"]
  println(param * " = " * get_global_param_string(param))
end
param_list = split(get_global_param_string("parameter_list"),',');
fluids_list = split(get_global_param_string("FluidsList"),',');
println("number of defined parameters = $(length(param_list))")
for param in param_list
  println("$param ---> $(get_parameter_information_string(String(param), "long"))");
end
for fluid in fluids_list
  for param in param_list
    #println("$fluid $param $(get_fluid_param_string(String(fluid), String(param)))");
  end
end
