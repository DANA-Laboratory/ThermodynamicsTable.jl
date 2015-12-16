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

function freesteam_region1_set_pT(p::Float64, T::Float64)
  return ccall( (:freesteam_region1_set_pT, FreeSteamLib), SteamState, (Float64, Float64), p, T)
end

#=
FREESTEAM_DLL double freesteam_region4_psat_T(double T);
FREESTEAM_DLL double freesteam_region4_Tsat_p(double p);

FREESTEAM_DLL double freesteam_region4_rhof_T(double T);
FREESTEAM_DLL double freesteam_region4_rhog_T(double T);

FREESTEAM_DLL double freesteam_region4_v_Tx(double T, double x);
FREESTEAM_DLL double freesteam_region4_u_Tx(double T, double x);
FREESTEAM_DLL double freesteam_region4_h_Tx(double T, double x);
FREESTEAM_DLL double freesteam_region4_s_Tx(double T, double x);
FREESTEAM_DLL double freesteam_region4_cp_Tx(double T, double x);
FREESTEAM_DLL double freesteam_region4_cv_Tx(double T, double x);

FREESTEAM_DLL double freesteam_region4_dpsatdT_T(double T);

FREESTEAM_DLL double freesteam_region3_p_rhoT(double rho, double T);
FREESTEAM_DLL double freesteam_region3_u_rhoT(double rho, double T);
FREESTEAM_DLL double freesteam_region3_s_rhoT(double rho, double T);
FREESTEAM_DLL double freesteam_region3_h_rhoT(double rho, double T);
FREESTEAM_DLL double freesteam_region3_cp_rhoT(double rho, double T);
FREESTEAM_DLL double freesteam_region3_cv_rhoT(double rho, double T);
FREESTEAM_DLL double freesteam_region3_w_rhoT(double rho, double T);

FREESTEAM_DLL double freesteam_region2_v_pT(double p, double T);
FREESTEAM_DLL double freesteam_region2_u_pT(double p, double T);
FREESTEAM_DLL double freesteam_region2_s_pT(double p, double T);
FREESTEAM_DLL double freesteam_region2_h_pT(double p, double T);
FREESTEAM_DLL double freesteam_region2_cp_pT(double p, double T);
FREESTEAM_DLL double freesteam_region2_cv_pT(double p, double T);
FREESTEAM_DLL double freesteam_region2_w_pT(double p, double T);
FREESTEAM_DLL double freesteam_region2_a_pT(double p, double T);
FREESTEAM_DLL double freesteam_region2_g_pT(double p, double T);

FREESTEAM_DLL double freesteam_region1_u_pT(double p, double T);
FREESTEAM_DLL double freesteam_region1_v_pT(double p, double T);
FREESTEAM_DLL double freesteam_region1_s_pT(double p, double T);
FREESTEAM_DLL double freesteam_region1_h_pT(double p, double T);
FREESTEAM_DLL double freesteam_region1_cp_pT(double p, double T);
FREESTEAM_DLL double freesteam_region1_cv_pT(double p, double T);
FREESTEAM_DLL double freesteam_region1_w_pT(double p, double T);
FREESTEAM_DLL double freesteam_region1_a_pT(double p, double T);
FREESTEAM_DLL double freesteam_region1_g_pT(double p, double T);

FREESTEAM_DLL double freesteam_b23_p_T(double T);
FREESTEAM_DLL double freesteam_b23_T_p(double p);

FREESTEAM_DLL double freesteam_region1_T_ph(double p, double h);
FREESTEAM_DLL double freesteam_region2_T_ph(double p, double h);
FREESTEAM_DLL double freesteam_region3_T_ph(double p, double h);
FREESTEAM_DLL double freesteam_region3_v_ph(double p, double h);
FREESTEAM_DLL double freesteam_region3_psat_h(double h);
FREESTEAM_DLL double freesteam_region3_psat_s(double s);

FREESTEAM_DLL double freesteam_region3_T_ps(double p, double h);
FREESTEAM_DLL double freesteam_region3_v_ps(double p, double h);

FREESTEAM_DLL SteamState freesteam_bound_pmax_T(double T);

FREESTEAM_DLL double freesteam_deriv(SteamState S, char xyz[3]);

FREESTEAM_DLL double freesteam_drhofdT_T(double T);
FREESTEAM_DLL double freesteam_drhogdT_T(double T);

FREESTEAM_DLL double freesteam_region3_dAdvT(FREESTEAM_CHAR,SteamState);
FREESTEAM_DLL double freesteam_region3_dAdTv(FREESTEAM_CHAR,SteamState);
FREESTEAM_DLL double freesteam_region1_dAdTp(FREESTEAM_CHAR,SteamState);
FREESTEAM_DLL double freesteam_region1_dAdpT(FREESTEAM_CHAR,SteamState);
FREESTEAM_DLL double freesteam_region2_dAdTp(FREESTEAM_CHAR,SteamState);
FREESTEAM_DLL double freesteam_region2_dAdpT(FREESTEAM_CHAR,SteamState);
FREESTEAM_DLL double freesteam_region4_dAdTx(FREESTEAM_CHAR,SteamState);
FREESTEAM_DLL double freesteam_region4_dAdxT(FREESTEAM_CHAR,SteamState);

FREESTEAM_DLL double freesteam_surftens_T(double T);
FREESTEAM_DLL double freesteam_k_rhoT(double rho, double T);
FREESTEAM_DLL double freesteam_mu_rhoT(double rho, double T);
=#

end #module
