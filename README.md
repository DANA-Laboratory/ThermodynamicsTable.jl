# ThermodynamicsTable

[![Build Status](https://travis-ci.org/DANA-Laboratory/ThermodynamicsTable.jl.svg?branch=master)](https://travis-ci.org/DANA-Laboratory/ThermodynamicsTable.jl)

##Introduction
`ThermodynamicsTable` package adds some Thermodynamics Table for calculating chemical physical properties. Material contants to calculate different properties are stored in seperate text files (tables), the key to retrieve material contants is it's *chemical name*, that itself can be found using it's *chemical formula* or [CasNo](http://en.wikipedia.org/wiki/List_of_CAS_numbers_by_chemical_compound).  
Each table loads once after first call to it.
At this time avialable tables are: **Heat Capacity, Density and Vapor Pressure**.

##Usage
`getvalueforname(property::String , chemicalname::String)`
Retrieve Tuples of constansts from a Thermodynamics Table for chemical specified by *chemicalname*.
Here *property* must be one of the following values: 
- **"Profile"**

  Profile for chemical specified by *chemicalname*

  Return value: 
  (formula, casno, molarweight)

- **"Criticals"** 
  
  Critical Constants for chemical specified by *chemicalname*
  
  Return value: 
  (Tc *Critical Temprature in Kelvin* ,Pc *Critical Pressure in Pascal*,Af *Acentric Factor*, Zc *Critical Compresibility*) 
  
  Refference: 
  Perry 8ed. TABLE 2-141 Critical Constants and Acentric Factors of Inorganic and Organic Compounds

- **"CpHyper"**

  Heat Capacity at Constant Pressure of Inorganic and Organic Compounds in the Ideal Gas State Fit to Hyperbolic Function in J/(kmol.Kelvin) for chemical specified by *chemicalname*

  Return value: 
  (C1, C2, C3, C4, C5)
  
  Note:
  Constants in this table can be used in the following equation to calculate the ideal gas heat capacity `Cp=C1+C2*((C3/T)/sinh(C3/T))^2+C4*((C5/T)/cosh(C5/T))^2`

  Refference:
  Perry 8ed. TABLE 2-156 Heat Capacity at Constant Pressure of Inorganic and Organic Compounds in the Ideal Gas State Fit to Hyperbolic Functions Cp [J/(kmol.Kelvin)]
  
- **"CpPoly"**
  
  Heat Capacity at Constant Pressure of Inorganic and Organic Compounds in the Ideal Gas State Fit to a Polynomial in J/(kmol.Kelvin) for chemical specified by *chemicalname*
  
  Return value: 
  (C1, C2, C3, C4, C5)
  
  Note:
  Constants in this table can be used in the following equation to calculate the ideal gas heat capacity `Cp=C1+C2*T+C3*T^2+C4*T^3+C5*T^4`

  Refference: 
  Perry 8ed. TABLE 2-155 Heat Capacity at Constant Pressure of Inorganic and Organic Compounds in the Ideal Gas State Fit to a Polynomial Cp [J/(kmol.K)]

- **"LiquidsDensities"**

  Densities of Inorganic and Organic Liquids in mol/dm3 for chemical specified by *chemicalname*

  Return value: 
  (C1, C2, C3, C4, Tmin, Tmax)

  Note:
  Except for o-terphenyl and water, liquid density ρ is calculated by `ρ=C1/(C2^(1+(1-T/C3)^C4))`

  Where ρ is in mol/dm3 and T is in K. The pressure is equal to the vapor pressure for pressures greater than 1 atm and equal to 1 atm when the vapor pressure is less than 1 atm.

  For o-terphenyl and water in the limited temperature ranges , the equation is `ρ=C1+C2*T+C3*T^2+C4*T^3`

  For water over the entire temperature range of 273.16 to 647.096 K, use `ρ=17.863+58.606τ^0.35−95.396τ^(2/3)+213.89τ−141.26τ^(4/3)` where `τ=1−T/647.096`

  Refference: 
  Perry 8ed. TABLE 2-32 Densities of Inorganic and Organic Liquids in mol/dm3

- **"LiquidsVaporPressure"**

  Vapor Pressure of Inorganic and Organic Liquids in Pa for chemical specified by *chemicalname*

  Return value: 
  (C1, C2, C3, C4, C5, Tmin, Tmax)

  Note:
  Vapor pressure Ps is calculated by `Ps=exp(C1+C2/T+C3*ln(T)+C4*T^C5)`

  Refference:
  Perry 8ed. TABLE 2-8 Vapor Pressure of Inorganic and Organic Liquids for chemical specified by *chemicalname*

- **"LiquidsCp"**

  Heat Capacities of Inorganic and Organic Liquids in J/(kmol.K)

  Return value: 
  (C1, C2, C3, C4, C5, Tmin, Tmax)

  Note:
  For the 11 substances, ammonia, 1,2-butanediol, 1,3-butanediol, carbon monoxide, 1,1-difluoroethane, ethane, heptane, hydrogen, hydrogen sulfide, methane, and propane, the liquid heat capacity CpL is calculated with Eq.(2) below. For all other compounds, Eq.(1) is used. For benzene, fluorine, and helium, two sets of constants are given for Eq.(1) that cover different temperature ranges, as shown in the table.

  Eq(1)->`CpL=C1+C2*T+C3*T^2+C4*T^3+C4*T^4`
  Eq(2)->`CpL=(C1^2)/t+C2−2*C1*C3*t−C1*C4*t^2−(C3^2*t^3)/3−(C3*C4*t^4)/2−(C4*t^5)/5`

  Where `t=1−Tr`,`Tr=T/Tc`, Tc is the critical temperature. CpL is in J/(kmol) and T is in K.
  For temperatures less than the normal boiling point, the pressure is 1 atm. Above the normal boiling point, the pressure is the vapor pressure.

  Refference:
  Perry 8ed. TABLE 2-153 Heat Capacities of Inorganic and Organic Liquids

`getallnamesforproperty(property::String)`

With *property* one of the aboves, retrieve all available chemical names

`getnameforcasno(casno::String)` and `getnameforformula(formula::String)`

Retrieve *matrial name* for *casno* or *formula*

