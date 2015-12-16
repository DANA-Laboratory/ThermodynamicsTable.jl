# Download latest binary shared library of CoolProp project
import JSON
const destpathbase = abspath(joinpath(@__FILE__,"..","..","lib"));
const OS_ARCH_CoolProp = (WORD_SIZE == 64) ? "64bit" : "32bit__cdecl";
const OS_ARCH_FreeSteam = (WORD_SIZE == 64) ? "win64" : "win32";
const latestVersion_CoolProp = JSON.parse(readall(download("http://sourceforge.net/projects/coolprop/best_release.json")))["release"]["filename"][11:15];
const latestVersion_FreeSteam = "2.1"
println("CoolProp latestVersion = $latestVersion_CoolProp, by default I am going to install it...")

try
  mkdir(destpathbase)
catch err
  println("lib folder exists")
end

@windows_only begin
    urlbase = "http://netassist.dl.sourceforge.net/project/coolprop/CoolProp/$latestVersion_CoolProp/shared_library/Windows/$OS_ARCH_CoolProp/"
    download(joinpath(urlbase,"CoolProp.dll"),joinpath(destpathbase,"CoolProp.dll"))
    download(joinpath(urlbase,"CoolProp.lib"),joinpath(destpathbase,"CoolProp.lib"))
    download(joinpath(urlbase,"exports.txt"),joinpath(destpathbase,"exports.txt"))
    println("downloaded => lib/CoolProp.dll")
    # FreeSteam
    urlbase = "http://cdn.rawgit.com/DANA-Laboratory/FreeSteamBinary/master/$latestVersion_FreeSteam/$OS_ARCH_FreeSteam/"
    download(joinpath(urlbase,"freesteam.dll"),joinpath(destpathbase,"freesteam.dll"))
    println("downloaded => lib/freesteam.dll")   
end
@linux_only begin
    # CoolProp
    urlbase = "http://netassist.dl.sourceforge.net/project/coolprop/CoolProp/$latestVersion_CoolProp/shared_library/Linux/64bit/libCoolProp.so.$latestVersion_CoolProp"
    download(urlbase,joinpath(destpathbase,"libCoolProp.so"))
    println("downloaded => lib/libCoolProp.so")
    # FreeSteam
    urlbase = "http://cdn.rawgit.com/DANA-Laboratory/FreeSteamBinary/master/$latestVersion_FreeSteam/linux/"
    download(joinpath(urlbase,"libfreesteam.so.1.0"),joinpath(destpathbase,"libfreesteam.so"))
    println("downloaded => lib/libfreesteam.so")
end
@linux_only begin
  using BinDeps
  @BinDeps.setup
  libgsl = library_dependency("libgsl")
  provides(AptGet, Dict(
      "libgsl0ldbl" => libgsl
  ))
  provides(Yum,"gsl",[libgsl])
  @BinDeps.install
end
