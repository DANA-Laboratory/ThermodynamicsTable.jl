module CapeOpen
  validPureConstantStringProps=Vector{ASCIIString}([
    "casRegistryNumber", # Chemical Abstract Service Registry Number 
    "chemicalFormula", # Chemical formula
    "iupacName", # Complete IUPAC Name 
    "SMILESformula" # SMILES chemical structure formula
  ])
  validPureConstantFlotProps=Vector{ASCIIString}([
    "acentricFactor", # Pitzer acentric factor
    "associationParameter", # association-parameter (Hayden-O’Connell) 
    "bornRadius", # in m
    "charge", 
    "criticalCompressibilityFactor", # critical compressibility factor Z
    "criticalDensity", # critical density in mol/m3
    "criticalPressure", # critical pressure in Pa
    "criticalTemperature", # critical temperature in K
    "criticalVolume", # critical volume in m3/mol
    "diffusionVolume", # diffusion volume in m3
    "dipoleMoment", # dipole moment in Cm
    "energyLennardJones", # Lennard-Jones energy parameter in K (divided by Boltzmann constant)
    "gyrationRadius", # radius of gyration in m
    "heatOfFusionAtNormalFreezingPoint", # enthalpy change on melting at normal freezing point (101325 Pa) in J/mol
    "heatOfVaporizationAtNormalBoilingPoint", # enthalpy change on vaporization at normal boiling point (101325 Pa) in J/mol
    "idealGasGibbsFreeEnergyOfFormationAt25C", # in J/mol
    "liquidDensityAt25C", # liquid density at 25 ºC in mol/m3
    "liquidVolumeAt25C", # liquid volume at 25 ºC in m3/mol
    "lengthLennardJones", # Lennard-Jones length parameter in m
    "molecularWeight", # relative molar mass
    "normalBoilingPoint", # boiling point temperature at 101325 Pa in K
    "normalFreezingPoint", # melting point temperature at 101325 Pa in K
    "parachor", # Parachor in m3 kg0.25/(s0.5 mol)
    "standardEntropyGas", # Standard entropy of gas in J/mol
    "standardEntropyLiquid", # standard entropy of liquid in J/mol
    "standardEntropySolid", # standard entropy of solid in J/mol
    "standardEnthalpyAqueousDilution", # Standard aqueous infinite dilution enthalpy in J/mol
    "standardFormationEnthalpyGas", # standard enthalpy change on formation of gas in J/mol
    "standardFormationEnthalpyLiquid", # standard enthalpy change on formation of liquid in J/mol
    "standardFormationEnthalpySolid", # standard enthalpy change on formation of solid in J/mol
    "standardFormationGibbsEnergyGas", # standard Gibbs energy change on formation of gas in J/mol
    "standardFormationGibbsEnergyLiquid", # standard Gibbs energy change on formation of liquid in J/mol
    "standardFormationGibbsEnergySolid", # standard Gibbs energy change on formation of solid in J/mol
    "standardGibbsAqueousDilution", # Standard aqueous infinite dilution Gibbs energy in J/mol
    "triplePointPressure", # triple point pressure in Pa
    "triplePointTemperature", # triple point temperature in K
    "vanderwaalsArea", # van der Waals area in m3/mol
    "vanderwaalsVolume", # van der Waals volume in m3/mol
  ])
  """
    Material Object must:
    * Allow a client to set any basis-dependent Physical Property on any basis.
    * Allow a client to get any basis-dependent Physical Property using the basis with which it was stored.
    * Perform basis conversions, or delegate basis conversion as necessary. If basis conversion is not meaningful (e.g. in the case of cement), the Material Object must be able to return the quantity in its original basis and to return an error should the quantity be requested in a different basis.
    * Ensure that quantities set in one basis are consistent with quantities set in another basis, or delegate that function as necessary. Where the basis conversion on a quantity is not  feasible, the Material Object must only store the quantity in the basis with which it was set most recently
  """
  type MaterialObject 
    MaterialObject()=new(
      Dict{ASCIIString,Dict{ASCIIString,Any}}()
    )    
    pureConstantStrings::Dict{ASCIIString,Dict{ASCIIString,Any}}
  end

  type PropertyPackage
  end
end

include("ECapeExceptions.jl")
include("ICapeThermoCompounds.jl")
include("ICapeThermoMaterial.jl")
include("ICapeThermoPhases.jl")
include("ICapeThermoPropertyRoutine.jl")
include("ICapeThermoUniversalConstants.jl")
