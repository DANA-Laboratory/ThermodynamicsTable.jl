"""
  Physical Property Calculator – a software component, which, given the temperature,
  pressure and composition of a Phase of a Material, is able to calculate an additional
  Physical Property or Physical Properties of the Material. Again, a Physical Property
  Calculator will be designed to work with certain kinds of Material. Note that a Physical
  Property Calculator is not called directly by a PME; rather, it is called via a CAPEOPEN Property Package. The purpose of a Physical Property Calculator is to extend or
  to override the list of calculations that a CAPE-OPEN Physical Property Package can
  perform. A CAPE-OPEN Property Calculator can only be used with a Property Package
  which supports the use of Property Calculators.
"""
module PhysicalPropertyCalculator
  export vp, ldwater, ldlimited, ld, hv, cppoly, cphyper, vv, lv, vtc, ltc
  # Vapor pressure in Pa.
  function vp(c1::Float64, c2::Float64, c3::Float64, c4::Float64, c5::Float64, t::Float64) 
    return exp(c1 + c2/t + c3*ln(t) + c4*t^c5)
  end
  
  # For water over the entire temperature range of 273.16 to 647.096 K.
  function ldwater(t::Float64) 
    ?=1-(t/647.096)
    return 17.863+58.606*?^0.35 - 95.396*?^(2/3)+213.89*?- 141.26*?^(4/3)
  end
  
  #  o-terphenyl and water
  function ldlimited(c1::Float64,c2::Float64,c3::Float64,c4::Float64,t::Float64) 
    return c1+c2*t+c3*t^2+c4*t^3
  end
  
  # The others, The pressure is equal to the vapor pressure for pressures greater than 1 atm and equal to 1 atm when the vapor pressure is less than 1 atm. 
  function ld(c1::Float64,c2::Float64,c3::Float64,c4::Float64,t::Float64) 
    return c1/(c2^(1+(1-t/c3)^c4))
  end

  # Tr = T/Tc. Heat of vaporization in J/kmol
  function hv(c1::Float64, c2::Float64, c3::Float64, c4::Float64, c5::Float64, tr::Float64) 
    return c1*(1 -tr)^(c2+c3*tr+c4*tr^2+c5*tr^3)
  end
  
  function cppoly(c1::Float64, c2::Float64, c3::Float64, c4::Float64, c5::Float64, t::Float64)
    return c1+c2*t+c3*t^2+c4*t^3+c5*t^4
  end

  function cphyper(c1::Float64, c2::Float64, c3::Float64, c4::Float64, c5::Float64, t::Float64)
    return c1+c2*((c3/t)/sinh(c3/t))^2+c4*((c5/t)/cosh(c5/t))^2
  end

  # Viscosities are at either 1 atm or the vapor pressure, whichever is lower. in Pa.
  function vv(c1::Float64, c2::Float64, c3::Float64, c4::Float64, c5::Float64, t::Float64) 
    return c1*(t^c2)/(1+c3/t+c4/(t^2))
  end
  
  #  Viscosities are at either 1 atm or the vapor pressure, whichever is higher.
  function lv(c1::Float64, c2::Float64, c3::Float64, c4::Float64, c5::Float64, t::Float64) 
    return exp(c1*c2/t*c3*ln(t)*c4*t^c5)
  end
   
  # Thermal conductivites are at either 1 atm or the vapor pressure, whichever is lower.
  function vtc(c1::Float64, c2::Float64, c3::Float64, c4::Float64, t::Float64) 
    return c1*(t^c2)/(1+c3/t+c4/(t^2))
  end
  
  # Thermal conductivites are at either 1 atm or the vapor pressure, whichever is higher.
  function ltc(c1::Float64, c2::Float64, c3::Float64, c4::Float64, c5::Float64, t::Float64) 
    return c1+c2*t+c3*t^2+c4*t^3+c5*t^4
  end

end