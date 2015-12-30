using CoolProp
using FreeSteam

const eps = 1e-8

@osx? println("no osx support") : begin
#CoolProp
@test_approx_eq 373.1242958476879 PropsSI("T","P",101325.0,"Q",0.0,"Water")

#freesteam

libpath = abspath(joinpath(@__FILE__,"..","..","lib"))
@linux_only gsl = Libdl.dlopen(joinpath(libpath, "libgsl.so"))
@linux_only gslcblas = Libdl.dlopen(joinpath(libpath, "libgslcblas.so"))

function test_region1_point(T::Float64 ,p::Float64 ,v::Float64 ,h::Float64 ,u::Float64 ,s::Float64 ,cp::Float64 ,w::Float64)

  #=
    Note: inputs to this function need units conversion!
      Temperature temp;    ///< K
      Pressure pres;       ///< MPa
      SpecificVolume v;    ///< m³/kg
      SpecificEnergy h;    ///< enthalpy / kJ/kg
      SpecificEnergy u;    ///< internal energy / kJ/kg
      SpecificEntropy s;   ///< kJ/kg.K
      SpecHeatCap cp;      ///< specific heat capacity at constant pressure
      Velocity w;          ///< speed of sound
  =#
  
	S = freesteam_region1_set_pT(p*1e6, T);
	@test_approx_eq_eps freesteam_p(S)  p*1e6     eps*p*1e6
	@test_approx_eq_eps freesteam_T(S)  T         eps*T
	@test_approx_eq_eps freesteam_v(S)  v         eps*v
	@test_approx_eq_eps freesteam_h(S)  h*1e3     eps*h*1e3
	@test_approx_eq_eps freesteam_u(S)  u*1e3     eps*u*1e3
	@test_approx_eq_eps freesteam_s(S)  s*1e3     eps*s*1e3 
	@test_approx_eq_eps freesteam_cp(S) cp*1e3    eps*cp*1e3 
	@test_approx_eq_eps freesteam_w(S)  w         eps*w

end

function testregion1()
	println("REGION 1 TESTS")
	test_region1_point(300., 3., 0.100215168E-2, 0.115331273E3, 0.112324818E3, 0.392294792, 0.417301218E1, 0.150773921E4)
	test_region1_point(300., 80., 0.971180894E-3, 0.184142828E3, 0.106448356E3, 0.368563852, 0.401008987E1, 0.163469054E4)
	test_region1_point(500., 3., 0.120241800E-2, 0.975542239E3, 0.971934985E3, 0.258041912E1, 0.465580682E1, 0.124071337E4)
end

function test_region2_point(T::Float64 ,p::Float64 ,v::Float64 ,h::Float64 ,u::Float64 ,s::Float64 ,cp::Float64 ,w::Float64)

	# units of measurement as for region1 test 

	S = freesteam_region2_set_pT(p*1e6, T);
	@test_approx_eq_eps freesteam_p(S)  p*1e6     eps*p*1e6
	@test_approx_eq_eps freesteam_T(S)  T         eps*T
	@test_approx_eq_eps freesteam_v(S)  v         eps*v
	@test_approx_eq_eps freesteam_h(S)  h*1e3     eps*h*1e3
	@test_approx_eq_eps freesteam_u(S)  u*1e3     eps*u*1e3
	@test_approx_eq_eps freesteam_s(S)  s*1e3     eps*s*1e3 
	@test_approx_eq_eps freesteam_cp(S) cp*1e3    eps*cp*1e3 
	@test_approx_eq_eps freesteam_w(S)  w         eps*w
  
end

function testregion2()
	println("REGION 2 TESTS")
	test_region2_point(300., 0.0035, 0.394913866E2, 0.254991145E4, 0.241169160E4, 0.852238967E1, 0.191300162E1, 0.427920172E3)
	test_region2_point(700., 0.0035, 0.923015898E2, 0.333568375E4, 0.301262819E4, 0.101749996E2, 0.208141274E1, 0.644289068E3)
	test_region2_point(700., 30., 0.542946619E-02, 0.263149474E+4, 0.246861076E+4, 0.517540298E+1, 0.103505092E+2, 0.480386523E+3)
end

function test_region3_point(T::Float64 ,rho::Float64 ,p::Float64 ,h::Float64 ,u::Float64 ,s::Float64 ,cp::Float64 ,w::Float64)

	# units of measurement as for region1 test 

	S = freesteam_region3_set_rhoT(rho, T)
	@test_approx_eq_eps freesteam_p(S)  p*1e6     eps*p*1e6
	@test_approx_eq_eps freesteam_T(S)  T         eps*T
	@test_approx_eq_eps freesteam_v(S)  1./rho    eps*1./rho 
	@test_approx_eq_eps freesteam_h(S)  h*1e3     eps*h*1e3
	@test_approx_eq_eps freesteam_u(S)  u*1e3     eps*u*1e3
	@test_approx_eq_eps freesteam_s(S)  s*1e3     eps*s*1e3 
	@test_approx_eq_eps freesteam_cp(S) cp*1e3    eps*cp*1e3 
	@test_approx_eq_eps freesteam_w(S)  w         eps*w
  
end

function testregion3()
	println("REGION 3 TESTS")
	test_region3_point(650., 500., 0.255837018E2, 0.186343019E4, 0.181226279E4, 0.405427273E1,0.138935717E2, 0.502005554E3)
	test_region3_point(650., 200., 0.222930643E2, 0.237512401E4, 0.226365868E4, 0.485438792E1, 0.446579342E2, 0.383444594E3)
	test_region3_point(750., 500., 0.783095639E2, 0.225868845E4, 0.210206932E4, 0.446971906E1, 0.634165359E1, 0.760696041E3);
end

# --- REGION 4 SATURATION LINE

function test_region4_point(T::Float64 ,p::Float64)
	S = freesteam_region4_set_Tx(T,0.)
	p1 = freesteam_p(S)
	@test_approx_eq_eps p1  p*1e6 eps*p*1e6
	T1 = freesteam_region4_Tsat_p(p1)
	@test_approx_eq_eps T1  T eps*T
end

function testregion4()
	println("REGION 4 TESTS")
	test_region4_point(300.,	0.353658941E-2)
	test_region4_point(500.,	0.263889776E1)
	test_region4_point(600.,	0.123443146E2)
end

# --- REGION 1 BACKWARDS (P,H)

function test_region1_ph_point(p::Float64, h::Float64, T::Float64)
	T1 = freesteam_region1_T_ph(p*1e6,h*1e3)
	@test_approx_eq_eps T1 T T/eps
end

function testregion1ph()
	println("REGION 1 (P,H)")
	test_region1_ph_point(3.,	500.,	0.391798509e3)
	test_region1_ph_point(80.,	500.,	0.378108626e3)
	test_region1_ph_point(80.,	1500.,	0.611041229e3)
end

testregion1()
testregion2()
testregion3()
testregion4()
testregion1ph()

T = 400. # in Kelvin! 
p = 1e5  # 1 bar
ss = freesteam_set_pT(p, T) 
s = freesteam_s(ss);
@test_approx_eq 7502.40089208754 s # J/kgK
ss2 = freesteam_set_ps(p*10, s)
T2 = freesteam_T(ss2)
@test_approx_eq 684.5051229099 T2
p2 = freesteam_p(ss2)
@test_approx_eq 7502.40089208754 freesteam_s(ss2) # J/kgK

@linux_only Libdl.dlclose(gsl)
@linux_only Libdl.dlclose(gslcblas)

end