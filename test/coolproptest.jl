using CoolProp
#CoolProp
println("testing CoolProp....")
#PropsSI
@test_approx_eq 373.1242958476879 PropsSI("T","P",101325.0,"Q",0.0,"Water")
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
