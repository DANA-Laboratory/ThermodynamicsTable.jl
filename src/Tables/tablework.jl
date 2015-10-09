#add columns after @addaftercolumn so every rows should have @musttobe+1 column
#EXAMPLE CALL -> makesamecolumn(13,-3,"perryHeatCapLiquids_Table2_153.table")
#EXAMPLE CALL -> makesamecolumn(12,-3,"perryHeatsofVaporization_Table2-150.table")
#EXAMPLE CALL -> makesamecolumn(13,-3,"perryLiqidThermalConductivity_Table2-315.table")
#EXAMPLE CALL -> makesamecolumn(13,-3,"perryLiquidViscosity_Table2-313.table")
#EXAMPLE CALL -> makesamecolumn(12,-3,"perryVaporViscosity_Table2-312.table")
#EXAMPLE CALL -> makesamecolumn(12,-3,"perryVaporThermalConductivity_Table2-314.table")
function makesamecolumn(musttobe::Int,addaftercolumn::Int,tablename::String)
  srmin=open(tablename,"r")
  srmout=open(tablename*"_","w")
  count=0
  pos=position(srmin)
  semitoadd=0
  addfrom=0
  pause=false
  lastline=""
  while (!eof(srmin))
    c=read(srmin,Char)
    lastline*=string(c)
    if c=='\n' 
      if (count<musttobe && count>7)
        seek(srmin,pos)
        semitoadd=musttobe-count
        addfrom=count+addaftercolumn
      else
        semitoadd=0
        addfrom=0
        write(srmout,lastline)
      end
      count=0
      pos=position(srmin)
      lastline=""
    end
    if (c==';')
      count+=1
    end
    if (semitoadd>0 && addfrom == count)
      while(semitoadd>0)
        semitoadd-=1
        lastline*=";"
        count+=1
      end
      addfrom=0
    end
  end
  close(srmin)
  close(srmout)
end

function checkalltablesprofile()
  tables=["perryCriticals_Table2_141","perryLiquidsVaporPressure_Table2_8","perryHeatsofVaporization_Table2_150","perryHeatCapLiquids_Table2_153","perryHeatCapIdealGas_Table2_155","perryHeatCapIdealGas_Table2_156","perryEnergiesOfFormation_Table2_179","perryVaporViscosity_Table2_312","perryLiquidViscosity_Table2_313","perryVaporThermalConductivity_Table2_314","perryLiqidThermalConductivity_Table2_315"]
  i=1
  glob=Array(Any,11)
  for (t in tables)
    file=open(t*".table");
    glob[i]=readdlm(file,';',header=false);    
    println(t*" is loaded")
    close(file)
    i+=1
  end
  for (i in 2:11)
    jj=1
    j=1
    while (j < size(glob[i])[1])
      glob[i][j,1]=int(glob[i][j,1])
      try
        while (glob[i][j,[1,2,3,4]]!=glob[1][jj,[1,2,3,4]])
          jj+=1
        end
      catch   err
        @assert false "$(glob[i][j,[1,2,3,4]]) in $(tables[i])"
      end
      j+=1
    end
    println(tables[i]*" Done $j elements found")
  end
end