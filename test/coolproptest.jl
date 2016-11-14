using CoolProp
using CoolPropDefs
const buggy = ["T_FREEZE","RHOMASS_REDUCING","ODP","GWP500","GWP20","GWP100","FRACTION_MIN","FRACTION_MAX","DIPOLE_MOMENT"]
#CoolProp
@static is_apple() ? println("CoolProp: no osx support") : begin
  #get_global_param_string
  coolpropfluids = split(get_global_param_string("FluidsList"),',');
  coolpropparameters = split(get_global_param_string("parameter_list"),',');
  #get_parameter_information_string
  #Trivial inputs
  for p in coolproptrivialparameters
    for fluid in coolpropfluids
      try
        res = ("$(PropsSI(String(p), String(fluid)))");
        findfirst(buggy, p) != 0 && println(get_parameter_information_string(p, "long") * " for $fluid is $res (" * get_parameter_information_string(p, "units") * ")");
      catch err
        findfirst(buggy, p) == 0 && println("can't get $p for $fluid");
      end
    end
  end
  println("testing CoolProp....")
  #PropsSI
  #@test_approx_eq 1049.8359368286092 PropsSI("A","P",101325.0,"Q",0.0,coolpropfluids[1])
  #PhaseSI
  #get_fluid_param_string
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
