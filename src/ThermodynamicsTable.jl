thisfiledirname=dirname(@__FILE__())
binaryfile=open(thisfiledirname * "/Tables/binary.table","r");

module ThermodynamicsTable

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

  ty=Dict{ASCIIString, Tuple}(
         "Criticals"=>       ([0,345,50], Vector{Float64}(6)),
         "LiquidsDensities"=>([17250,347,83], Vector{Float64}(10), 0%UInt8),
         "FormationEnergy"=> ([17250+28801,345,42], Vector{Float64}(5)),
         "Compounds"=>       ([17250+28801+14490,345,67], Vector{UInt8}(29), Vector{UInt8}(9), Vector{UInt8}(11), 0.0, 0.0),
         "Cp"=>              ([17250+28801+14490+23115,402,83], Vector{Float64}(10), 0%UInt8),
         "LiquidsCp"=>       ([17250+28801+14490+23115+33366,348,83], Vector{Float64}(10), 0%UInt8),
         "VaporizHeat"=>     ([17250+28801+14490+23115+33366+28884,345,82], Vector{Float64}(10)),
         "LiquidThermal"=>   ([17250+28801+14490+23115+33366+28884+28290,345,82], Vector{Float64}(10)),
         "VaporPressure"=>   ([17250+28801+14490+23115+33366+28884+2*28290,345,82], Vector{Float64}(10)),
         "LiquidViscos"=>    ([17250+28801+14490+23115+33366+28884+3*28290,345,82], Vector{Float64}(10)),
         "VaporThermal"=>    ([17250+28801+14490+23115+33366+28884+4*28290,345,74], Vector{Float64}(9)),
         "VaporViscos"=>     ([17250+28801+14490+23115+33366+28884+4*28290+25530,345,74], Vector{Float64}(9))
  )

  function gettablesize(table::ASCIIString)
    return ty[table][1][2]
  end
  
  function readbinarydatabase(id::UInt16, table::ASCIIString)
    v=ty[table]
    seek(binaryfile,v[1][1])
    skipsize=v[1][3]-sizeof(UInt16)
    j=1
    while(id!=(read(binaryfile,UInt16)) && j<=v[1][2])
      skip(binaryfile,skipsize)
      j+=1
    end
    for d in v[2:end]
      if isa(d,Array)
        read!(binaryfile,d)
      else
        d=read(binaryfile,typeof(d))
      end
    end
    return id,v[2:end]
  end

end

include("CapeOpen.jl")
include("PhysicalPropertyCalculator.jl")
include("ECapeExceptions.jl")
include("ICapeThermoCompounds.jl")
include("ICapeThermoMaterial.jl")
include("ICapeThermoPhases.jl")
include("ICapeThermoPropertyRoutine.jl")
include("ICapeThermoUniversalConstants.jl")