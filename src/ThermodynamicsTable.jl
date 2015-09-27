module ThermodynamicsTable
  export getformulaforname, getvalueforname, getnameforcasno, getnameforformula, getallnamesforproperty
  thisfiledirname=dirname(@__FILE__())
  fhyper=nothing #cp hyper fit
  fcriti=nothing #criticals
  fpoly=nothing #cp polinomial fit
  fdens=nothing #densities
  flvps=nothing #liquids vapor pressure
  flcp=nothing #liquids heat capacity
  propertytofilemap=[
    "CpPoly"=>("perryHeatCapIdealGas_Table2_155.table",fpoly),
    "CpHyper"=>("perryHeatCapIdealGas_Table2_156.table",fhyper),
    "Criticals"=>("perryCriticals_Table2_141.table",fcriti),
    "Profile"=>("perryCriticals_Table2_141.table",fcriti),
    "LiquidsDensities"=>("perryDensities_Table2_32.table",fdens),
    "LiquidsVaporPressure"=>("perryLiquidsVaporPressure_Table2_8.table",flvps),
    "LiquidsCp"=>("perryHeatCapLiquids_Table2_153.table",flcp)
  ]
  #open table if not loaded private
  function getdatamatrix(property::String)
    global propertytofilemap
    glob=propertytofilemap[property][2];
    if (glob==nothing)
        file=open(thisfiledirname * "/Tables/"*propertytofilemap[property][1]);
        glob,head=readdlm(file,';',header=true);
        close(file)
    end
    return glob
  end
  function findindex(data::Array{Any,2},keyvalue::String,keycolumnindex=2)
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
  
  function getformulaforname(property::String , name::String)
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
  
  function getvalueforname(property::String , name::String)
    global propertytofilemap
    if !haskey(propertytofilemap,property)
      throw(ArgumentError)
    end
    data=getdatamatrix(property)
    i=findindex(data,name)
    if i==0
      throw(KeyError);
    end
		if property=="CpPoly"
      return (data[i,6],data[i,7],data[i,8],data[i,13]/1e5,data[i,14]/1e10) 
		elseif property=="CpHyper"
      return (data[i,6]*1e5,data[i,7]*1e5,data[i,8]*1e3,data[i,9]*1e5,data[i,10])
		elseif property=="Criticals"
        # Tc, Pc, Af, Zc
        return (data[i,6],data[i,7]*1e6,data[i,10],data[i,9])
 		elseif property=="LiquidsDensities"
        return (data[i,6],data[i,7],data[i,8],data[i,9],data[i,10],data[i,12])
 		elseif property=="LiquidsVaporPressure"
        return (data[i,5],data[i,6],data[i,7],data[i,8],data[i,9],data[i,10],data[i,12])
 		elseif property=="LiquidsCp"
        return (data[i,6],data[i,7],data[i,8],data[i,9],data[i,10],data[i,11],data[i,13])
    elseif property=="Profile"
        return (data[i,3],data[i,4],data[i,5])
		end
  end
end
