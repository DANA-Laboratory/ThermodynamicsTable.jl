#add columns after @addaftercolumn so every rows should have @musttobe+1 column
#EXAMPLE CALL -> maketable(13,-3,"perryHeatCapLiquids_Table2_153.table")
#EXAMPLE CALL -> maketable(12,-3,"perryHeatsofVaporization_Table2-150.table")
#EXAMPLE CALL -> maketable(13,-3,"perryLiqidThermalConductivity_Table2-315.table")
#EXAMPLE CALL -> maketable(13,-3,"perryLiquidViscosity_Table2-313.table")
#EXAMPLE CALL -> maketable(12,-3,"perryVaporViscosity_Table2-312.table")
#EXAMPLE CALL -> maketable(12,-3,"perryVaporThermalConductivity_Table2-314.table")
function maketable(musttobe::Int,addaftercolumn::Int,tablename::AbstractString)
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
