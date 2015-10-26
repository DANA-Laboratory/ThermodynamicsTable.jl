using Base.Test
using ThermodynamicsTable,ICapeThermoUniversalConstants,ICapeThermoCompounds,ECapeExceptions,PhysicalPropertyCalculator
import CapeOpen: MaterialObject, PropertyPackage
import ICapeThermoCompounds.TempPropData

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
j=1
for prop in tdependentproplist
  fac=1.1
  if (prop=="idealGasHeatCapacity" || prop=="heatCapacityOfLiquid")
    fac=1e-5;
  end
  for compId in compIds
    temppropdata::TempPropData
    temppropdata=TempPropData(perryanalytic,prop,compId)
    for i in [1,3]
      try
        r::Float64
        if(isdefined(temppropdata,:test))
          temppropdata.t=temppropdata.test[i]
          r=calculate(temppropdata)*fac
          err=abs((r-temppropdata.test[i+1])/r)
          if err>0.01
            if (err>0.1) 
              println("$j ERRRRRRRRRRRRRRRRRRORRRRRRRRRRRRRR")
              println("$r!=$(temppropdata.test[i+1]), $err")
              dump(temppropdata)
              j+=1
            end
          end
        end
      catch err
        if isa(err,ECapeOutOfBounds)
          NaN
        else
          throw(err)
        end
      end
    end
  end
end

