#add columns after @addaftercolumn so every rows should have @musttobe column
musttobe=13
addaftercolumn=-3
srmin=open("perryHeatCapLiquids_Table2_153.table","r")
srmout=open("perryHeatCapLiquids_Table2_153_.table","w")
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
