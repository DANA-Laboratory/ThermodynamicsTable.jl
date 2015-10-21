using ThermodynamicsTable
using ICapeThermoUniversalConstants
using ICapeThermoCompounds
import ECapeExceptions.ECapeInvalidArgument
import CapeOpen: MaterialObject, PropertyPackage
using Base.Test

perryanalytic = CapeOpen.perryanalytic

println(getuniversalconstantlist())
@test_throws ECapeInvalidArgument (getuniversalconstant("avogadroConstan"))
@test getuniversalconstant("avogadroConstant") == 6.0221419947e23
constproplist=getconstproplist(perryanalytic)
@test length(constproplist) == 17
tdependentproplist=gettdependentproplist(perryanalytic)
@test length(tdependentproplist) == 11
pdependentproplist=getpdependentproplist(perryanalytic)
@test length(pdependentproplist) == 0
@test getnumcompounds(perryanalytic) == 345
compIds,formulae,names,boilTemps,molwts,casnos = getcompoundlist(perryanalytic)
getcompoundconstant(perryanalytic,constproplist,compIds)