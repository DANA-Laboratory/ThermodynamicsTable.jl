# Original file is a part of CoolProp project http://www.coolprop.org/coolprop/wrappers/Julia/index.html#julia
push!(Libdl.DL_LOAD_PATH, abspath(joinpath(@__FILE__,"..","..","lib")));
include("../lib/CoolProp.jl")
