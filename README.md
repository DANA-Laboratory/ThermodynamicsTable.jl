# ThermodynamicsTable

[![Build Status](https://travis-ci.org/DANA-Laboratory/ThermodynamicsTable.jl.svg?branch=master)](https://travis-ci.org/DANA-Laboratory/ThermodynamicsTable.jl)

##Introduction
Adds some thermodynamics tables for calculating **critical values, heat capacity, ...**

`use ThermodynamicsTable` loads all values from local files.
then properties can retured using chemical
[CasNo](http://en.wikipedia.org/wiki/List_of_CAS_numbers_by_chemical_compound) as key index.
##Usage
`getvalueforcasno(property::String , casno::String)`
with one of the folowing values for **property**:
- **"Criticals"** 
  
  Refference: 
  
  Perry 8ed. TABLE 2-141 Critical Constants and Acentric Factors of Inorganic and Organic Compounds
  
  Return value:
  (Tc *in Kelvin*,Pc *in Pascal*,Zc)
  
- **"CpHyper"**

  Refference:
  
  Perry 8ed. TABLE 2-156 Heat Capacity at Constant Pressure of Inorganic and Organic Compounds in the Ideal Gas State Fit to Hyperbolic Functions Cp [J/(kmolK)]
  
  Return value:
  (C1,C2,C3,C4,C5)
  
  Formula -> `Cp=C1+C2*((C3/T)/sinh(C3/T))^2+C4*((C5/T)/cosh(C5/T))^2`

- **"CpPoly"**
  
  Refference: 
  
  Perry 8ed. TABLE 2-155 Heat Capacity at Constant Pressure of Inorganic and Organic Compounds in the Ideal Gas State Fit to a Polynomial Cp [J/(kmolK)]
  
  Return value:
  (C1,C2,C3,C4,C5)
  
  Formula -> `Cp=C1+C2*T+C3*T^2+C4*T^3+C5*T^4`

- **Profile**

  Return value:
  (name,formula,molarweight)

Also if you want casno for matrial name or formula please use the followings:

`getcasnoforname(name::String)` and `getcasnoforformula(formula::String)`
