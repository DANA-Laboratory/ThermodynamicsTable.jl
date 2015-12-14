# Download latest binary shared library of CoolProp project
import JSON

const destpathbase = abspath(joinpath(@__FILE__,"..","..","lib"));
const OS_ARCH = (WORD_SIZE == 64) ? "64bit" : "32bit__cdecl";
const latestVersion = JSON.parse(readall(download("http://sourceforge.net/projects/coolprop/best_release.json")))["release"]["filename"][11:15];

println("CoolProp latestVersion = $latestVersion, by default I am going to install it...")

mkdir(destpathbase)

@windows_only begin
    urlbase = "http://netassist.dl.sourceforge.net/project/coolprop/CoolProp/$latestVersion/shared_library/Windows/$OS_ARCH/"
    download(joinpath(urlbase,"CoolProp.dll"),joinpath(destpathbase,"CoolProp.dll"))
    download(joinpath(urlbase,"CoolProp.lib"),joinpath(destpathbase,"CoolProp.lib"))
    download(joinpath(urlbase,"exports.txt"),joinpath(destpathbase,"exports.txt"))
    println("downloaded => lib/CoolProp.dll")
end
@linux_only begin
    url = "http://netassist.dl.sourceforge.net/project/coolprop/CoolProp/$latestVersion/shared_library/Linux/64bit/libCoolProp.so.$latestVersion"
    download(url,joinpath(destpathbase,"CoolProp.so"))
    println("downloaded => lib/CoolProp.so")
end
