using CoolProp
using CoolPropDefs
const buggy = ["DIPOLE_MOMENT","FRACTION_MAX","FRACTION_MIN","GWP100","GWP20","GWP500","ODP","RHOMASS_REDUCING","T_FREEZE"]
const inputparamsindex = [[2,3], [4,5], 6, 7, [8,9], 11, [12,13]];
#CoolProp
@static is_apple() ? println("CoolProp: no osx support") : begin
  #Trivial inputs
  i=1
  while i<size(coolpropparameters)[2]
    p = (parameters[[1,4],i]);
    if (p[1][1] in buggy)
      for fluid in coolpropfluids
        try
          res = ("$(PropsSI(p[1][1], fluid))")
          #println("$(p[1][1]) $fluid")
        catch err
        end
      end
    end
    if p[2] & !(p[1][1] in buggy)
      for fluid in coolpropfluids
        res = ("$(PropsSI(p[1][1], fluid))")
      end
    end
    i+=1;
  end
  println("testing CoolProp....")
  #PropsSI
  @test_approx_eq 1049.8359368286092 PropsSI("A","P",101325.0,"Q",0.0,fluids[1])
  #PhaseSI
  #get_global_param_string
  #get_parameter_information_string
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
