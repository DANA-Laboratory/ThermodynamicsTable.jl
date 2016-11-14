# Original file is a part of CoolProp project http://www.coolprop.org/coolprop/wrappers/Julia/index.html#julia
push!(Libdl.DL_LOAD_PATH, abspath(joinpath(@__FILE__,"..","..","lib")));
module CoolPropDefs
export coolproptrivialparameters, coolpropmapping
const coolproptrivialparameters = ["ACENTRIC", "DIPOLE_MOMENT", "FH", "FRACTION_MAX", "FRACTION_MIN",
  "GAS_CONSTANT", "GWP100", "GWP20", "GWP500", "HH", "M", "ODP", "PCRIT", "PH", "PMAX", "PMIN", "PTRIPLE",
  "P_REDUCING", "RHOCRIT", "RHOMASS_REDUCING", "RHOMOLAR_CRITICAL", "RHOMOLAR_REDUCING", "TCRIT", "TMAX",
  "TMIN", "TTRIPLE", "T_FREEZE", "T_REDUCING"];
const coolpropmapping = Dict("molarGasConstant"=>"gas_constant");
end
include("../lib/CoolProp.jl")
