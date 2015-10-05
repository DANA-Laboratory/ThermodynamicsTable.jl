module ICapeThermoCompounds
    
    export getcompoundconstant,getcompoundlist!,getconstproplist!,getnumcompounds!,getpdependentproperty!,getpdependentproplist!,gettdependentproperty!,gettdependentproplist!
    
    """
      Returns the values of constant Physical Properties for the specified Compounds.
      #= [retval][out] =# propvals::Vector{Any}
    """
    function getcompoundconstant(
        #= [in] =# props::Vector{ASCIIString},
        #= [in] =# compIds::Vector{ASCIIString}) # List of Compound identifiers for which constants are to be retrieved. Set compIds to nothing to denote all Compounds in the component that implements the ICapeThermoCompounds interface.
        # [[this.pureConstantStrings[compId][prop] for prop in props] for compId in compIds]
    end

    """
      Returns the list of all Compounds. This includes the Compound identifiers recognised and extra
      information that can be used to further identify the Compounds.
    """    
    function getcompoundlist!( 
        #= [out][in] =# compIds!::Vector{ASCIIString},
        #= [out][in] =# formulae!::Vector{ASCIIString},
        #= [out][in] =# names!::Vector{ASCIIString},
        #= [out][in] =# boilTemps!::Vector{Float64},
        #= [out][in] =# molwts!::Vector{Float64},
        #= [out][in] =# casnos!::Vector{ASCIIString}) 
    end
    
    """
      Returns the list of supported constant Physical Properties.
    """
    function getconstproplist!( 
        #= [retval][out] =# props::Vector{ASCIIString}) 
    end
    
    """
      Returns the number of Compounds supported.
    """
    function getnumcompounds!( 
        #= [retval][out] =# num::Int32) 
    end

    """
      Returns the values of pressure-dependent Physical Properties for the specified pure Compounds.
    """
    function getpdependentproperty!( 
        #= [in] =# props::Vector{ASCIIString},
        #= [in] =# pressure::Float64,
        #= [in] =# compIds::Vector{ASCIIString},
        #= [out][in] =# propvals::Vector{Float64}) 
    end
    
    """
      Returns the list of supported pressure-dependent properties.
    """
    function getpdependentproplist( 
        #= [retval][out] =# props::Vector{ASCIIString}) 
    end
    
    """
      Returns the values of temperature-dependent Physical Properties for the specified pure Compounds.
    """
    function gettdependentproperty!( 
        #= [in] =# props::Vector{ASCIIString},
        #= [in] =# temperature::Float64,
        #= [in] =# compIds::Vector{ASCIIString},
        #= [out][in] =# propvals::Vector{Float64}) 
    end

    """
      Returns the list of supported temperature-dependent Physical Properties.
    """
    function gettdependentproplist!( 
        #= [retval][out] =# props::Vector{ASCIIString}) 
    end
        
end
