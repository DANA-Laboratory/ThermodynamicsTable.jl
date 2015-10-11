module ICapeThermoMaterial

    import CapeOpen: MaterialObject
    import ..ECapeExceptions: ECapeNoImpl, ECapeUnknown
    export clearallprops!,copyfrommaterial!,creatematerial!,getoverallprop!
    export getoveralltpfraction!,getpresentphases!,getsinglephaseprop!
    export gettpfraction!,gettwophaseprop!,setoverallprop,setpresentphases
    export setsinglephaseprop,settwophaseprop
    
    """
      Remove all stored Physical Property values.
    """
    function  clearallprops!(
        #= [in] =# this::MaterialObject) 
      
		end
    
    """
      Creates a Material Object with the s ration as the current Material Object
    """
    function  copyfrommaterial!( 
        #= [in] =# this::MaterialObject,
        #= [in] =# source::MaterialObject) 
		end
    
    """
      Copies all the stored non-constant Physical  Properties (which have been set using the 
      SetSinglePhaseProp SetTwoPhaseProp or SetOverallProp) from the  source Material Object to the
      current instance Material Object.
    """
    function  creatematerial!( 
        #= [retval][out] =# materialObject::MaterialObject) 
		end
    
    """
      Retrieves non- nt Physical Property values for the overall mixture.
    """
    function  getoverallprop!( 
        #= [in] =# this::MaterialObject,
        #= [in] =# property::AbstractString,
        #= [in] =# basis::AbstractString,
        #= [out][in] =# results::Vector{Float64}) 
		end
    
    """
      Retrieves tempe pressure an on for the overall mixture. 
    """
    function  getoveralltpfraction!( 
        #= [in] =# this::MaterialObject,
        #= [out][in] =# temperature!::Float64,
        #= [out][in] =# pressure!::Float64,
        #= [out][in] =# composition!::Vector{Float64}) 
		end

    """
      Returns Phase l for the Phaes that are currently present in the Material Object.
    """
    function  getpresentphases!( 
        #= [in] =# this::MaterialObject,    
        #= [out][in] =# phaseLabels::Vector{AbstractString},
        #= [out][in] =# phaseStatus!::Vector{Int}) 
		end
    
    """
      Retrieves single non-constan Physical Property values for a mixture. 
    """
    function  getsinglephaseprop!( 
        #= [in] =# this::MaterialObject,    
        #= [in] =# property::AbstractString,
        #= [in] =# phaseLabel::AbstractString,
        #= [in] =# basis::AbstractString,
        #= [out][in] =# results::Vector{Float64}) 
		end
    
    """
      Retrieves temperature, pressure and composition for a Phase. 
    """
    function  gettpfraction!( 
        #= [in] =# this::MaterialObject,    
        #= [in] =# phaseLabel::AbstractString,
        #= [out][in] =# temperature!::Float64,
        #= [out][in] =# pressure!::Float64,
        #= [out][in] =# composition!::Vector{Float64}) 
		end
    
    """
      Retrieves two-p on-constant P perty values for a mixture.
    """
    function  gettwophaseprop!( 
        #= [in] =# this::MaterialObject,    
        #= [in] =# property::AbstractString,
        #= [in] =# phaseLabels::Vector{AbstractString},
        #= [in] =# basis::AbstractString,
        #= [out][in] =# results::Vector{Float64}) 
		end
    
    """
      Sets non-constant property values f ll mixture.
    """
    function  setoverallprop( 
        #= [in] =# this::MaterialObject,    
        #= [in] =# property::AbstractString,
        #= [in] =# basis::AbstractString,
        #= [in] =# values::Vector{Float64}) 
		end
    
    """
      Allows the PME or the Property Package to specify the list of Phases that are currently present. 
    """
    function  setpresentphases( 
        #= [in] =# this::MaterialObject,    
        #= [in] =# phaseLabels::Vector{AbstractString} ,
        #= [in] =# phaseStatus::Vector{Int}) 
		end
    
    """
      Sets single-phas -constant pro for a mixture. 
    """
    function  setsinglephaseprop( 
        #= [in] =# this::MaterialObject,    
        #= [in] =# property::AbstractString,
        #= [in] =# phaseLabel::AbstractString,
        #= [in] =# basis::AbstractString,
        #= [in] =# values::Vector{Float64}) 
		end
    
    """
      Sets two-phase nstant property values for a mixture. 
    """
    function  settwophaseprop( 
        #= [in] =# this::MaterialObject,    
        #= [in] =# property::AbstractString,
        #= [in] =# phaseLabels::Vector{AbstractString},
        #= [in] =# basis::AbstractString,
        #= [in] =# values::Vector{Float64}) 
		end
    
end
