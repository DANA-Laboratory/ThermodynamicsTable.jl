# Original file is a part of CoolProp project http://www.coolprop.org/coolprop/wrappers/Julia/index.html#julia

module FreeSteam

export freesteam_set_Ts, freesteam_set_Tx, freesteam_set_pT, freesteam_set_ph, freesteam_set_ps, freesteam_set_pu, freesteam_set_pv, freesteam_set_uv
export freesteam_k, freesteam_mu, freesteam_x, freesteam_w, freesteam_cv, freesteam_cp
export freesteam_s, freesteam_h, freesteam_u, freesteam_v, freesteam_rho, freesteam_p, freesteam_T

@windows_only const FreeSteamLib = abspath(joinpath(@__FILE__,"..","..","lib","freesteam.dll"));
@linux_only const FreeSteamLib = abspath(joinpath(@__FILE__,"..","..","lib","libfreesteam.so"));

immutable SteamState
    region::Char 
    x1::Float64
    x2::Float64    
end

function freesteam_set_Ts(T::Number, s::Number)
  return ccall( (:freesteam_set_Ts, FreeSteamLib), SteamState, (Float64, Float64), T, s)
end

function freesteam_set_Tx(p::Number, x::Number)
  return ccall( (:freesteam_set_Tx, FreeSteamLib), SteamState, (Float64, Float64), p, x)
end

function freesteam_set_pT(p::Number, T::Number)
  return ccall( (:freesteam_set_pT, FreeSteamLib), SteamState, (Float64, Float64), p, T)
end

function freesteam_set_ph(p::Number, h::Number)
  return ccall( (:freesteam_set_ph, FreeSteamLib), SteamState, (Float64, Float64), p, h)
end

function freesteam_set_ps(p::Number, s::Number)
  return ccall( (:freesteam_set_ps, FreeSteamLib), SteamState, (Float64, Float64), p, s)
end

function freesteam_set_pu(p::Number, u::Number)
  return ccall( (:freesteam_set_pu, FreeSteamLib), SteamState, (Float64, Float64), p, u)
end

function freesteam_set_pv(p::Number, v::Number)
  return ccall( (:freesteam_set_pv, FreeSteamLib), SteamState, (Float64, Float64), p, v)
end

function freesteam_set_uv(u::Number, v::Number)
  return ccall( (:freesteam_set_uv, FreeSteamLib), SteamState, (Float64, Float64), u, v)
end

function freesteam_p(S::SteamState)
  return ccall( (:freesteam_p, FreeSteamLib), Float64, (SteamState, ), S)
end

function freesteam_T(S::SteamState)
  return ccall( (:freesteam_T, FreeSteamLib), Float64, (SteamState, ), S)
end

function freesteam_rho(S::SteamState)
  return ccall( (:freesteam_rho, FreeSteamLib), Float64, (SteamState, ), S)
end

function freesteam_v(S::SteamState)
  return ccall( (:freesteam_v, FreeSteamLib), Float64, (SteamState, ), S)
end

function freesteam_u(S::SteamState)
  return ccall( (:freesteam_u, FreeSteamLib), Float64, (SteamState, ), S)
end

function freesteam_h(S::SteamState)
  return ccall( (:freesteam_h, FreeSteamLib), Float64, (SteamState, ), S)
end

function freesteam_s(S::SteamState)
  return ccall( (:freesteam_s, FreeSteamLib), Float64, (SteamState, ), S)
end

function freesteam_cp(S::SteamState)
  return ccall( (:freesteam_cp, FreeSteamLib), Float64, (SteamState, ), S)
end

function freesteam_cv(S::SteamState)
  return ccall( (:freesteam_cv, FreeSteamLib), Float64, (SteamState, ), S)
end

function freesteam_w(S::SteamState)
  return ccall( (:freesteam_w, FreeSteamLib), Float64, (SteamState,), S)
end

function freesteam_x(S::SteamState)
  return ccall( (:freesteam_x, FreeSteamLib), Float64, (SteamState,), S)
end

function freesteam_mu(S::SteamState)
  return ccall( (:freesteam_mu, FreeSteamLib), Float64, (SteamState,), S)
end

function freesteam_k(S::SteamState)
  return ccall( (:freesteam_k, FreeSteamLib), Float64, (SteamState,), S)
end

end #module
