"""
  Description
  
    Methods implemented by components that can supply the values of Universal Constants.
  Units  
  
    avogadroConstant => 1/mol
    boltzmannConstant => J/K 
    idealGasStateReferencePressure => Pa 
    molarGasConstant => J/mol/K 
    speedOfLightInVacuum => m/s 
    standardAccelerationOfGravity => m/s2  
  Methods
  
    getuniversalconstant()
    getuniversalconstantlist()    
"""
module ICapeThermoUniversalConstants
    import ..ECapeExceptions: ECapeInvalidArgument, ECapeUnknown
    export getuniversalconstant,getuniversalconstantlist
    universalConstants=Dict{ASCIIString,Float64}("avogadroConstant"=>6.0221419947E23,"boltzmannConstant"=>1.380650324E-23,"idealGasStateReferencePressure"=>101325,"molarGasConstant"=>8.31447215,"speedOfLightInVacuum"=>2.997924581E8,"standardAccelerationOfGravity"=>9.80665)
    
    """
      Retrieves the value of a Universal Constant.
      
        [in] constantId::ASCIIString
        [out] constantValue::Float64
    """
    function getuniversalconstant( 
      constantId::ASCIIString)
      try
        return constantValue=universalConstants[constantId]
      catch err
        if(isa(err,KeyError))
          throw(ECapeInvalidArgument())
        else
          throw(ECapeUnknown())
        end
      end
    end
    
    """
      Returns the identifiers of the supported Universal Constants.
      
        [out] constantId::Vector{ASCIIString}
    """
    function getuniversalconstantlist() 
      [key::ASCIIString for key in keys(universalConstants)]
    end
    
end
