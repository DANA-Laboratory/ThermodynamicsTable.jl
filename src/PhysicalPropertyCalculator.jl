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

  using ECapeExceptions
  export TempPropData, calculate

  type TempPropData
    function TempPropData(prop::ASCIIString,c::Vector{Float64},compId::UInt16,molweight::Float64)
      new(prop,c,NaN,NaN,compId,molweight,0%UInt8)
    end
    prop::ASCIIString
    c::Vector{Float64}
    t::Float64
    tc::Float64
    compId::UInt16
    molweight::Float64
    eqno::UInt8
    test::Vector{Float64}
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
  function calculate(prop::ASCIIString, data::Array)
    floats::Vector{Float64}
    
    prop=="casRegistryNumber" && (return ASCIIString(data[1]))
    prop=="chemicalFormula" && (return ASCIIString(data[2]))
    prop=="iupacName" && (return ASCIIString(data[3]))
    
    floats=data[1]
    prop=="criticalCompressibilityFactor" && (return floats[5])
    prop=="criticalDensity" && (return floats[4])
    prop=="criticalPressure" && (return floats[3])
    prop=="criticalTemperature" && (return floats[2])
    prop=="criticalVolume" && (return floats[4])
    prop=="heatOfVaporizationAtNormalBoilingPoint" && (return floats[10])
    prop=="idealGasGibbsFreeEnergyOfFormationAt25C" && (return floats[3])
    prop=="liquidDensityAt25C" && (return floats[10])
    prop=="liquidVolumeAt25C" && (return floats[10])
    prop=="molecularWeight" && (return floats[1])
    prop=="normalBoilingPoint" && (return floats[5])
    prop=="standardEntropyGas" && (return floats[4])
    prop=="standardFormationEnthalpyGas" && (return floats[2])
    prop=="standardFormationGibbsEnergyGas" && (return floats[3])
    
    throw(ECapeThrmPropertyNotAvailable())
  end

  function calculate(d::TempPropData)
    tr::Float64
    ta::Float64
    (d.t<d.test[1] || d.t>d.test[3]) && throw(ECapeOutOfBounds())
    if (d.prop=="heatCapacityOfLiquid")
      if (d.eqno!=2)
        return d.c[1] + d.c[2]*d.t + d.c[3]*d.t^2 + d.c[4]*d.t^3 + d.c[5]*d.t^4  #???? check perry
      else
        tr=1-d.t/d.tc
        return (d.c[1]^2)/tr+d.c[2]-2*d.c[1]*d.c[3]*tr-d.c[1]*d.c[4]*tr^2-(d.c[3]^2*tr^3)/3-(d.c[3]*d.c[4]*tr^4)/2-(d.c[4]^2*tr^5)/5
      end
    elseif (d.prop=="heatOfVaporization")
      # Tr = T/Tc. Heat of vaporization in J/kmol
      # perry 2_150 have not presented c5 although it was a part of formula
      tr=d.t/d.tc
      return d.c[1]*1e7*(1-tr)^(d.c[2]+d.c[3]*tr+d.c[4]*tr^2)
    elseif (d.prop=="idealGasHeatCapacity")
      if (d.eqno==1)
        return d.c[1]+d.c[2]*d.t+d.c[3]*d.t^2+d.c[4]*1e-5*d.t^3+d.c[5]*1e-10*d.t^4
      elseif (d.eqno==2)
        c1::Float64
        c2::Float64
        c3::Float64
        c4::Float64
        c1=d.c[1]*1e5
        c2=d.c[2]*1e5
        c3=d.c[3]*1e3
        c4=d.c[4]*1e5
        return c1+c2*((c3/d.t)/sinh(c3/d.t))^2+c4*((d.c[5]/d.t)/cosh(d.c[5]/d.t))^2
      end
    elseif (d.prop=="idealGasEnthalpy")
      if(d.eqno==1)
        return d.c[1]*d.t+1/2*d.c[2]*d.t^2+1/3*d.c[3]*d.t^3+1/4*d.c[4]*d.t^4+1/5*d.c[5]*d.t^5 # Integ of Cp Poly
      elseif(d.eqno==2)
        return d.c[1]*d.t+d.c[2]*d.c[3]*coth(d.c[3]/d.t)-d.c[4]*d.c[5]*tanh(d.c[5]/d.t) # Integ of Cp Hyper
      end
    elseif (d.prop=="idealGasEntropy") 
      if(d.eqno==1)
        return d.c[2]*d.t+(d.c[3]*d.t^2)/2+(d.c[4]*d.t^3)/3+(d.c[5]*d.t^4)/4+d.c[1]*log(d.t) # Integral of Cp/T Poly
      elseif(d.eqno==2)
        return (d.c[2]*d.c[3]*coth(d.c[3]/d.t)+d.c[1]*d.t*log(d.t)+d.c[4]*d.t*log(cosh(d.c[5]/d.t))-d.c[2]*d.t*log(sinh(d.c[3]/d.t))-d.c[4]*d.c[5]*tanh(d.c[5]/d.t))/d.t # Integral of Cp/T Hyper
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
      return exp(d.c[1]+d.c[2]/d.t+d.c[3]*log(d.t)+d.c[4]*d.t^d.c[5])
    elseif (d.prop=="viscosityOfVapor")
      # Viscosities are at either 1 atm or the vapor pressure, whichever is lower. in Pa.
      return d.c[1]*(d.t^d.c[2])/(1+d.c[3]/d.t+d.c[4]/(d.t^2))
    elseif (d.prop=="volumeOfLiquid")
      #Liquid dencity 
      if (d.eqno==2)
        return d.c[1]+d.c[2]*d.t+d.c[3]*d.t^2+d.c[4]*d.t^3 # o-terphenyl and water limited range
      end
      if (d.eqno==3) # For water over the entire temperature range of 273.16 to 647.096 K.
        ta=1-(d.t/647.096)
        return 17.863+58.606*ta^0.35 - 95.396*ta^(2/3)+213.89*ta- 141.26*ta^(4/3)
      end
      return d.c[1]/(d.c[2]^(1+(1-d.t/d.c[3])^d.c[4]))  # The others
    end
  end
end
