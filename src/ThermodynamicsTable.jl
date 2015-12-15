include("ECapeExceptions.jl")
include("CapeOpen.jl")
module ThermodynamicsTable
  using ECapeExceptions
  import CapeOpen.perryanalytic
  thisfiledirname=dirname(@__FILE__())
  
  pabf=open(thisfiledirname * "/Tables/"*perryanalytic.datafilename,"r");  
  pata=perryanalytic.tableaddreses
  
  function getdatamatrix(path::AbstractString)
    global floattables,compondtable
    file=open(thisfiledirname * "/Tables/"*path);
    matrix=readdlm(file,';',header=false);
    close(file)
    return matrix
  end

  #for LiquidsDensities, Cp, LiquidsCp props Max of two data row per prop may exists
  function readbinarydatabase(id::UInt16, table::ASCIIString, skipdata::UInt8=0%UInt8)
    if haskey(pata,table) 
      v=pata[table]
    else
      throw(ECapeInvalidArgument())
    end
    seek(pabf,v[1][1])
    skipsize=v[1][3]-sizeof(UInt16)
    j=1
    while(id!=(read(pabf,UInt16)) && j<=v[1][2])
      skip(pabf,skipsize)
      j+=1
    end
    if(skipdata>0 && j+skipdata<=v[1][2]) 
      skip(pabf,skipdata*skipsize)
      id!=(read(pabf,UInt16)) && throw(ECapeInvalidArgument())
    end
    if(j<=v[1][2])
      for jj in 2:length(v)
        if isa(v[jj],Array)
          read!(pabf,v[jj])
        else
          v[jj]=read(pabf,typeof(v[jj]))
        end
      end
      return v[2:end]
    end
    throw(ECapeLimitedImpl())
  end
end

include("PhysicalPropertyCalculator.jl")
include("ICapeThermoCompounds.jl")
include("ICapeThermoMaterial.jl")
include("ICapeThermoPhases.jl")
include("ICapeThermoPropertyRoutine.jl")
include("ICapeThermoUniversalConstants.jl")
using ICapeThermoUniversalConstants,ICapeThermoCompounds,ECapeExceptions
perryanalytic = CapeOpen.perryanalytic
println("`perryanalytic` Property Package was created and is ready to use.")
include("CoolProp.jl")
include("FreeSteam.jl")