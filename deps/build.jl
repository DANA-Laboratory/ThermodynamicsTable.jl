# Download latest binary shared library of CoolProp project
import JSON
const destpathbase = abspath(joinpath(@__FILE__,"..","..","lib"));
const srctablepath = abspath(joinpath(@__FILE__,"..","..","src","Tables"));
m1=0
m2=0
m3=0
function canconvert(ty::Type,matrix::Array,database,sizearray)
  global m1,m2,m3
  j=1
  si=Int(0)
  r::Tuple
  r=(NaN,)
  for(j in 1:size(matrix)[1])
    try
      r=ty(tuple(matrix[j,:]...))
    catch
      return matrix[j,:],false
    end
    if (sizearray!=nothing)
      m1>0 && (r2=rpad(r[2],m1,' '))
      m2>0 && (r3=rpad(r[3],m2,' '))
      m3>0 && (r4=rpad(r[4],m3,' '))
      m1>0 && (r=(r[1],r2,r3,r4,r[5],r[6]))
      si+=writetup(database,r)
    else
      b=[(r[i]==matrix[j,i] || isnan(r[i])) for i in 1:length(r)]
      if(sum(b)!=length(r))
        println(matrix[j,:])
        println(r)
        return false,matrix[j,:]
      end
    end
  end
  (sizearray!=nothing) && push!(sizearray,(si,j))
  return true 
end
function writetup(database,t::Tuple)
  i=0
  i+=write(database,t...)
  return i;
end
function buildbinarydatabase(database,si)
  ret=true
  global m1,m2,m3
  propnames=["Criticals",      
              "LiquidsDensities",  
              "FormationEnergy",  
              "Compounds",        
              "Cp",                
              "LiquidsCp",        
              "VaporizHeat",      
              "LiquidThermal",    
              "VaporPressure",    
              "LiquidViscos",     
              "VaporThermal",     
              "VaporViscos"]
              
  tablenames=["perryCriticals_Table2_141.table", 
              "perryDensities_Table2_32.table",      
              "perryEnergiesOfFormation_Table2_179.table", 
              "perryFormulaCompounds.table",
              "perryHeatCapIdealGas_Tables156_155.table",
              "perryHeatCapLiquids_Table2_153.table",
              "perryHeatsofVaporization_Table2_150.table",
              "perryLiqidThermalConductivity_Table2_315.table",
              "perryLiquidsVaporPressure_Table2_8.table",
              "perryLiquidViscosity_Table2_313.table",
              "perryVaporThermalConductivity_Table2_314.table",
              "perryVaporViscosity_Table2_312.table"]
              
  rowtypes=[Tuple{[UInt16;[Float64 for i=1:6]]...}, 
            Tuple{[UInt16;[Float64 for i=1:10];UInt8]...}, 
            Tuple{[UInt16;[Float64 for i=1:5]]...}, 
            Tuple{[UInt16,ASCIIString,ASCIIString,ASCIIString,Float64,Float64]...},
            Tuple{[UInt16;[Float64 for i=1:10];UInt8]...},
            Tuple{[UInt16;[Float64 for i=1:10];UInt8]...},
            Tuple{[UInt16;[Float64 for i=1:10]]...},
            Tuple{[UInt16;[Float64 for i=1:10]]...},
            Tuple{[UInt16;[Float64 for i=1:10]]...},
            Tuple{[UInt16;[Float64 for i=1:10]]...},
            Tuple{[UInt16;[Float64 for i=1:9]]...},
            Tuple{[UInt16;[Float64 for i=1:9]]...}]
            
  for i=1:length(tablenames)
    tablename=tablenames[i]
    file=open(joinpath(srctablepath, tablename))                
    matrix=readdlm(file,';',header=false)
    close(file)
    if tablename=="perryFormulaCompounds.table"
      m1=(maximum(Int[length(i) for i in matrix[:,2]]))
      m2=(maximum(Int[length(i) for i in matrix[:,3]]))
      m3=(maximum(Int[length(i) for i in matrix[:,4]]))
    else
      m1=0;m2=0;m3=0;
    end
    ty=rowtypes[i]
    if canconvert(ty,matrix,database,si)
      database==nothing && println("$tablename convertion simulated.")
    else
      println("$tablename convertion failed.")
      ret=false
    end
  end
  if si!=nothing
    databaseaddress=open(joinpath(destpathbase,"perryranalyticaddress.txt"),"w")
    println("Writing addresses .....")
    startaddress=0;
    for i=1:length(tablenames)
      s=si[i]
      println(databaseaddress,propnames[i],';',startaddress,';',s[2],';',s[1]/s[2],';',rowtypes[i])
      startaddress+=s[1]
    end
    close(databaseaddress)
  end
  return ret
end

try
  mkdir(destpathbase)
  const OS_ARCH_CoolProp = (WORD_SIZE == 64) ? "64bit" : "32bit__cdecl";
  const OS_ARCH_FreeSteam = (WORD_SIZE == 64) ? "win64" : "win32";
  const latestVersion_CoolProp = JSON.parse(readall(download("http://sourceforge.net/projects/coolprop/best_release.json")))["release"]["filename"][11:15];
  const latestVersion_FreeSteam = "2.1"
  println("CoolProp latestVersion = $latestVersion_CoolProp, by default I am going to install it...")

  @windows_only begin
      urlbase = "http://netassist.dl.sourceforge.net/project/coolprop/CoolProp/$latestVersion_CoolProp/shared_library/Windows/$OS_ARCH_CoolProp/"
      download(joinpath(urlbase,"CoolProp.dll"),joinpath(destpathbase,"CoolProp.dll"))
      download(joinpath(urlbase,"CoolProp.lib"),joinpath(destpathbase,"CoolProp.lib"))
      download(joinpath(urlbase,"exports.txt"),joinpath(destpathbase,"exports.txt"))
      println("downloaded => lib/CoolProp.dll")
      # FreeSteam
      println("I'm Getting FreeSteam Binaries...")
      urlbase = "http://cdn.rawgit.com/DANA-Laboratory/FreeSteamBinary/master/$latestVersion_FreeSteam/$OS_ARCH_FreeSteam/"
      download(joinpath(urlbase,"freesteam.dll"),joinpath(destpathbase,"freesteam.dll"))
      println("downloaded => lib/freesteam.dll")   
  end
  @linux_only begin
      # CoolProp
      urlbase = "http://netassist.dl.sourceforge.net/project/coolprop/CoolProp/$latestVersion_CoolProp/shared_library/Linux/64bit/libCoolProp.so.$latestVersion_CoolProp"
      download(urlbase,joinpath(destpathbase,"libCoolProp.so"))
      println("downloaded => lib/libCoolProp.so")
      # FreeSteam
      println("I'm Getting FreeSteam Binaries...")
      urlbase = "http://cdn.rawgit.com/DANA-Laboratory/FreeSteamBinary/master/"
      download(joinpath(urlbase,"$latestVersion_FreeSteam","linux","libfreesteam.so.1.0"),joinpath(destpathbase,"libfreesteam.so"))
      println("downloaded => lib/libfreesteam.so")
      download(joinpath(urlbase,"libgsl.so.0"),joinpath(destpathbase,"libgsl.so"))
      println("downloaded => lib/libgsl.so")
      download(joinpath(urlbase,"libgslcblas.so.0"),joinpath(destpathbase,"libgslcblas.so"))
      println("downloaded => lib/libgslcblas.so")
  end
catch err
  println("$err\n => If lib folder exists, and you want to refresh existing files, remove lib folder and retry")
end
if buildbinarydatabase(nothing, nothing) # Simulate convertion
  database=open(joinpath(destpathbase,"perryanalytic.binary"),"w")
  si=Vector{Tuple{Int,Int}}()
  println("********** Simulation done, I'm writing perryanalytic.binary **********")
  buildbinarydatabase(database,si)
  close(database)
end