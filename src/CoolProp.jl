# Original file is a part of CoolProp project http://www.coolprop.org/coolprop/wrappers/Julia/index.html#julia

@static if is_windows()
  const CoolPropLib = abspath(joinpath(@__FILE__,"..","..","lib"));
end
@static if is_linux()
  const CoolPropLib = abspath(joinpath(@__FILE__,"..","..","lib"));
end
println(CoolPropLib);
push!(Libdl.DL_LOAD_PATH, CoolPropLib);

include("../lib/CoolProp.jl")
