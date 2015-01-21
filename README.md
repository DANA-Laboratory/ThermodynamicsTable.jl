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

  (Tc *Critical Temprature in Kelvin* ,Pc *Critical Pressure in Pascal*, Zc *Critical Compresibility*) 
  
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

`getallnamesforproperty(property::String)`

With *property* one of the aboves, returns all available chemical names

`getnameforcasno(casno::String)` and `getnameforformula(formula::String)`

Gets *matrial name* for *casno* or *formula*

