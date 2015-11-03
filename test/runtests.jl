using Base.Test
using ThermodynamicsTable,ICapeThermoUniversalConstants,ICapeThermoCompounds,ECapeExceptions,PhysicalPropertyCalculator
import CapeOpen: MaterialObject, PropertyPackage
import ICapeThermoCompounds.TempPropData

compIds,formulae,names,boilTemps,molwts,casnos=getcompoundlist();
comps=UInt16[findfirst(names,name) for name in ["Air","Water","Nitrogen"]];
propvals=Vector{Union{ASCIIString,Float64}}();
@test_throws ECapeThrmPropertyNotAvailable getcompoundconstant!(["casRegistryNumber","chemicalFormula","criticalPressure","liquidDensityAt25C"],comps,propvals)
propvals=Vector{Float64}()
getpdependentproperty!(["boilingPointTemperature"],80000.,comps,propvals)
#=
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
  @test length(pdependentproplist) == 0

  @test getnumcompounds() == 345

  compIds,formulae,names,boilTemps,molwts,casnos = getcompoundlist()

  allconstants = propvals::Vector{Union{ASCIIString,Float64}}()
  getcompoundconstant!(constproplist,compIds,allconstants)
  @test length(allconstants) == length(constproplist)*length(compIds)

  gettdependentproperty(tdependentproplist,300.,compIds)
  j=1

  for prop in tdependentproplist
    unc::Float64=ICapeThermoCompounds.unitconvertion(prop)
    fac=1.1
    if (prop=="idealGasHeatCapacity" || prop=="heatCapacityOfLiquid")
      fac=1e-5;
    end
    maxrow=0%UInt8
    (prop in ["idealGasHeatCapacity", "volumeOfLiquid", "heatCapacityOfLiquid"]) && (maxrow=1%UInt8)
    for compId in compIds
      for (rowdata=0%UInt8:maxrow)
        temppropdata=nothing
        try
          temppropdata=TempPropData(prop,compId,rowdata)
        catch err
          break
        end
        rowdata==1%UInt8 && println(" ************ $compId ************ $prop ************ ")
        for i in [1,3]
          try
            r::Float64
            if(isdefined(temppropdata,:test))
              temppropdata.t=temppropdata.test[i]
              r=calculate(temppropdata)*fac/unc
              err=abs((r-temppropdata.test[i+1])/r)
              if err>0.01
                if (err>0.1) 
                  println("$j EEEEEERRRRRRRRRRRORRRRRRRRRRRRRR")
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
  end
=#
