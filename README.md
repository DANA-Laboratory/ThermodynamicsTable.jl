# ThermodynamicsTable

[![Build Status](https://travis-ci.org/DANA-Laboratory/ThermodynamicsTable.jl.svg?branch=master)](https://travis-ci.org/DANA-Laboratory/ThermodynamicsTable.jl)

## Introduction

`ThermodynamicsTable` calculates different physical properties of materials, the 0.0.8 version, returns 14 constants, 
11 temperature dependent and 1 pressure dependent properties for a set of 345 componds.  
Main reference for the quantities are Perry chemical engineering handbook ed.8,
but some values have been updated from other sources (e.g. YAWS) for more precision or integrity and some typical typo errors have been corrected.  
Since 0.0.8 version this package was fully reviewed for the aim of achieving a similar interface to CAPE-Open Themo 1.1 standard in the case of naming, definitions and behaviours. 

## Usage
Refer to CAPE-Open standard a Property Package Manager (PPM), is a software component that manages a set of Property Packages (PP) ,and a Property Package is a software component that can calculate Physical Properties and can return constants for a set of Compounds.  
Here `ThermodynamicsTable` behaves like a PPM that serves one PP.
```
julia> using ThermodynamicsTable
`perryanalytic` Property Package was created and is ready to use.
```
Two interfaces of CAPE-Open thermo 1.1 standard have been implemented and can be used to interact with the system.  
  1. ICapeThermoUniversalConstants
  2. ICapeThermoCompounds