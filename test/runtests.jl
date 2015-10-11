using ThermodynamicsTable
using ICapeThermoUniversalConstants
using ICapeThermoCompounds
import ECapeExceptions.ECapeInvalidArgument
import CapeOpen: MaterialObject, PropertyPackage
using Base.Test


println(getuniversalconstantlist())
@test_throws ECapeInvalidArgument (getuniversalconstant("avogadroConstan"))
@test getuniversalconstant("avogadroConstant") == 6.0221419947e23
@test length(getconstproplist(perryanalytic)) == 22
@test length(gettdependentproplist(perryanalytic)) == 12
@test length(getpdependentproplist(perryanalytic)) == 0
@test getnumcompounds(perryanalytic) == 345
compIds,formulae,names,boilTemps,molwts,casnos = getcompoundlist(perryanalytic)
