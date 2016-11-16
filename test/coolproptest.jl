using CoolProp
using CoolPropDefs
const trivalwithnumval = ["FH","GWP100","PMIN","TMIN","P_REDUCING","PCRIT","GWP20","GAS_CONSTANT","PMAX","RHOCRIT","TCRIT","T_REDUCING","ACENTRIC","GWP500","RHOMOLAR_REDUCING","TMAX","TTRIPLE","PH","M","PTRIPLE","RHOMOLAR_CRITICAL","ODP","HH"];
const trivalwithoutnumval = ["DIPOLE_MOMENT","FRACTION_MAX","FRACTION_MIN","RHOMASS_REDUCING","T_FREEZE"];
const pseudopuremixtures = ["R134a","R116","n-Pentane","R11","n-Nonane","MDM","Oxygen","R41","MM","Neon","Fluorine","n-Undecane","Isohexane","Helium","IsoButane","D5"];
#CoolProp
@static is_apple() ? println("CoolProp: no osx support") : begin
  println("testing CoolProp....")
  #get_global_param_string
  coolpropmix = split(get_global_param_string("predefined_mixtures"), ',');
  coolpropfluids = split(get_global_param_string("FluidsList"),',');
  coolpropparameters = split(get_global_param_string("parameter_list"),',');
  #finding PROPERTIES WITH NUMERICAL VALUES in Trivial inputs
  tpropwithnumval = Set();
  for p in coolproptrivialparameters
    #get_parameter_information_string
    println(get_parameter_information_string(p, "long") * " in (" * get_parameter_information_string(p, "units") * ")");
    missed = Set();
    for fluid in coolpropfluids
      try
        res = ("$(PropsSI(String(p), String(fluid)))");
        push!(tpropwithnumval, p);
      catch err
        push!(missed, fluid);
      end
    end
    findfirst(trivalwithnumval, p) != 0 && length(missed) > 0 && println("can't get $p for $(collect(missed))");
    findfirst(trivalwithnumval, p) == 0 && println("$p in trival without numericalvalue")
  end
  @test tpropwithnumval == Set(trivalwithnumval);
  @test Set(setdiff(coolproptrivialparameters, tpropwithnumval)) == Set(trivalwithoutnumval);
  #get_fluid_param_string
  id = 0;
  counter = 0;
  maxdiffreduvscriti = 0.0;
  maxfluid = "";
  ppm = Set();
  for fluid in  coolpropfluids
    id+=1;
    print("\n$id-$fluid aliases:$(get_fluid_param_string(String(fluid), String("aliases")))");
    print(" cas:$(get_fluid_param_string(String(fluid), String("CAS")))");
    pure=get_fluid_param_string(String(fluid), String("pure"));
    print(" pure:$pure");
    print(" formula:$(get_fluid_param_string(String(fluid), String("formula")))");
    for bi in ["BibTeX-CONDUCTIVITY", "BibTeX-EOS", "BibTeX-CP0", "BibTeX-SURFACE_TENSION","BibTeX-MELTING_LINE","BibTeX-VISCOSITY"]
      print(" $bi:$(get_fluid_param_string(String(fluid), String(bi)))");
    end
    (pure == "true") && PropsSI("TCRIT", String(fluid))!=PropsSI("T_REDUCING", String(fluid)) && push!(ppm, fluid);
    diffreduvscriti = abs(PropsSI("TCRIT", String(fluid)) - PropsSI("T_REDUCING", String(fluid)));
    if (diffreduvscriti > maxdiffreduvscriti)
      maxfluid = fluid;
      maxdiffreduvscriti = diffreduvscriti;
    end
  end
  println("\nmax diff between reducing vs critical point temp: $maxdiffreduvscriti for $maxfluid");
  @test ppm == Set(pseudopuremixtures);
  println("pseudopuremixtures $ppm");
  #PhaseSI
  #set_reference_stateS
  #get_param_index
  #get_input_pair_index
  #F2K
  #K2F
  #HAPropsSI
  #AbstractState_factory
  #AbstractState_free
  #AbstractState_set_fractions
  #AbstractState_update
  #AbstractState_keyed_output
end
