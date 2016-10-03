# Original file is a part of CoolProp project http://www.coolprop.org/coolprop/wrappers/Julia/index.html#julia
# 73+13+14=100 == 106-1(common)-4(solver)-1(print)
# 12+13+39+8+1=73 == 74-1(common) => doubles OK
# 12+1=13 == 17-4(solver) => SteamStates OK
# 6+7+1=14 == 15-1(print) => Int OK
module FreeSteam

immutable SteamState
    region::Char
    x1::Float64
    x2::Float64
end

immutable XYZ
  x::Char
  y::Char
  z::Char
end

#all 12 SteamState functions (double, double) exported (part 1)
  const set_xy = [:freesteam_set_Ts, :freesteam_set_Tx, :freesteam_set_pT, :freesteam_set_ph,
                    :freesteam_set_ps, :freesteam_set_pu, :freesteam_set_pv, :freesteam_set_uv]
@eval export($(set_xy...))

#all 12 SteamState functions (double, double) exported (part 2)
const reg_set_xy = [:freesteam_region1_set_pT, :freesteam_region2_set_pT, :freesteam_region3_set_rhoT, :freesteam_region4_set_Tx]
@eval export($(reg_set_xy...))
for f in [set_xy; reg_set_xy]
  @eval function $f(x::Number, y::Number)
    return ccall( ($(QuoteNode(f)), FreeSteamLib), SteamState, (Float64, Float64), x, y)
  end
end

#all 13 double functions (SteamState) exported
const _S = [:freesteam_k,  :freesteam_mu, :freesteam_x,   :freesteam_w,
             :freesteam_cv, :freesteam_cp, :freesteam_s, :freesteam_h,
             :freesteam_u,  :freesteam_v,  :freesteam_rho, :freesteam_p,
             :freesteam_T]
@eval export($(_S...))
for f in _S
  @eval function $f(S::SteamState)
    return ccall( ($(QuoteNode(f)), FreeSteamLib), Float64, (SteamState, ), S)
  end
end

#all 39 double functions (double,double) exported
const z_for_xy = [:freesteam_region4_v_Tx,    :freesteam_region4_u_Tx,    :freesteam_region4_h_Tx,   :freesteam_region4_s_Tx,   :freesteam_region4_cp_Tx,
                  :freesteam_region4_cv_Tx,   :freesteam_region3_p_rhoT,  :freesteam_region3_u_rhoT, :freesteam_region3_s_rhoT, :freesteam_region3_h_rhoT,
                  :freesteam_region3_cp_rhoT, :freesteam_region3_cv_rhoT, :freesteam_region3_w_rhoT, :freesteam_region3_T_ph,   :freesteam_region3_v_ph,
                  :freesteam_region3_T_ps,    :freesteam_region3_v_ps,    :freesteam_region2_v_pT,   :freesteam_region2_u_pT,   :freesteam_region2_s_pT,
                  :freesteam_region2_h_pT,    :freesteam_region2_cp_pT,   :freesteam_region2_cv_pT,  :freesteam_region2_w_pT,   :freesteam_region2_a_pT,
                  :freesteam_region2_g_pT,    :freesteam_region2_T_ph,    :freesteam_region1_u_pT,   :freesteam_region1_v_pT,   :freesteam_region1_s_pT,
                  :freesteam_region1_h_pT,    :freesteam_region1_cp_pT,   :freesteam_region1_cv_pT,  :freesteam_region1_w_pT,   :freesteam_region1_a_pT,
                  :freesteam_region1_T_ph,    :freesteam_k_rhoT,          :freesteam_mu_rhoT,        :freesteam_region1_g_pT]
@eval export($(z_for_xy...))
for f in z_for_xy
  @eval function $f(x::Float64, y::Float64)
    return ccall( ($(QuoteNode(f)), FreeSteamLib), Float64, (Float64, Float64), x, y)
  end
end

#all 8 double functions (char,SteamState) exported
const d_for_cS = [:freesteam_region3_dAdvT, :freesteam_region3_dAdTv, :freesteam_region1_dAdTp, :freesteam_region1_dAdpT,
                   :freesteam_region2_dAdTp, :freesteam_region2_dAdpT, :freesteam_region4_dAdTx, :freesteam_region4_dAdxT]
@eval export($(d_for_cS...))
for f in d_for_cS
  @eval function $f(i::Char, S::SteamState)
    return ccall( ($(QuoteNode(f)), FreeSteamLib), Float64, (Char, SteamState), c, S)
  end
end

#1 double function (SteamState,xyz) exported
export freesteam_deriv
function freesteam_deriv(S::SteamState, xyz::XYZ)
  return ccall( (:freesteam_deriv, FreeSteamLib), Float64, (SteamState, XYZ), S, xyz)
end

#all 12 double functions (double) exported
const _x = [:freesteam_region4_Tsat_p, :freesteam_region4_rhof_T, :freesteam_region4_psat_T, :freesteam_region4_rhog_T, :freesteam_region4_dpsatdT_T,
             :freesteam_b23_p_T,        :freesteam_b23_T_p,        :freesteam_region3_psat_h, :freesteam_region3_psat_s, :freesteam_drhofdT_T,
             :freesteam_drhogdT_T,      :freesteam_surftens_T]
@eval export($(_x...))
for f in _x
  @eval function $f(x::Float64)
    return ccall( ($(QuoteNode(f)), FreeSteamLib), Float64, (Float64,), x)
  end
end

#1 SteamState function (double) exported
export freesteam_bound_pmax_T
function freesteam_bound_pmax_T(x::Float64)
  return ccall( (:freesteam_bound_pmax_T, FreeSteamLib), SteamState, (Float64, ), x)
end

#all 6 int functions (double,double,int) exported
const i_for_xyi = [:freesteam_bounds_ph, :freesteam_bounds_ps, :freesteam_bounds_pv, :freesteam_bounds_Ts, :freesteam_bounds_Tx, :freesteam_bounds_uv]
@eval export($(i_for_xyi...))
for f in i_for_xyi
  @eval function $f(x::Float64, y::Float64, i::Cint)
    return ccall( ($(QuoteNode(f)), FreeSteamLib), Cint, (Float64, Float64, Cint), x, y, i)
  end
end

#all 7 int functions (double,double) exported
const i_for_xy = [:freesteam_region_ph, :freesteam_region_ps, :freesteam_region_pu, :freesteam_region_pv, :freesteam_region_Ts, :freesteam_region_Tx, :freesteam_region_uv]
@eval export($(i_for_xy...))
for f in i_for_xy
  @eval function $f(x::Float64, y::Float64)
    return ccall( ($(QuoteNode(f)), FreeSteamLib), Cint, (Float64, Float64), x, y)
  end
end

#1 int function (SteamState) exported
export freesteam_region
function freesteam_region(S::SteamState)
  return ccall( (:freesteam_region, FreeSteamLib), Cint, (SteamState, ), S)
end

@windows_only const FreeSteamLib = abspath(joinpath(@__FILE__,"..","..","lib","freesteam.dll"));
@linux_only const FreeSteamLib = abspath(joinpath(@__FILE__,"..","..","lib","libfreesteam.so"));

end #module
