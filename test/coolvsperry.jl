using CoolProp
using CoolPropDefs
#CoolProp
@static is_apple() ? println("CoolProp: no osx support") : begin
  using ICapeThermoUniversalConstants
  #molarGasConstant
  println("$(getuniversalconstant("molarGasConstant")) VS $(PropsSI("Air",coolpropmapping["molarGasConstant"]))")

  import ICapeThermoCompounds
  compIds,formulae,names,boilTemps,molwts,casnos=getcompoundlist();
  #get_global_param_string
  for param in ["version", "gitrevision", "errstring", "warnstring", "FluidsList", "incompressible_list_pure", "incompressible_list_solution", "mixture_binary_pairs_list", "parameter_list", "predefined_mixtures", "HOME", "cubic_fluids_schema"]
    println(param * " = " * get_global_param_string(param))
  end
  param_list = split(get_global_param_string("parameter_list"),',');
  fluids_list = split(get_global_param_string("FluidsList"),',');
  println("number of defined parameters = $(length(param_list))")
  #get_parameter_information_string
  for param in param_list
    println("""$param ---> long  $(get_parameter_information_string(String(param), "long"))
                           short $(get_parameter_information_string(String(param), "short"))
                           units $(get_parameter_information_string(String(param), "units"))
                           IO    $(get_parameter_information_string(String(param), "IO"))"""
           );
  end
  #get_fluid_param_string
  nf=0;cf=0;
  for fluid in fluids_list
    println("$fluid aliases ----> $(get_fluid_param_string(String(fluid), String("aliases")))");
    f = findfirst(casnos,get_fluid_param_string(String(fluid), String("CAS")));
    for bi in ["BibTeX-CONDUCTIVITY", "BibTeX-EOS", "BibTeX-CP0", "BibTeX-SURFACE_TENSION","BibTeX-MELTING_LINE","BibTeX-VISCOSITY"]
      println("$fluid $bi ----> $(get_fluid_param_string(String(fluid), String(bi)))");
    end
    if f==0
      nf+=1
    else
      cf+=1
    end
  end
  println("common fluids: $cf and coolprop special fluids: $nf")
end
