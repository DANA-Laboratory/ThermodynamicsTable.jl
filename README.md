# ThermodynamicsTable

[![Build Status](https://travis-ci.org/DANA-Laboratory/ThermodynamicsTable.jl.svg?branch=master)](https://travis-ci.org/DANA-Laboratory/ThermodynamicsTable.jl)

##Introduction
`use ThermodynamicsTable` Adds some thermodynamics tables for calculating **critical values, heat capacity, ...**

Each table loads only once after first call 

Properties can retured using a chemical name

Also names can be found a using *chemical formula* or [CasNo](http://en.wikipedia.org/wiki/List_of_CAS_numbers_by_chemical_compound).

##Usage
`getvalueforname(property::String , name::String)`
with one of the following values for *property*:
- **"Profile"**

  Return value:
  (formula,casno,molarweight)

- **"Criticals"** 
  
  Return value: Chemical critical values

  (Tc *Critical Temprature in Kelvin* ,Pc *Critical Pressure in Pascal*,Af *Acentric Factor*, Zc *Critical Compresibility*) 
  
  Refference: 
  Perry 8ed. TABLE 2-141 Critical Constants and Acentric Factors of Inorganic and Organic Compounds

- **"CpHyper"**

  Return value: Heat Capacity at Constant Pressure of Inorganic and Organic Compounds in the Ideal Gas State Fit to Hyperbolic Function in J/(kmol.Kelvin)
  (C1,C2,C3,C4,C5)
  
  Constants in this table can be used in the following equation to calculate the ideal gas heat capacity `Cp=C1+C2*((C3/T)/sinh(C3/T))^2+C4*((C5/T)/cosh(C5/T))^2`

  Refference:
  Perry 8ed. TABLE 2-156 Heat Capacity at Constant Pressure of Inorganic and Organic Compounds in the Ideal Gas State Fit to Hyperbolic Functions Cp [J/(kmol.Kelvin)]
  
- **"CpPoly"**
  
  Return value: Heat Capacity at Constant Pressure of Inorganic and Organic Compounds in the Ideal Gas State Fit to a Polynomial in J/(kmol.Kelvin)
  (C1,C2,C3,C4,C5)
  
  Constants in this table can be used in the following equation to calculate the ideal gas heat capacity `Cp=C1+C2*T+C3*T^2+C4*T^3+C5*T^4`

  Refference: 
  Perry 8ed. TABLE 2-155 Heat Capacity at Constant Pressure of Inorganic and Organic Compounds in the Ideal Gas State Fit to a Polynomial Cp [J/(kmol.K)]

- **"LiquidsDensities"**

  Return value: Densities of Inorganic and Organic Liquids in mol/dm3
  (C1,C2,C3,C4,Tmin.Tmax)

  Except for o-terphenyl and water, liquid density ρ is calculated by `ρ=C1/(C2^(1+(1-T/C3)^C4))`

  Where ρ is in mol/dm3 and T is in K. The pressure is equal to the vapor pressure for pressures greater than 1 atm and equal to 1 atm when the vapor pressure is less than 1 atm.

  For o-terphenyl and water in the limited temperature ranges , the equation is `ρ=C1+C2*T+C3*T^2+C4*T^3`

  For water over the entire temperature range of 273.16 to 647.096 K, use `ρ=17.863+58.606τ^0.35−95.396τ^(2/3)+213.89τ−141.26τ^(4/3)` where `τ=1−T/647.096`

  Refference: 
  Perry 8ed. TABLE 2-32 Densities of Inorganic and Organic Liquids in mol/dm3

- **"LiquidsVaporPressure"**

  Return value: Vapor Pressure of Inorganic and Organic Liquids in Pa
  (C1,C2,C3,C4,C5,Tmin.Tmax)

  Vapor pressure Ps is calculated by `Ps=exp(C1+C2/T+C3*ln(T)+C4*T^C5)`

  Refference:
  Perry 8ed. TABLE 2-8 Vapor Pressure of Inorganic and Organic Liquids 

- **"LiquidsCp"**

  Return value: Heat Capacities of Inorganic and Organic Liquids in J/(kmol.K)
  (C1,C2,C3,C4,C5,Tmin.Tmax)

  For the 11 substances, ammonia, 1,2-butanediol, 1,3-butanediol, carbon monoxide, 1,1-difluoroethane, ethane, heptane, hydrogen, hydrogen sulfide, methane, and propane, the liquid heat capacity CpL is calculated with Eq.(2) below. For all other compounds, Eq.(1) is used. For benzene, fluorine, and helium, two sets of constants are given for Eq.(1) that cover different temperature ranges, as shown in the table.

  Eq(1)->`CpL=C1+C2*T+C3*T2+C4*T3+C4T4`
  Eq(2)->`CpL=(C1^2)/t+C2−2*C1*C3*t−C1*C4*t^2−(C3^2*t^3)/3−(C3*C4*t^4)/2−(C4*t^5)/5`

  Refference:
  Perry 8ed. TABLE 2-153 Heat Capacities of Inorganic and Organic Liquids

`getallnamesforproperty(property::String)`

With *property* one of the aboves, returns all available chemical names

`getnameforcasno(casno::String)` and `getnameforformula(formula::String)`

Gets *matrial name* for *casno* or *formula*

