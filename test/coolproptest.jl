using CoolProp
const fluids = ["1-Butene","Acetone","Air","Ammonia","Argon","Benzene","CarbonDioxide","CarbonMonoxide","CarbonylSulfide","CycloHexane","CycloPropane","Cyclopentane","D4","D5","D6","Deuterium","Dichloroethane","DiethylEther","DimethylCarbonate","DimethylEther","Ethane","Ethanol","EthylBenzene","Ethylene","EthyleneOxide","Fluorine","HFE143m","HeavyWater","Helium","Hydrogen","HydrogenChloride","HydrogenSulfide","IsoButane","IsoButene","Isohexane","Isopentane","Krypton","MD2M","MD3M","MD4M","MDM","MM","Methane","Methanol","MethylLinoleate","MethylLinolenate","MethylOleate","MethylPalmitate","MethylStearate","Neon","Neopentane","Nitrogen","NitrousOxide","Novec649","OrthoDeuterium","OrthoHydrogen","Oxygen","ParaDeuterium","ParaHydrogen","Propylene","Propyne","R11","R113","R114","R115","R116","R12","R123","R1233zd(E)","R1234yf","R1234ze(E)","R1234ze(Z)","R124","R125","R13","R134a","R13I1","R14","R141b","R142b","R143a","R152A","R161","R21","R218","R22","R227EA","R23","R236EA","R236FA","R245ca","R245fa","R32","R365MFC","R40","R404A","R407C","R41","R410A","R507A","RC318","SES36","SulfurDioxide","SulfurHexafluoride","Toluene","Water","Xenon","cis-2-Butene","m-Xylene","n-Butane","n-Decane","n-Dodecane","n-Heptane","n-Hexane","n-Nonane","n-Octane","n-Pentane","n-Propane","n-Undecane","o-Xylene","p-Xylene","trans-2-Butene"];
const parameters = reshape([["DELTA","Delta"],"","IO",false,"Reduced density (rho/rhoc)",["DMOLAR","Dmolar"],"mol/m^3","IO",false,"Molar density",["D"," DMASS","Dmass"],"kg/m^3","IO",false,"Mass density",["HMOLAR","Hmolar"],"J/mol","IO",false,"Molar specific enthalpy",["H"," HMASS","Hmass"],"J/kg","IO",false,"Mass specific enthalpy",["P"],"Pa","IO",false,"Pressure",["Q"],"mol/mol","IO",false,"Mass vapor quality",["SMOLAR","Smolar"],"J/mol/K","IO",false,"Molar specific entropy",["S"," SMASS","Smass"],"J/kg/K","IO",false,"Mass specific entropy",["TAU","Tau"],"","IO",false,"Reciprocal reduced temperature (Tc/T)",["T"],"K","IO",false,"Temperature",["UMOLAR","Umolar"],"J/mol","IO",false,"Molar specific internal energy",["U"," UMASS","Umass"],"J/kg","IO",false,"Mass specific internal energy",["ACENTRIC","acentric"],"","O",true,"Acentric factor",["ALPHA0","alpha0"],"","O",false,"Ideal Helmholtz energy",["ALPHAR","alphar"],"","O",false,"Residual Helmholtz energy",["A"," SPEED_OF_SOUND","speed_of_sound"],"m/s","O",false,"Speed of sound",["BVIRIAL","Bvirial"],"","O",false,"Second virial coefficient",["CONDUCTIVITY","L","conductivity"],"W/m/K","O",false,"Thermal conductivity",["CP0MASS","Cp0mass"],"J/kg/K","O",false,"Ideal gas mass specific constant pressure specific heat",["CP0MOLAR","Cp0molar"],"J/mol/K","O",false,"Ideal gas molar specific constant pressure specific heat",["CPMOLAR","Cpmolar"],"J/mol/K","O",false,"Molar specific constant pressure specific heat",["CVIRIAL","Cvirial"],"","O",false,"Third virial coefficient",["CVMASS","Cvmass","O"],"J/kg/K","O",false,"Mass specific constant volume specific heat",["CVMOLAR","Cvmolar"],"J/mol/K","O",false,"Molar specific constant volume specific heat",["C","CPMASS","Cpmass"],"J/kg/K","O",false,"Mass specific constant pressure specific heat",["DALPHA0_DDELTA_CONSTTAU","dalpha0_ddelta_consttau"],"","O",false,"Derivative of ideal Helmholtz energy with delta",["DALPHA0_DTAU_CONSTDELTA","dalpha0_dtau_constdelta"],"","O",false,"Derivative of ideal Helmholtz energy with tau",["DALPHAR_DDELTA_CONSTTAU","dalphar_ddelta_consttau"],"","O",false,"Derivative of residual Helmholtz energy with delta",["DALPHAR_DTAU_CONSTDELTA","dalphar_dtau_constdelta"],"","O",false,"Derivative of residual Helmholtz energy with tau",["DBVIRIAL_DT","dBvirial_dT"],"","O",false,"Derivative of second virial coefficient with respect to T",["DCVIRIAL_DT","dCvirial_dT"],"","O",false,"Derivative of third virial coefficient with respect to T",["DIPOLE_MOMENT","dipole_moment"],"C m","O",true,"Dipole moment",["FH"],"","O",true,"Flammability hazard",["FRACTION_MAX","fraction_max"],"","O",true,"Fraction (mole, mass, volume) maximum value for incompressible solutions",["FRACTION_MIN","fraction_min"],"","O",true,"Fraction (mole, mass, volume) minimum value for incompressible solutions",["FUNDAMENTAL_DERIVATIVE_OF_GAS_DYNAMICS","fundamental_derivative_of_gas_dynamics"],"","O",false,"Fundamental derivative of gas dynamics",["GAS_CONSTANT","gas_constant"],"J/mol/K","O",true,"Molar gas constant",["GMOLAR","Gmolar"],"J/mol","O",false,"Molar specific Gibbs energy",["GWP100"],"","O",true,"100-year global warming potential",["GWP20"],"","O",true,"20-year global warming potential",["GWP500"],"","O",true,"500-year global warming potential",["G"," GMASS","Gmass"],"J/kg","O",false,"Mass specific Gibbs energy",["HELMHOLTZMASS","Helmholtzmass"],"J/kg","O",false,"Mass specific Helmholtz energy",["HELMHOLTZMOLAR","Helmholtzmolar"],"J/mol","O",false,"Molar specific Helmholtz energy",["HH"],"","O",true,"Health hazard",["ISOBARIC_EXPANSION_COEFFICIENT","isobaric_expansion_coefficient"],"1/K","O",false,"Isobaric expansion coefficient",["ISOTHERMAL_COMPRESSIBILITY","isothermal_compressibility"],"1/Pa","O",false,"Isothermal compressibility",["I","SURFACE_TENSION","surface_tension"],"N/m","O",false,"Surface tension",["M","MOLARMASS","MOLAR_MASS","MOLEMASS","molar_mass","molarmass","molemass"],"kg/mol","O",true,"Molar mass",["ODP"],"","O",true,"Ozone depletion potential",["PCRIT","P_CRITICAL","Pcrit","p_critical","pcrit"],"Pa","O",true,"Pressure at the critical point",["PHASE","Phase"],"","O",false,"Phase index as a float",["PH"],"","O",true,"Physical hazard",["PIP"],"","O",false,"Phase identification parameter",["PMAX","P_MAX","P_max","pmax"],"Pa","O",true,"Maximum pressure limit",["PMIN","P_MIN","P_min","pmin"],"Pa","O",true,"Minimum pressure limit",["PRANDTL","Prandtl"],"","O",false,"Prandtl number",["PTRIPLE","P_TRIPLE","p_triple","ptriple"],"Pa","O",true,"Pressure at the triple point (pure only)",["P_REDUCING","p_reducing"],"Pa","O",true,"Pressure at the reducing point",["RHOCRIT"," RHOMASS_CRITICAL","rhocrit","rhomass_critical"],"kg/m^3","O",true,"Mass density at critical point",["RHOMASS_REDUCING","rhomass_reducing"],"kg/m^3","O",true,"Mass density at reducing point",["RHOMOLAR_CRITICAL","rhomolar_critical"],"mol/m^3","O",true,"Molar density at critical point",["RHOMOLAR_REDUCING","rhomolar_reducing"],"mol/m^3","O",true,"Molar density at reducing point",["SMOLAR_RESIDUAL","Smolar_residual"],"J/mol/K","O",false,"Residual molar entropy (sr/R = tau*dar_dtau-ar)",["TCRIT","T_CRITICAL","T_critical","Tcrit"],"K","O",true,"Temperature at the critical point",["TMAX","T_MAX","T_max","Tmax"],"K","O",true,"Maximum temperature limit",["TMIN","T_MIN","T_min","Tmin"],"K","O",true,"Minimum temperature limit",["TTRIPLE"," T_TRIPLE"," T_triple","Ttriple"],"K","O",true,"Temperature at the triple point",["T_FREEZE","T_freeze"],"K","O",true,"Freezing temperature for incompressible solutions",["T_REDUCING","T_reducing"],"K","O",true,"Temperature at the reducing point",["V","VISCOSITY","viscosity"],"Pa s","O",false,"Viscosity",["Z"],"","O",false,"Compressibility factor"],(5,73));
const buggy = ["DIPOLE_MOMENT","FRACTION_MAX","FRACTION_MIN","GWP100","GWP20","GWP500","ODP","RHOMASS_REDUCING","T_FREEZE"]
const inputparamsindex = [[2,3], [4,5], 6, 7, [8,9], 11, [12,13]];
#CoolProp
@static is_apple() ? println("CoolProp: no osx support") : begin
  #Trivial inputs
  i=1
  while i<size(parameters)[2]
    p = (parameters[[1,4],i]);
    if (p[1][1] in buggy)
      for fluid in fluids
        try
          res = ("$(PropsSI(p[1][1], fluid))")
          #println("$(p[1][1]) $fluid")
        catch err
        end
      end
    end
    if p[2] & !(p[1][1] in buggy)
      for fluid in fluids
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
