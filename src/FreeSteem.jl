module FreeSteam

# export

@windows_only const FreeSteem = abspath(joinpath(@__FILE__,"..","..","lib","freesteem.dll"));
@linux_only const FreeSteem = abspath(joinpath(@__FILE__,"..","..","lib","libfreesteem.so"));

function F2K(TF::Number)
  return ccall( (:F2K, FreeSteem), Cdouble, (Cdouble,), TF)
end

end
