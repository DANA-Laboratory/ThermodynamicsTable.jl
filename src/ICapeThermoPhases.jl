"""
  This interface is designed to provide information about the number and types of Phases supported by the component that implements it. It defines all the Phases that a component such as a Physical Property Calculator can handle. It does not provide information about the Phases that are actually present in a Material Object. This function is provided by the GetPresentPhases method of the ICapeThermoMaterial interface.
"""
module ICapeThermoPhases

    export getnumphases!,getphaseinfo!,getphaselist!
    """
      Returns the number of Phases.
    """
    function getnumphases!( 
        #= [retval][out] =# num::Int32)
		end

    """
      Returns information on an attribute associated with a Phase for the purpose of understanding what lies behind a Phase label.
    """    
    function getphaseinfo!( 
        #= [in] =# phaseLabel::Vector{AbstractString},
        #= [in] =# phaseAttribute::Vector{AbstractString},
        #= [retval][out] =# value::Any)
		end

    """
      Returns Phase labels and other important descriptive information for all the Phases supported.
    """    
    function getphaselist!( 
        #= [out][in] =# phaseLabels!::Vector{AbstractString},
        #= [out][in] =# stateOfAggregation!::Vector{AbstractString},
        #= [out][in] =# keyCompoundId!::Vector{AbstractString})
		end
        
end
