module ThermodynamicsTable
 
  thisfiledirname=dirname(@__FILE__())
  
  function getdatamatrix(path::AbstractString)
    global floattables,compondtable
    file=open(thisfiledirname * "/Tables/"*path);
    matrix=readdlm(file,';',header=false);
    close(file)
    return matrix
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