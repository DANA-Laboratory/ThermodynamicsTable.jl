module ICapeThermoCompounds
    import CapeOpen.PropertyPackage
    export getcompoundconstant,getcompoundlist,getconstproplist!,getnumcompounds!,getpdependentproperty!,getpdependentproplist!,gettdependentproperty!,gettdependentproplist!
    
    """
      Returns the values of constant Physical Properties for the specified Compounds.
      #= [retval][out] =# propvals::Vector{Any}
    """
    function getcompoundconstant(
        proppackage::PropertyPackage,
        #= [in] =# props::Vector{ASCIIString},
        #= [in] =# compIds::Vector{ASCIIString}) # List of Compound identifiers for which constants are to be retrieved. Set compIds to nothing to denote all Compounds in the component that implements the ICapeThermoCompounds interface.
        propvals=Vector{Any}()
        return propvals
    end

    """
      Returns the list of all Compounds. This includes the Compound identifiers recognised and extra
      information that can be used to further identify the Compounds.
        #= [retval][out] =# compIds::Vector{ASCIIString} List of Compound identifiers.
        #= [retval][out] =# formulae::Vector{ASCIIString} List of Compound formulae.
        #= [retval][out] =# names::Vector{ASCIIString} List of Compound names.
        #= [retval][out] =# boilTemps::Vector{Float64} List of boiling point temperatures.
        #= [retval][out] =# molwts::Vector{Float64} List of molecular weights. 
        #= [retval][out] =# casnos::Vector{ASCIIString}) List of Chemical Abstract Service (CAS) Registry numbers.
    """    
    function getcompoundlist(
        proppackage::PropertyPackage) 
        compIds=Vector{ASCIIString}()
        formulae=Vector{ASCIIString}()
        names=Vector{ASCIIString}()
        boilTemps=Vector{Float64}()
        molwts=Vector{Float64}()
        casnos=Vector{ASCIIString}()
        return compIds,formulae,names,boilTemps,molwts,casnos
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
