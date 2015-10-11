module ICapeThermoPropertyRoutine

    export calcandgetlnphi!,calcsinglephaseprop,calctwophaseprop,checksinglephasepropspec!
    export checktwophasepropspec!,getsinglephaseproplist!,gettwophaseproplist!

    """
      This method is used to calculate the natural logarithm of the fugacity coefficients (and
      optionally their derivatives) in a single Phase mixture. The values of temperature, pressure
      and composition are specified in the argument list and the results are also returned through
      the argument list.
    """
    function calcandgetlnphi!( 
        #= [in] =# phaseLabel::AbstractString,
        #= [in] =# temperature::Float64,
        #= [in] =# pressure::Float64,
        #= [in] =# moleNumbers::Vector{Float64},
        #= [in] =# fFlags::Int32,
        #= [out][in] =# lnPhi!::Vector{Float64},
        #= [out][in] =# lnPhiDT!::Vector{Float64},
        #= [out][in] =# lnPhiDP!::Vector{Float64},
        #= [out][in] =# lnPhiDn!::Vector{Float64})
		end
        
    """
      CalcSinglePhaseProp is used to calculate properties and property derivatives of a mixture in
      a single Phase at the current values of temperature, pressure and composition set in the
      Material Object. CalcSinglePhaseProp does not perform phase Equilibrium Calculations.
    """
    function calcsinglephaseprop( 
        #= [in] =# props::Vector{AbstractString},
        #= [in] =# phaseLabel::AbstractString)
		end
       
    """
      CalcTwoPhaseProp is used to calculate mixture properties and property derivatives that depend on
      two Phases at the current values of temperature, pressure and composition set in the Material Object.
      It does not perform Equilibrium Calculations.
    """
    function calctwophaseprop( 
        #= [in] =# props::Vector{AbstractString} ,
        #= [in] =# phaseLabels::Vector{AbstractString} )
		end
       
    """
      Checks whether it is possible to calculate a property with the CalcSinglePhaseProp method for a given Phase.
    """
    function checksinglephasepropspec!( 
        #= [in] =# property::AbstractString,
        #= [in] =# phaseLabel::AbstractString,
        #= [retval][out] =# valid::Bool)
		end
       
    """
      Checks whether it is possible to calculate a property with the CalcTwoPhaseProp method for a given set of Phases.
    """
    function checktwophasepropspec!( 
        #= [in] =# property::AbstractString,
        #= [in] =# phaseLabels::Vector{AbstractString},
        #= [retval][out] =# valid::Bool)
		end
       
    """
      Returns the list of supported non-constant single-phase Physical Properties.
    """
    function getsinglephaseproplist!( 
        #= [retval][out] =# props::Vector{AbstractString})
		end
       
    """
      Returns the list of supported non-constant two-phase properties.
    """
    function gettwophaseproplist!( 
        #= [retval][out] =# props::Vector{AbstractString})
		end
        
end
