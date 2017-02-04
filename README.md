# ThermodynamicsTable

[![Build Status](https://travis-ci.org/DANA-Laboratory/ThermodynamicsTable.jl.svg?branch=master)](https://travis-ci.org/DANA-Laboratory/ThermodynamicsTable.jl)

## Introduction

`ThermodynamicsTable` calculates different physical properties of materials, in 0.0.4 version, it can retrieves 17 constants and computes
11 temperature dependent and 1 pressure dependent property for a set of 345 compounds.  
Main reference for the quantities are *Perry chemical engineering handbook ed.8*,
but some values have been updated using data from other sources (e.g. YAWS) for more precision or integrity and also some typo errors have been corrected.  
Since 0.0.4 this package was fully reviewed for the aim of achieving a similar interface compare to *CAPE-Open Themo 1.1 standard* in the case of naming, definitions and behavior.

## Usage
Refer to CAPE-Open standard a Property Package Manager (PPM), is a software component that manages a set of Property Packages (PP) ,and a Property Package is a software component that can calculate Physical Properties and can retrieve constants for a set of Compounds.  
Here `ThermodynamicsTable` behaves more like a PPM that serves one PP.
```
julia> using ThermodynamicsTable
`perryanalytic` Property Package was created and is ready to use.
```
Two interfaces of CAPE-Open thermo 1.1 standard have been implemented and can be used to interact with the system.  
  1. ICapeThermoUniversalConstants    
    Description:    
      Methods implemented by components that can supply the values of Universal Constants.  

    Units:
      * avogadroConstant => 1/mol
      * boltzmannConstant => J/K
      * idealGasStateReferencePressure => Pa
      * molarGasConstant => J/mol/K
      * speedOfLightInVacuum => m/s
      * standardAccelerationOfGravity => m/s2  

    Methods:
      * getuniversalconstant()
      * getuniversalconstantlist()
  2. ICapeThermoCompounds   
    Description:    
      Methods implemented by components that need to describe the Compounds that occur or can occur in a Material.    

    Methods:
      * getcompoundlist()
      * getcompoundconstant!()
      * getconstproplist()
      * getnumcompounds()
      * getpdependentproperty!()
      * getpdependentproplist()
      * gettdependentproperty!()
      * gettdependentproplist()

```
  using ThermodynamicsTable
  getnumcompounds() # => 345
  compIds,formulae,names,boilTemps,molwts,casnos=getcompoundlist();
  waterid=findfirst(names,"Water") # => 342
  println("formulae=$(formulae[waterid]) boilTemps=$(boilTemps[waterid]) molwts=$(molwts[waterid]) casnos=$(casnos[waterid])")
# => formulae=H2O boilTemps=373.1678389916408 molwts=18.015 casnos=7732-18-5
  getconstproplist()
#=  
    17-element Array{String,1}:
     "iupacName"
     "casRegistryNumber"
     "chemicalFormula"
     "standardFormationGibbsEnergyGas"
     "criticalTemperature"
     "standardEntropyGas"
     "criticalVolume"
     "idealGasGibbsFreeEnergyOfFormationAt25C"
     "molecularWeight"
     "criticalPressure"
     "liquidVolumeAt25C"
     "criticalCompressibilityFactor"
     "standardFormationEnthalpyGas"
     "criticalDensity"
     "normalBoilingPoint"
     "liquidDensityAt25C"
     "heatOfVaporizationAtNormalBoilingPoint"
=#
  comps=UInt16[findfirst(names,name) for name in ["Air","Water","Nitrogen"]];
  propvals=Vector{Union{String,Float64}}();
  try
    getcompoundconstant!(["casRegistryNumber","chemicalFormula","criticalPressure","liquidDensityAt25C"],comps,propvals)
  catch err
    if isa(err,ECapeThrmPropertyNotAvailable)
      println("check $propvals for UNDEFIEND values")
    end
  end
  getpdependentproplist() # => "boilingPointTemperature"
  propvals=Vector{Float64}()
  getpdependentproperty!(["boilingPointTemperature"],80000.,comps,propvals)
```
