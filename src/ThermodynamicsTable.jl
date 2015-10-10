module ThermodynamicsTable
  export getexpressionforname, getvalueforname, getnameforcasno, getnameforformula, getallnamesforproperty
  thisfiledirname=dirname(@__FILE__())
  flvps=nothing #liquids vapor pressure
  fdens=nothing #densities
  fcriti=nothing #criticals
  fvapheat=nothing #
  flcp=nothing #liquids heat capacity
  fpoly=nothing #cp polinomial fit
  fhyper=nothing #cp hyper fit
  fform=nothing #
  fvapvis=nothing #
  fliqvis=nothing #
  fvaptherm=nothing #
  fliqtherm=nothing #
  propertytofilemap=[
    "LiquidsVaporPressure"=>("perryLiquidsVaporPressure_Table2_8.table",flvps),
    "LiquidsDensities"=>("perryDensities_Table2_32.table",fdens),
    "Criticals"=>("perryCriticals_Table2_141.table",fcriti),
    "Profile"=>("perryFormulaComponents.table",fcriti),
    "VaporizHeat"=>("perryHeatsofVaporization_Table2_150.table",fvapheat),
    "LiquidsCp"=>("perryHeatCapLiquids_Table2_153.table",flcp),
    "CpPoly"=>("perryHeatCapIdealGas_Table2_155.table",fpoly),
    "CpHyper"=>("perryHeatCapIdealGas_Table2_156.table",fhyper),
    "FormationEnergy"=>("perryEnergiesOfFormation_Table2_179.table",fform),
    "VaporViscos"=>("perryVaporViscosity_Table2_312.table",fvapvis),
    "LiquidViscos"=>("perryLiquidViscosity_Table2_313.table",fliqvis),
    "VaporThermal"=>("perryVaporThermalConductivity_Table2_314.table",fvaptherm),
    "LiquidThermal"=>("perryLiqidThermalConductivity_Table2_315.table",fliqtherm)
  ]
  
  # open table if not loaded (private)
  function getdatamatrix(property::String)
    global propertytofilemap
    glob=propertytofilemap[property][2];
    if (glob==nothing)
        file=open(thisfiledirname * "/Tables/"*propertytofilemap[property][1]);
        glob=readdlm(file,';',header=false);
        close(file)
    end
    return glob
  end
  
  # find first occurance of compIds first column of data
  function findindex(data::Array{Any,2},compId::Float64)
    len=size(data)[1]
		i=1
		while (i<=len && data[i,keycolumnindex]!=keyvalue) 
		 i+=1;
		end
		if (i<=len)
      return i
    else
      return 0;
    end
  end
  
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
      return "$C1+$C2*T+$C3*T^2+$C4*T^3+$C5*T^4"
    elseif property=="CpHyper"
      (C1, C2, C3, C4, C5) = conststuple
      return "$C1+$C2*(($C3/T)/sinh($C3/T))^2+$C4*(($C5/T)/cosh($C5/T))^2"
    elseif property=="LiquidsDensities"
      (C1, C2, C3, C4, Tmin, Tmax) = conststuple
      if name=="Water"
        τ="(1−T/647.096)"
        return "17.863+58.606$τ^0.35−95.396$τ^(2/3)+213.89$τ−141.26$τ^(4/3)" #Water
      elseif (name=="o-Terphenyl [note: limited range]" || name=="Water [note: limited range]")
        return "$C1+$C2*T+$C3*T^2+$C4*T^3"
      else
        return "$C1/($C2^(1+(1-T/$C3)^$C4))" 
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
end
include("CapeOpen.jl")