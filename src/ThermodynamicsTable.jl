module ThermodynamicsTable
  export getvalueforcasno, getcasnoforname, getcasnoforformula
  thisfiledirname=dirname(@__FILE__())
  cp_polynomial=open(thisfiledirname * "/Tables/perryHeatCapIdealGas_Table2_155.table");
  cp_hyperbolic=open(thisfiledirname * "/Tables/perryHeatCapIdealGas_Table2_156.table");
  criticals_af=open(thisfiledirname * "/Tables/perryCriticals_Table2_141.table");
  data_poly,header_poly=readdlm(cp_polynomial,';',header=true);
  data_hyper,header_hyper=readdlm(cp_hyperbolic,';',header=true);
  data_criti,header_criti=readdlm(criticals_af,';',header=true);
  close(cp_polynomial)
  close(cp_hyperbolic)
  close(criticals_af)
  function findindex(data::Array{Any,2},keyvalue,keycolumnindex=4)
    length=size(data)[1]
		i=1
		while (i<=length && data[i,keycolumnindex]!=keyvalue) 
			i+=1;
		end
		if (i<=length)
      return i
    else
      return 0;
    end
  end
  function getcasnoforname(name::String)
    i=findindex(data_criti,name,2)
    if i>0 
      return (data_criti[i,4]) 
    else 
      return (nothing,name * " not exists")
    end
  end
  function getcasnoforformula(formula::String)
    i=findindex(data_criti,formula,3)
    if i>0 
      return data_criti[i,4] 
    else
      return nothing,formula * " not exists"
    end
  end
  function getvalueforcasno(property::String , casno::String)
		if property=="CpPoly"
      i=findindex(data_poly,casno)
			if i>0 
        return (data_poly[i,6],data_poly[i,7],data_poly[i,8],data_poly[i,13]/1e5,data_poly[i,14]/1e10) 
      else
        return nothing,casno * " not exists"
      end
		elseif property=="CpHyper"
      i=findindex(data_hyper,casno)
			if i>0 
        return (data_hyper[i,6]*1e5,data_hyper[i,7]*1e5,data_hyper[i,8]*1e3,data_hyper[i,9]*1e5,data_hyper[i,10])
      else
        return nothing,casno * " not exists" 
      end
		elseif property=="Criticals"
      i=findindex(data_criti,casno)
			if i>0 
        return (data_criti[i,6],data_criti[i,7]*1e6,data_criti[i,10])
      else
        return nothing,casno * " not exists"
      end
    elseif property=="Profile"
      i=findindex(data_criti,casno)
			if i>0
        return (data_criti[i,2],data_criti[i,3],data_criti[i,5])
      else
        return nothing,casno * " not exists"
      end
		end
  end
end
