include("CapeOpen.jl")
include("PhysicalPropertyCalculator.jl")
module ThermodynamicsTable

  using CapeOpen, Compat

  export perryanalytic
  
  thisfiledirname=dirname(@__FILE__())

  function getdatamatrix(path::String)
    file=open(thisfiledirname * "/Tables/"*path);
    matrix=readdlm(file,';',header=false);
    close(file)
    return matrix
  end

  findindex(data::Array{Float64,2},compId::Float64) = findfirst(data[:,1],compId)

  function PropertyPackage(constantstrings,constantfloats,tempreturedependents,pressuredependents,compondlist,propertytofilemap) 
    propertytofilemap = [key => getdatamatrix(propertytofilemap[key]) for key in keys(propertytofilemap)]
    CapeOpen.PropertyPackage(constantstrings,constantfloats,tempreturedependents,pressuredependents,compondlist,propertytofilemap) 
  end

  perryanalytic=PropertyPackage(
    getindex(constantstrings,1:3),
    getindex(constantfloats,[5,6,7,8,9,15,16,17,18,20,21,24,25,28,29,31,32,35,36]),
    getindex(tempreturedependents,[6,11,12,13,14,21,23,24,26,27,31,32]),
    [],
    getdatamatrix("perryFormulaComponents.table"),
    @compat Dict(
      "LiquidsVaporPressure"=>"perryLiquidsVaporPressure_Table2_8.table",
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


#=  
"""
    function getnameforcasno(casno::String)
      data_criti=getdatamatrix("Profile")
      i=findindex(data_criti,casno,4)
      if i==0    
        throw(KeyError);
      end
      return (data_criti[i,2]) 
    end
    
    function getnameforformula(formula::String)
      data_criti=getdatamatrix("Profile")
      i=findindex(data_criti,formula,3)
      if i==0    
        throw(KeyError);
      end
      return data_criti[i,2] 
    end
    
    function getallnamesforproperty(property::String)
      global propertytofilemap
      if !haskey(propertytofilemap,property)
        throw(ArgumentError)
      end
      names=String[]
      data=getdatamatrix(property);
      i=1
      len=size(data)[1]
      while i<=len
        push!(names,data[i,2])
        i+=1
      end
      return names
    end
    
    function getexpressionforname(property::String , name::String)
      conststuple::Tuple = getvalueforname(property, name)
      if property=="CpPoly"
        (C1, C2, C3, C4, C5) = conststuple
        return "C1+C2*T+C3*T^2+C4*T^3+C5*T^4"
      elseif property=="CpHyper"
        (C1, C2, C3, C4, C5) = conststuple
        return "C1+C2*((C3/T)/sinh(C3/T))^2+C4*((C5/T)/cosh(C5/T))^2"
      elseif property=="LiquidsDensities"
        (C1, C2, C3, C4, Tmin, Tmax) = conststuple
        if name=="Water"
          τ="(1-T/647.096)"
          return "17.863+58.606τ^0.35-95.396τ^(2/3)+213.89τ-141.26τ^(4/3)" #Water
        elseif (name=="o-Terphenyl [note: limited range]" || name=="Water [note: limited range]")
          return "C1+C2*T+C3*T^2+C4*T^3"
        else
          return "C1/(C2^(1+(1-T/C3)^C4))" 
        end
      end
    end
    
    function getvalueforname(property::String , compId::Int)
      global propertytofilemap
      if !haskey(propertytofilemap,property)
        throw(ArgumentError)
      end
      data=getdatamatrix(property)
      i=findindex(data,compId)
      if i==0
        throw(KeyError);
      end
      if property=="CpPoly"
        return (data[i,2],data[i,3],data[i,4],data[i,9]/1e5,data[i,10]/1e10) 
      elseif property=="CpHyper"
        return (data[i,2]*1e5,data[i,3]*1e5,data[i,4]*1e3,data[i,5]*1e5,data[i,6])
      elseif property=="Criticals"
          # Tc, Pc, Af, Zc
          return (data[i,3],data[i,4]*1e6,data[i,7],data[i,6])
      elseif property=="LiquidsDensities"
          return (data[i,2],data[i,3],data[i,4],data[i,5],data[i,6],data[i,8])
      elseif property=="LiquidsVaporPressure"
          return (data[i,2],data[i,3],data[i,4],data[i,5],data[i,6],data[i,7],data[i,9])
      elseif property=="LiquidsCp"
          return (data[i,2],data[i,3],data[i,4],data[i,5],data[i,6],data[i,7],data[i,9])
      elseif property=="Profile"
          return (data[i,1],data[i,2],data[i,3],data[i,4])
      end
    end
  
"""
=#
