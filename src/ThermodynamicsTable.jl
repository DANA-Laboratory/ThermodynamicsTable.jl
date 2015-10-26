thisfiledirname=dirname(@__FILE__())
binaryfile=open(thisfiledirname * "/Tables/binary.table","r");

include("ECapeExceptions.jl")

module ThermodynamicsTable
  using ECapeExceptions
  export readbinarydatabase, gettablesize
  
  binaryfile=Main.binaryfile
  thisfiledirname=Main.thisfiledirname
  
  function getdatamatrix(path::AbstractString)
    global floattables,compondtable
    file=open(thisfiledirname * "/Tables/"*path);
    matrix=readdlm(file,';',header=false);
    close(file)
    return matrix
  end

  ty=Dict{ASCIIString, Array}(
         "Criticals"=>       Any[[0,345,50], Vector{Float64}(6)],
         "LiquidsDensities"=>Any[[17250,347,83], Vector{Float64}(10), 0%UInt8],
         "FormationEnergy"=> Any[[17250+28801,345,42], Vector{Float64}(5)],
         "Compounds"=>       Any[[17250+28801+14490,345,67], Vector{UInt8}(29), Vector{UInt8}(9), Vector{UInt8}(11), 0.0, 0.0],
         "Cp"=>              Any[[17250+28801+14490+23115,402,83], Vector{Float64}(10), 0%UInt8],
         "LiquidsCp"=>       Any[[17250+28801+14490+23115+33366,348,83], Vector{Float64}(10), 0%UInt8],
         "VaporizHeat"=>     Any[[17250+28801+14490+23115+33366+28884,345,82], Vector{Float64}(10)],
         "LiquidThermal"=>   Any[[17250+28801+14490+23115+33366+28884+28290,345,82], Vector{Float64}(10)],
         "VaporPressure"=>   Any[[17250+28801+14490+23115+33366+28884+2*28290,345,82], Vector{Float64}(10)],
         "LiquidViscos"=>    Any[[17250+28801+14490+23115+33366+28884+3*28290,345,82], Vector{Float64}(10)],
         "VaporThermal"=>    Any[[17250+28801+14490+23115+33366+28884+4*28290,345,74], Vector{Float64}(9)],
         "VaporViscos"=>     Any[[17250+28801+14490+23115+33366+28884+4*28290+25530,345,74], Vector{Float64}(9)]
  )

  function gettablesize(table::ASCIIString)
    return ty[table][1][2]
  end
  
  function readbinarydatabase(id::UInt16, table::ASCIIString)
    if haskey(ty,table) 
      v=ty[table]
    else
      throw(ECapeInvalidArgument())
    end
    seek(binaryfile,v[1][1])
    skipsize=v[1][3]-sizeof(UInt16)
    j=1
    while(id!=(read(binaryfile,UInt16)) && j<=v[1][2])
      skip(binaryfile,skipsize)
      j+=1
    end
    if(j<=v[1][2])
      for jj in 2:length(v)
        if isa(v[jj],Array)
          read!(binaryfile,v[jj])
        else
          v[jj]=read(binaryfile,typeof(v[jj]))
        end
      end
      return v[2:end]
    end
    throw(ECapeInvalidArgument())
  end

  function readbinarydatabase(id::UInt16, table::ASCIIString, more::Bool)
    ret::Vector{Vector{Union{Vector{Float64},UInt8}}}
    cond::Bool
    ret=Vector{Vector{Union{Vector{Float64},UInt8}}}()
    if haskey(ty,table) 
      v=ty[table]
    else
      throw(ECapeInvalidArgument())
    end
    seek(binaryfile,v[1][1])
    skipsize=v[1][3]-sizeof(UInt16)
    j=1
    cond=false
    while(id!=(read(binaryfile,UInt16)) && j<=v[1][2])
      skip(binaryfile,skipsize)
      j+=1
    end
    cond=(j<=v[1][2])
    while(cond)
      for jj in 2:length(v)
        if isa(v[jj],Array)
          read!(binaryfile,v[jj])
        else
          v[jj]=read(binaryfile,typeof(v[jj]))
        end
      end
      j+=1
      cond = (j<=v[1][2] && id==(read(binaryfile,UInt16)))
      (!cond) && return(ret)
      push!(ret,v[2:end])
    end
    throw(ECapeInvalidArgument())
  end  

end

include("CapeOpen.jl")
include("PhysicalPropertyCalculator.jl")
include("ICapeThermoCompounds.jl")
include("ICapeThermoMaterial.jl")
include("ICapeThermoPhases.jl")
include("ICapeThermoPropertyRoutine.jl")
include("ICapeThermoUniversalConstants.jl")