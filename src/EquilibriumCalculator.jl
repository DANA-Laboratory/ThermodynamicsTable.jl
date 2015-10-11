"""
  Equilibrium Calculator – a software component, which, given a description of a
  Material, and a specification of constraints on the calculations such as temperature and
  pressure, can calculate the composition of each Phase present in the Material. An
  Equilibrium Calculator will typically be designed to work with certain types of Material.
  That is, it will provide the Phase compositions for Materials containing a subset of the
  set of Compounds known to the Equilibrium Calculator, where those Compounds occur
  in Phases known to the Equilibrium Calculator. For example, a specific Equilibrium
  Calculator may not be able to deal with Materials with solid Phases, or those containing
  polymeric Compounds. Note that an Equilibrium Calculator is not called directly by a
  PME. Like a Physical Property Calculator, it is only called via a Property Package. Like
  a Property Calculator, the purpose of an Equilibrium Calculator is to extend or to
  override the list of Equilibrium Calculations that a CAPE-OPEN Property Package can
  perform. A CAPE-OPEN Equilibrium Calculator can only be used with a Property
  Package which supports the use of Equilibrium Calculators.
"""
module EquilibriumCalculator

end