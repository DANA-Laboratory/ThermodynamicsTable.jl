module ThermodynamicsTable
  export getValueForCasNo
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
  function getValueForCasNo(tableName::String , CasNo::String)
		if tableName=="C0Poly"
			length=size(data_poly)[1]
			i=1
			while (i<=length && data_poly[i,4]!=CasNo) 
				i+=1;
			end
			if (i<=length)
				return (data_poly[i,6],data_poly[i,7],data_poly[i,8],data_poly[i,13]/1e5,data_poly[i,14]/1e10)
			end
		elseif tableName=="C0Hyper"
			length=size(data_hyper)[1]
			i=1
			while (i<=length && data_hyper[i,4]!=CasNo)
				i+=1;
			end
			if (i<=length)
				return (data_hyper[i,6]*1e5,data_hyper[i,7]*1e5,data_hyper[i,8]*1e3,data_hyper[i,9]*1e5,data_hyper[i,10])
			end
		elseif tableName=="Criticals"
			length=size(data_criti)[1]
			i=1
			while (i<=length && data_criti[i,4]!=CasNo)
				i+=1;
			end
			if (i<=length)
				return (data_criti[i,6],data_criti[i,7]*1e6,data_criti[i,10])
			end
		end
  end
end
