using Base.Test
using ThermodynamicsTable,ICapeThermoUniversalConstants,ICapeThermoCompounds,ECapeExceptions,PhysicalPropertyCalculator
import CapeOpen: MaterialObject, PropertyPackage
import ICapeThermoCompounds.TempPropData
using CoolProp

#ICapeThermoUniversalConstants
universalconstantlist=getuniversalconstantlist()
println("universalconstantlist=",universalconstantlist)
@test_throws ECapeInvalidArgument (getuniversalconstant("avogadroConstan"))
@test getuniversalconstant("avogadroConstant") == 6.0221419947e23

#ICapeThermoCompounds
constproplist=getconstproplist()
@test length(constproplist) == 17
println("constproplist=",constproplist)
tdependentproplist=gettdependentproplist()
@test length(tdependentproplist) == 11
println("tdependentproplist=",tdependentproplist)
pdependentproplist=getpdependentproplist()
@test length(pdependentproplist) == 1
@test getnumcompounds() == 345
compIds,formulae,names,boilTemps,molwts,casnos=getcompoundlist();
comps=UInt16[findfirst(names,name) for name in ["Air","Water","Nitrogen"]];
propvals=Vector{Union{ASCIIString,Float64}}();
@test_throws ECapeThrmPropertyNotAvailable getcompoundconstant!(["casRegistryNumber","chemicalFormula","criticalPressure","liquidDensityAt25C"],comps,propvals)
allconstants=Vector{Union{ASCIIString,Float64}}()
@test_throws ECapeThrmPropertyNotAvailable getcompoundconstant!(constproplist,compIds,allconstants)
@test length(allconstants) == length(constproplist)*length(compIds)
propvals=Vector{Float64}()
getpdependentproperty!(["boilingPointTemperature"],80000.,comps,propvals)
propvals=Vector{Float64}()
@test_throws ECapeThrmPropertyNotAvailable gettdependentproperty!(tdependentproplist,300.,compIds,propvals)

#CoolProp
@test_approx_eq 373.1242958476879 PropsSI("T","P",101325.0,"Q",0.0,"Water")