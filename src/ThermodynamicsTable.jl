module ThermodynamicsTable
  export getvalueforname, getnameforcasno, getnameforformula, getallnamesforproperty
  thisfiledirname=dirname(@__FILE__())
  fhyper=nothing #cp hyper fit
  fcriti=nothing #criticals
  fpoly=nothing #cp polinomial fit
  fdens=nothing #densities
  flvps=nothing #liquids vapor pressure
  flcp=nothing #liquids heat capacity

  #open table if not loaded
  function getdatamatrix(name::String)
    global fpoly,fhyper,fcriti,fdens,flvps,flcp
    if (name=="fpoly")
      if (fpoly==nothing)
        cp_polynomial=open(thisfiledirname * "/Tables/perryHeatCapIdealGas_Table2_155.table");
        fpoly,hpoly=readdlm(cp_polynomial,';',header=true);
        close(cp_polynomial)
      end
      return fpoly
    elseif (name=="fhyper")
      if (fhyper==nothing)
        cp_hyperbolic=open(thisfiledirname * "/Tables/perryHeatCapIdealGas_Table2_156.table");
        fhyper,hhyper=readdlm(cp_hyperbolic,';',header=true);
        close(cp_hyperbolic)
      end
      return fhyper
    elseif (name=="fcriti")
      if (fcriti==nothing)
        criticals_af=open(thisfiledirname * "/Tables/perryCriticals_Table2_141.table");
        fcriti,hcriti=readdlm(criticals_af,';',header=true);
        close(criticals_af)
      end
      return fcriti
    elseif (name=="fdens")
      if (fdens==nothing)
        densities_af=open(thisfiledirname * "/Tables/perryDensities_Table2_32.table");
        fdens,hdens=readdlm(densities_af,';',header=true);
        close(densities_af)
      end
      return fdens
    elseif (name=="flvps")
      if (flvps==nothing)
        vaporpressures_af=open(thisfiledirname * "/Tables/perryLiquidsVaporPressure_Table2_8.table");
        flvps,hlvps=readdlm(vaporpressures_af,';',header=true);
        close(vaporpressures_af)
      end
      return flvps;
    elseif (name=="flcp")
      if (flcp==nothing)
        liquidscp_af=open(thisfiledirname * "/Tables/perryHeatCapLiquids_Table2_153.table");
        flcp,hlcp=readdlm(liquidscp_af,';',header=true);
        close(liquidscp_af)
      end
      return flcp
    else
      throw (ArgumentError)
    end
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
      throw (KeyError);
    end
  end
  function getnameforcasno(casno::String)
    data_criti=getdatamatrix("fcriti")
    i=findindex(data_criti,casno,4)
    return (data_criti[i,2]) 
  end
  function getnameforformula(formula::String)
    data_criti=getdatamatrix("fcriti")
    i=findindex(data_criti,formula,3)
    return data_criti[i,2] 
  end
  function getallnamesforproperty(property::String)
    names=String[]
		if property=="CpPoly"
      data=getdatamatrix("fpoly")
		elseif property=="CpHyper"
      data=getdatamatrix("fhyper")
		elseif property=="Criticals"
      data=getdatamatrix("fcriti")
    elseif property=="Profile"
      data=getdatamatrix("fcriti")
    elseif property=="LiquidsDensities"
      data=getdatamatrix("fdens")
    elseif property=="LiquidsVaporPressure"
      data=getdatamatrix("flvps")
    elseif property=="LiquidsCp"
      data=getdatamatrix("flcp")
    else
      throw (ArgumentError)
    end
    i=1
    len=size(data)[1]
    while i<=len
      push!(names,data[i,2])
      i+=1
    end
    return names
  end
  function getvalueforname(property::String , name::String)
		if property=="CpPoly"
      data_poly=getdatamatrix("fpoly")
      i=findindex(data_poly,name)
			if i>0 
        return (data_poly[i,6],data_poly[i,7],data_poly[i,8],data_poly[i,13]/1e5,data_poly[i,14]/1e10) 
      else
        return nothing,name * " not exists"
      end
		elseif property=="CpHyper"
      data_hyper=getdatamatrix("fhyper")
      i=findindex(data_hyper,name)
			if i>0 
        return (data_hyper[i,6]*1e5,data_hyper[i,7]*1e5,data_hyper[i,8]*1e3,data_hyper[i,9]*1e5,data_hyper[i,10])
      else
        return nothing,name * " not exists" 
      end
		elseif property=="Criticals"
      data_criti=getdatamatrix("fcriti")
      i=findindex(data_criti,name)
			if i>0 
        # Tc, Pc, Af, Zc
        return (data_criti[i,6],data_criti[i,7]*1e6,data_criti[i,10],data_criti[i,9])
      else
        return nothing,name * " not exists"
      end
 		elseif property=="LiquidsDensities"
      data_dens=getdatamatrix("fdens")
      i=findindex(data_dens,name)
			if i>0 
        return (data_dens[i,6],data_dens[i,7],data_dens[i,8],data_dens[i,9])
      else
        return nothing,name * " not exists"
      end
 		elseif property=="LiquidsVaporPressure"
      data_lvps=getdatamatrix("flvps")
      i=findindex(data_,name)
			if i>0 
        return (data_lvps[i,5],data_lvps[i,6],data_lvps[i,7],data_lvps[i,8],data_lvps[i,9])
      else
        return nothing,name * " not exists"
      end
 		elseif property=="LiquidsCp"
      data_lcp=getdatamatrix("flcp")
      i=findindex(data_,name)
			if i>0 
        return (data_lcp[i,6],data_lcp[i,7],data_lcp[i,8],data_lcp[i,9],data_lcp[i,10])
      else
        return nothing,name * " not exists"
      end
    elseif property=="Profile"
      data_criti=getdatamatrix("fcriti")
      i=findindex(data_criti,name)
			if i>0
        return (data_criti[i,3],data_criti[i,4],data_criti[i,5])
      else
        throw (ArgumentError)
      end
		end
  end
end
