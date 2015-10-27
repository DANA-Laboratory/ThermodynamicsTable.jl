module CapeOpen
  using ThermodynamicsTable
  export constantstrings, constantfloats, tempreturedependents, pressuredependents
  export MaterialObject, PropertyPackage, PhysicalPropertyCalculator


  """
    Constant string properties
      1- casRegistryNumber => Chemical Abstract Service Registry Number
      2- chemicalFormula => Chemical formula
      3- iupacName => Complete IUPAC Name
      4- SMILESformula => SMILES chemical structure formula
  """
  constantstrings=ASCIIString[
    "casRegistryNumber", # Chemical Abstract Service Registry Number
    "chemicalFormula", # Chemical formula
    "iupacName", # Complete IUPAC Name
    "SMILESformula" # SMILES chemical structure formula
  ]

  """
    Constant float properties
      1-  acentricFactor => Pitzer acentric factor
      2-  associationParameter => association-parameter (Hayden-O’Connell)
      3-  bornRadius => in m
      4-  charge =>
      5-  criticalCompressibilityFactor => critical compressibility factor Z
      6-  criticalDensity => critical density in mol/m3
      7-  criticalPressure => critical pressure in Pa
      8-  criticalTemperature => critical temperature in K
      9-  criticalVolume => critical volume in m3/mol
      10- diffusionVolume => diffusion volume in m3
      11- dipoleMoment => dipole moment in Cm
      12- energyLennardJones => Lennard-Jones energy parameter in K (divided by Boltzmann constant)
      13- gyrationRadius => radius of gyration in m
      14- heatOfFusionAtNormalFreezingPoint => enthalpy change on melting at normal freezing point (101325 Pa) in J/mol
      15- heatOfVaporizationAtNormalBoilingPoint => enthalpy change on vaporization at normal boiling point (101325 Pa) in J/mol
      16- idealGasGibbsFreeEnergyOfFormationAt25C => in J/mol
      17- liquidDensityAt25C => liquid density at 25 ºC in mol/m3
      18- liquidVolumeAt25C => liquid volume at 25 ºC in m3/mol
      19- lengthLennardJones => Lennard-Jones length parameter in m
      20- molecularWeight => relative molar mass
      21- normalBoilingPoint => boiling point temperature at 101325 Pa in K
      22- normalFreezingPoint => melting point temperature at 101325 Pa in K
      23- parachor => Parachor in m3 kg0.25/(s0.5 mol)
      24- standardEntropyGas => Standard entropy of gas in J/mol
      25- standardEntropyLiquid => standard entropy of liquid in J/mol
      26- standardEntropySolid => standard entropy of solid in J/mol
      27- standardEnthalpyAqueousDilution => Standard aqueous infinite dilution enthalpy in J/mol
      28- standardFormationEnthalpyGas => standard enthalpy change on formation of gas in J/mol
      29- standardFormationEnthalpyLiquid => standard enthalpy change on formation of liquid in J/mol
      30- standardFormationEnthalpySolid => standard enthalpy change on formation of solid in J/mol
      31- standardFormationGibbsEnergyGas => standard Gibbs energy change on formation of gas in J/mol
      32- standardFormationGibbsEnergyLiquid => standard Gibbs energy change on formation of liquid in J/mol
      33- standardFormationGibbsEnergySolid => standard Gibbs energy change on formation of solid in J/mol
      34- standardGibbsAqueousDilution => Standard aqueous infinite dilution Gibbs energy in J/mol
      35- triplePointPressure => triple point pressure in Pa
      36- triplePointTemperature => triple point temperature in K
      37- vanderwaalsArea => van der Waals area in m3/mol
      38- vanderwaalsVolume => van der Waals volume in m3/mol
  """
  constantfloats=ASCIIString[
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
    "vanderwaalsVolume" # van der Waals volume in m3/mol
  ]

  """
    Temprature dependent properties
      1-  cpAqueousInfiniteDilution => Heat capacity of a solute in an infinitely dilute aqueous solution. in J/(mol K)
      2-  dielectricConstant => The ratio of the capacity of a condenser with a particular substance as dielectric to the capacity of the same condenser with a vacuum for dielectric.
      3-  expansivity => Coefficient of linear expansion for a solid at 1 atm in 1/K
      4-  fugacityCoefficientOfVapor => Fugacity coefficient of vapour on the saturation line
      5-  glassTransitionPressure => Glass transition pressure in Pa
      6-  heatCapacityOfLiquid => Heat capacity (Cp) of liquid on the saturation line in J/(mol K)
      7-  heatCapacityOfSolid => Solid heat capacity (Cp) at 1 atm in J/(mol K)
      8-  heatOfFusion => Enthalpy change on fusion fot the solid on the melting line in J/mol
      9-  heatOfSublimation => Enthalpy change on evaporation of the solid on the sublimation line in J/mol
      10- heatOfSolidSolidPhaseTransition => Enthalpy change on phase transition in J/mol
      11- heatOfVaporization => Enthalpy change on evaporation of the liquid on the saturation line in J/mol
      12- idealGasEnthalpy => Enthalpy of ideal gas in J/mol
      13- idealGasEntropy => Temperature-dependent part of entropy of ideal gas in J/(mol K)
      14- idealGasHeatCapacity => Heat capacity (Cp) of ideal gas in J/(mol K)
      15- meltingPressure => Pressure on melting line in Pa
      16- selfDiffusionCoefficientGas => Self-diffusion coefficient in gas phase at 1 atm in m2/s
      17- selfDiffusionCoefficientLiquid => self-diffusion coefficient in liquid phase on saturation line in m2/s
      18- solidSolidPhaseTransitionPressure => Pressure at phase transition in Pa
      19- sublimationPressure => Vapour pressure of solid on the sublimation line in Pa
      20- surfaceTensionSatLiquid => Surface tension of liquid on the saturation line in N/m
      21- thermalConductivityOfLiquid => Thermal conductivity of liquid on saturation line in W/(m K)
      22- thermalConductivityOfSolid => Thermal conductivity of solid at 1 atm in W/(m K)
      23- thermalConductivityOfVapor => Thermal conductivity of dilute gas in W/(m K)
      24- vaporPressure => Vapour pressure of saturated liquid in Pas
      25- virialCoefficient => Second virial coefficient of gas in m3/mol
      26- viscosityOfLiquid => Viscosity of liquid on saturation line in Pas
      27- viscosityOfVapor => Viscosity in dilute gas state in Pas
      28- volumeChangeUponMelting => Volume change for the solid on the melting line in m3/mol
      29- volumeChangeUponSolidSolidPhaseTransition => Volume change upon solid-solid phase transition in m3/mol
      30- volumeChangeUponSublimation => Volume change for the solid on the sublimation line in m3/mol
      31- volumeChangeUponVaporization => Volume change for the liquid on the saturation line in m3/mol
      32- volumeOfLiquid => Volume of liquid on saturation line in m3/mol
      33- volumeOfSolid => Volume of solid at 1 atm in m3/mol

  """
  tempreturedependents=ASCIIString[
    "cpAqueousInfiniteDilution", # Heat capacity of a solute in an infinitely dilute aqueous solution. in J/(mol K)
    "dielectricConstant", # The ratio of the capacity of a condenser with a particular substance as dielectric to the capacity of the same condenser with a vacuum for dielectric.
    "expansivity", # Coefficient of linear expansion for a solid at 1 atm in 1/K
    "fugacityCoefficientOfVapor", # Fugacity coefficient of vapour on the saturation line
    "glassTransitionPressure", # Glass transition pressure in Pa
    "heatCapacityOfLiquid", # Heat capacity (Cp) of liquid on the saturation line in J/(mol K)
    "heatCapacityOfSolid", # Solid heat capacity (Cp) at 1 atm in J/(mol K)
    "heatOfFusion", # Enthalpy change on fusion fot the solid on the melting line in J/mol
    "heatOfSublimation", # Enthalpy change on evaporation of the solid on the sublimation line in J/mol
    "heatOfSolidSolidPhaseTransition", # Enthalpy change on phase transition in J/mol
    "heatOfVaporization", # Enthalpy change on evaporation of the liquid on the saturation line in J/mol
    "idealGasEnthalpy", # Enthalpy of ideal gas in J/mol
    "idealGasEntropy", # Temperature-dependent part of entropy of ideal gas in J/(mol K)
    "idealGasHeatCapacity", # Heat capacity (Cp) of ideal gas in J/(mol K)
    "meltingPressure", # Pressure on melting line in Pa
    "selfDiffusionCoefficientGas", # Self-diffusion coefficient in gas phase at 1 atm in m2/s
    "selfDiffusionCoefficientLiquid", # self-diffusion coefficient in liquid phase on saturation line in m2/s
    "solidSolidPhaseTransitionPressure", # Pressure at phase transition in Pa
    "sublimationPressure", # Vapour pressure of solid on the sublimation line in Pa
    "surfaceTensionSatLiquid", # Surface tension of liquid on the saturation line in N/m
    "thermalConductivityOfLiquid", # Thermal conductivity of liquid on saturation line in W/(m K)
    "thermalConductivityOfSolid", # Thermal conductivity of solid at 1 atm in W/(m K)
    "thermalConductivityOfVapor", # Thermal conductivity of dilute gas in W/(m K)
    "vaporPressure", # Vapour pressure of saturated liquid in Pas
    "virialCoefficient", # Second virial coefficient of gas in m3/mol
    "viscosityOfLiquid", # Viscosity of liquid on saturation line in Pas
    "viscosityOfVapor", # Viscosity in dilute gas state in Pas
    "volumeChangeUponMelting", # Volume change for the solid on the melting line in m3/mol
    "volumeChangeUponSolidSolidPhaseTransition", # Volume change upon solid-solid phase transition in m3/mol
    "volumeChangeUponSublimation", # Volume change for the solid on the sublimation line in m3/mol
    "volumeChangeUponVaporization", # Volume change for the liquid on the saturation line in m3/mol
    "volumeOfLiquid", # Volume of liquid on saturation line in m3/mol
    "volumeOfSolid" # Volume of solid at 1 atm in m3/mol
  ]
  """
    Pressure dependent properties
      1- boilingPointTemperature => Temperature at liquid-vapour transition in K
      2- glassTransitionTemperature => Glass transition temperature in K
      3- meltingTemperature => Temperature on melting line in K
      4- solidSolidPhaseTransitionTemperature => Temperature at phase transition in K
  """
  pressuredependents=ASCIIString[
    "boilingPointTemperature", # Temperature at liquid-vapour transition in K
    "glassTransitionTemperature", # Glass transition temperature in K
    "meltingTemperature", # Temperature on melting line in K
    "solidSolidPhaseTransitionTemperature"  # Temperature at phase transition in K
  ]

  """
    Material Object refers to the software object that implements the
    representation of a Material.
    Material Object must:
    * Allow a client to set any basis-dependent Physical Property on any basis.
    * Allow a client to get any basis-dependent Physical Property using the basis with which it was stored.
    * Perform basis conversions, or delegate basis conversion as necessary. If basis conversion is not meaningful (e.g. in the case of cement), the Material Object must be able to return the quantity in its original basis and to return an error should the quantity be requested in a different basis.
    * Ensure that quantities set in one basis are consistent with quantities set in another basis, or delegate that function as necessary. Where the basis conversion on a quantity is not  feasible, the Material Object must only store the quantity in the basis with which it was set most recently
  """
  type MaterialObject
  end

  typealias PropertyMap Dict{ASCIIString,ASCIIString}
  propmap(stvec,t)=[cs=>t[ind] for (ind,cs) in enumerate(stvec)]
  getdatamatrix=ThermodynamicsTable.getdatamatrix
  """
    Property Package – a software component that is both a Physical Property Calculator and
    an Equilibrium Calculator for Materials containing a specific set of Compounds
    occurring in a specific number of physical states. A Property Package will make use of
    certain models to perform these calculations. A Property Package can be configured to
    make use of external Physical Property Calculators and/or Equilibrium Calculators.
    Alternatively, it can provide the functionality of these two components internally without
    making use of external components. Configuring the Compounds, Phases, models and
    external components used in a Property Package is outside the scope of this CAPEOPEN interface specification.
  """
  type PropertyPackage
    function PropertyPackage(constantstrings,t1,constantfloats,t2,tempreturedependents,t3,pressuredependents,t4,propertytable)
      new(
        propmap(constantstrings,t1),
        propmap(constantfloats,t2),
        propmap(tempreturedependents,t3),
        propmap(pressuredependents,t4),
        propertytable
      )
    end
    constantstrings::PropertyMap
    constantfloats::PropertyMap
    tempreturedependents::PropertyMap
    pressuredependents::PropertyMap
    propertytable::Vector{ASCIIString}
  end
  perryanalytic=PropertyPackage(
    getindex(constantstrings,1:3),
    ["Compounds" for i=1:3],
    getindex(constantfloats,[ 5,6,7,8,9,15,16,17,18,
                                20,21,24,28,31]),         
    ["Criticals", "Criticals", "Criticals", "Criticals", "Criticals", "VaporizHeat", "FormationEnergy", "LiquidsDensities", "LiquidsDensities",
     "Compounds", "Compounds", "FormationEnergy", "FormationEnergy", "FormationEnergy"],
    getindex(tempreturedependents,[6,11,12,13,14,21,23,24,26,27,32]),
    ["LiquidsCp", "VaporizHeat", "Cp", "Cp", "Cp", "LiquidThermal", "VaporThermal", "VaporPressure", "LiquidViscos", "VaporViscos", "LiquidsDensities"],
    ["boilingPointTemperature"],
    getindex(pressuredependents,[1]),                  
    ASCIIString[                
      "Compounds"        ,
      "VaporPressure"    ,
      "LiquidsDensities" ,
      "Criticals"        ,
      "VaporizHeat"      ,
      "LiquidsCp"        ,
      "Cp"               ,
      "FormationEnergy"  ,
      "VaporViscos"      ,
      "LiquidViscos"     ,
      "VaporThermal"     ,
      "LiquidThermal"    
    ]                    
  )                      
end
