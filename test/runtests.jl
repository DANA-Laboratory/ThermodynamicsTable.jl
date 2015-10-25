using Base.Test
using ThermodynamicsTable

using ICapeThermoUniversalConstants
using ICapeThermoCompounds
import ECapeExceptions.ECapeInvalidArgument
import CapeOpen: MaterialObject, PropertyPackage

perryanalytic = CapeOpen.perryanalytic

#ICapeThermoUniversalConstants
universalconstantlist=getuniversalconstantlist()
println("universalconstantlist=",universalconstantlist)
@test_throws ECapeInvalidArgument (getuniversalconstant("avogadroConstan"))
@test getuniversalconstant("avogadroConstant") == 6.0221419947e23

#ICapeThermoCompounds
constproplist=getconstproplist(perryanalytic)
@test length(constproplist) == 17
println("constproplist=",constproplist)

tdependentproplist=gettdependentproplist(perryanalytic)
@test length(tdependentproplist) == 11
println("tdependentproplist=",tdependentproplist)

pdependentproplist=getpdependentproplist(perryanalytic)
@test length(pdependentproplist) == 0

@test getnumcompounds(perryanalytic) == 345

compIds,formulae,names,boilTemps,molwts,casnos = getcompoundlist(perryanalytic)

allconstants = getcompoundconstant(perryanalytic,constproplist,compIds)
@test length(allconstants) == length(constproplist)*length(compIds)

gettdependentproperty(perryanalytic,tdependentproplist,300.,compIds)



