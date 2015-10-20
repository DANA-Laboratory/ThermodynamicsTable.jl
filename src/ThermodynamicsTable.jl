include("CapeOpen.jl")
include("PhysicalPropertyCalculator.jl")
module ThermodynamicsTable

  using CapeOpen

  export perryanalytic,getconstpropdata,gettemppropdata

  thisfiledirname=dirname(@__FILE__())

  function getdatamatrix(path::AbstractString)
    file=open(thisfiledirname * "/Tables/"*path);
    matrix=readdlm(file,';',header=false);
    close(file)
    return matrix
  end

  function getconstpropdata(proppackage::PropertyPackage, prop::ASCIIString, compId::Int)
    data::Array{Float64,2}
    data=proppackage.propertytable[proppackage.tempreturedependents[prop]]
    return data[findfirst(data[:,1],compId),1]
  end
  
  function getdataeqno(data::Array{Float,2}, prop::ASCIIString)
    (prop=="volumeOfLiquid" || prop=="heatCapacityOfLiquid" || prop=="idealGasHeatCapacity") && (retrun data[i,3:end-1],data[i,end])
    return data[i,3:end],0
  end
   
  function gettemppropdata(proppackage::PropertyPackage, prop::ASCIIString, compId::Int)
    data::Array{Float64,2}
    ret::Vector{TempPropData}
    ret=Vector{TempPropData}()
    data=proppackage.propertytable[proppackage.tempreturedependents[prop]]
    datarange=getdataeqno(data,prop)
    for i in data[:,1]
      if i==compId
        tpd=TempPropData(prop,datarange[1],NaN,NaN,data[i,1],datarange[2])
        push!(ret,tpd)
      end
    end
    return ret
  end
  getcompond(data::Array{Float64,2},compId::Float64) = findfirst(data[:,1],compId)

  propmap(stvec,t)=[cs=>t[ind] for (ind,cs) in enumerate(stvec)]

  function PropertyPackage(constantstrings,t1,constantfloats,t2,tempreturedependents,t3,pressuredependents,t4,propertytofilemap)
    propertytofilemap = [key => getdatamatrix(propertytofilemap[key]) for key in keys(propertytofilemap)]
    println(typeof(propmap(constantstrings,t1,f1,tu1)))
    CapeOpen.PropertyPackage(
      propmap(constantstrings,t1),
      propmap(constantfloats,t2),
      propmap(tempreturedependents,t3),
      propmap(pressuredependents,t4),
      propertytofilemap
    )
  end

  perryanalytic=PropertyPackage(
    getindex(constantstrings,1:3),
    ["Compounds" for i=1:3],
    getindex(constantfloats,[ 5,6,7,8,9,15,16,17,18,
                                20,21,24,28,31]),         
    ["Criticals", "Criticals", "Criticals", "Criticals", "Criticals", "VaporizHeat", "FormationEnergy", "LiquidsDensities", "LiquidsDensities",
     "Compounds", "Compounds", "FormationEnergy", "FormationEnergy", "FormationEnergy"],
    getindex(tempreturedependents,[6,11,12,13,14,21,23,24,26,27,32]),
    ["LiquidsCp", "VaporizHeat", "CpHyper", "CpHyper", "CpHyper", "LiquidThermal", "VaporThermal", "VaporPressure", "LiquidViscos", "VaporViscos", "LiquidsDensities"],
    ASCIIString[],
    [],
    Dict(
      "Compounds"=>"perryFormulaCompounds.table",
      "VaporPressure"=>"perryLiquidsVaporPressure_Table2_8.table",
      "LiquidsDensities"=>"perryDensities_Table2_32.table",
      "Criticals"=>"perryCriticals_Table2_141.table",
      "VaporizHeat"=>"perryHeatsofVaporization_Table2_150.table",
      "LiquidsCp"=>"perryHeatCapLiquids_Table2_153.table",
      "CpPoly"=>"perryHeatCapIdealGas_Table2_155.table",
      "CpHyper"=>"perryHeatCapIdealGas_Table2_156.table",
      "FormationEnergy"=>"perryEnergiesOfFormation_Table2_179.table",
      "VaporViscos"=>"perryVaporViscosity_Table2_312.table",
      "LiquidViscos"=>"perryLiquidViscosity_Table2_313.table",
      "VaporThermal"=>"perryVaporThermalConductivity_Table2_314.table",
      "LiquidThermal"=>"perryLiqidThermalConductivity_Table2_315.table"
    )
  )

end

include("ECapeExceptions.jl")
include("ICapeThermoCompounds.jl")
include("ICapeThermoMaterial.jl")
include("ICapeThermoPhases.jl")
include("ICapeThermoPropertyRoutine.jl")
include("ICapeThermoUniversalConstants.jl")