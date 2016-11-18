using Base.Test
using ThermodynamicsTable
include("maintest.jl")
include("freesteam.jl")
@static is_apple() ? println("CoolProp: no osx support") : begin
  include("coolproptest.jl")
  include("coolvsperry.jl")
  include("coolproplowlevel.jl")
end
