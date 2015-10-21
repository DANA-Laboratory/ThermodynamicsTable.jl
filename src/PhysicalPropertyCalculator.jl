"""
  Physical Property Calculator � a software component, which, given the temperature,
  pressure and composition of a Phase of a Material, is able to calculate an additional
  Physical Property or Physical Properties of the Material. Again, a Physical Property
  Calculator will be designed to work with certain kinds of Material. Note that a Physical
  Property Calculator is not called directly by a PME; rather, it is called via a CAPEOPEN Property Package. The purpose of a Physical Property Calculator is to extend or
  to override the list of calculations that a CAPE-OPEN Physical Property Package can
  perform. A CAPE-OPEN Property Calculator can only be used with a Property Package
  which supports the use of Property Calculators.
"""
module PhysicalPropertyCalculator

  export TempPropData, calculate

  type TempPropData
    prop::ASCIIString
    data::Vector{Float64}
    t::Float64
    tc::Float64
    compId::Int
    molweight::Float64
    eqno::Int
  end
  
  """
    casRegistryNumber, # Chemical Abstract Service Registry Number
    chemicalFormula, # Chemical formula
    iupacName, # Complete IUPAC Name
    
    5-  criticalCompressibilityFactor => critical compressibility factor Z
    6-  criticalDensity => critical density in mol/m3
    7-  criticalPressure => critical pressure in Pa
    8-  criticalTemperature => critical temperature in K
    9-  criticalVolume => critical volume in m3/mol
    15- heatOfVaporizationAtNormalBoilingPoint => enthalpy change on vaporization at normal boiling point (101325 Pa) in J/mol
    16- idealGasGibbsFreeEnergyOfFormationAt25C => in J/mol
    17- liquidDensityAt25C => liquid density at 25 ºC in mol/m3
    18- liquidVolumeAt25C => liquid volume at 25 ºC in m3/mol
    20- molecularWeight => relative molar mass
    21- normalBoilingPoint => boiling point temperature at 101325 Pa in K
    24- standardEntropyGas => Standard entropy of gas in J/mol
    28- standardFormationEnthalpyGas => standard enthalpy change on formation of gas in J/mol
    31- standardFormationGibbsEnergyGas => standard Gibbs energy change on formation of gas in J/mol
  """
  function calculate(prop::ASCIIString, data::Array{Union{AbstractString,Float64,Int},2})
    prop=="casRegistryNumber" && (return data[2])
    prop=="chemicalFormula" && (return data[3])
    prop=="iupacName" && (return data[4])
    prop=="criticalCompressibilityFactor" && (return data[6])
    prop=="criticalDensity" && (return data[5])
    prop=="criticalPressure" && (return data[4])
    prop=="criticalTemperature" && (return data[3])
    prop=="criticalVolume" && (return data[5])
    prop=="heatOfVaporizationAtNormalBoilingPoint" && (return data[11])
    prop=="idealGasGibbsFreeEnergyOfFormationAt25C" && (return data[4])
    prop=="liquidDensityAt25C" && (return data[11])
    prop=="liquidVolumeAt25C" && (return data[11])
    prop=="molecularWeight" && (return data[2])
    prop=="normalBoilingPoint" && (return data[6])
    prop=="standardEntropyGas" && (return data[5])
    prop=="standardFormationEnthalpyGas" && (return data[3])
    prop=="standardFormationGibbsEnergyGas" && (return data[4])
  end

  function calculate(d::TempPropData)
    tr::Float64
    ta::Float64
    if (d.prop=="heatCapacityOfLiquid")
      if (d.eqno!=2)
        return d.c[1] + d.c[2]*d.t + d.c[3]*d.t^2 + d.c[4]*d.t^3 + d.c[4]*d.t^4
      else
        tr=1-t/tc
        return (d.c[1]^2)/tr+d.c[2]-2*d.c[1]*d.c[3]*tr-d.c[1]*d.c[4]*tr^2-(d.c[3]^2*tr^3)/3-(d.c[3]*d.c[4]^4)/2-(d.c[4]^2*tr^5)/5
      end
    elseif (d.prop=="heatOfVaporization")
      # Tr = T/Tc. Heat of vaporization in J/kmol
      # perry 2_150 have not presented c5 although it was a part of formula
      tr=t/tc
      return d.c[1]*1e7*(1-d.tr)^(d.c[2]+d.c[3]*d.tr+d.c[4]*d.tr^2)
    elseif (d.prop=="idealGasEnthalpy")
    elseif (d.prop=="idealGasEntropy")
    elseif (d.prop=="idealGasHeatCapacity")
      if (d.eqno==1)
        return d.c[1]+d.c[2]*d.t+d.c[3]*d.t^2+d.c[4]*d.t^3+d.c[5]*d.t^4
      elseif (d.eqno==2)
        return d.c[1]+d.c[2]*((d.c[3]/d.t)/sinh(d.c[3]/d.t))^2+d.c[4]*((d.c[5]/d.t)/cosh(d.c[5]/d.t))^2
      end
    elseif (d.prop=="thermalConductivityOfLiquid") 
      # Thermal conductivites are at either 1 atm or the vapor pressure, whichever is higher.
      return d.c[1]+d.c[2]*d.t+d.c[3]*d.t^2+d.c[4]*d.t^3+d.c[5]*d.t^4
    elseif (d.prop=="thermalConductivityOfVapor")
      # Thermal conductivites are at either 1 atm or the vapor pressure, whichever is lower.
      return d.c[1]*(d.t^d.c[2])/(1+d.c[3]/d.t+d.c[4]/(d.t^2))
    elseif (d.prop=="vaporPressure")
      # Vapor pressure in Pa.
      return exp(d.c[1]+d.c[2]/d.t+d.c[3]*log(d.t)+d.c[4]*d.t^d.c[5])
    elseif (d.prop=="viscosityOfLiquid")
      #  Viscosities are at either 1 atm or the vapor pressure, whichever is higher.
      return exp(d.c[1]*d.c[2]/d.t*d.c[3]*log(d.t)*d.c[4]*d.t^d.c[5])
    elseif (d.prop=="viscosityOfVapor")
      # Viscosities are at either 1 atm or the vapor pressure, whichever is lower. in Pa.
      return d.c[1]*(d.t^d.c[2])/(1+d.c[3]/d.t+d.c[4]/(d.t^2))
    elseif (d.prop=="volumeOfLiquid")
      #Liquid dencity 
      if (d.t>=d.c[5] && d.t<=d.c[7])
        if (d.eqno==2)
          return d.c[1]+d.c[2]*d.t+d.c[3]*d.t^2+d.c[4]*d.t^3 # o-terphenyl and water limited range
        end
        if (d.eqno==3) # For water over the entire temperature range of 273.16 to 647.096 K.
          ta=1-(d.t/647.096)
          return 17.863+58.606*ta^0.35 - 95.396*ta^(2/3)+213.89*ta- 141.26*ta^(4/3)
        end
        return d.c[1]/(d.c[2]^(1+(1-d.t/d.c[3])^d.c[4]))  # The others
      else
        return NaN
      end
    end
  end
end
