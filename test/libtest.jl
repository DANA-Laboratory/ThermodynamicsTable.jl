using CoolProp
using FreeSteam
@osx? println("no osx support") : begin
  #CoolProp
  @test_approx_eq 373.1242958476879 PropsSI("T","P",101325.0,"Q",0.0,"Water")

  #freesteam

  libpath = abspath(joinpath(@__FILE__,"..","..","lib"))
  @linux_only gsl = Libdl.dlopen(joinpath(libpath, "libgsl.so"))
  @linux_only gslcblas = Libdl.dlopen(joinpath(libpath, "libgslcblas.so"))

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

#=

/*
freesteam - IAPWS-IF97 steam tables library
Copyright (C) 2004-2009  John Pye

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*/

#include "steam.h"
#include "region4.h"
#include "backwards.h"
#include "b23.h"
#include "derivs.h"
#include "zeroin.h"
#include "region3.h"
#include "solver2.h"
#include "steam_ph.h"
#include "steam_ps.h"
#include "steam_Ts.h"
#include "steam_pT.h"
#include "steam_pv.h"
#include "steam_Tx.h"
#include "region1.h"
#include "viscosity.h"
#include "thcond.h"
#include "surftens.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>

int errorflag = 0;
double maxrelerr = 0;
int verbose = 0;

#define CHECK_VAL(EXPR, VAL, RELTOL){ \
	double calc = (EXPR); \
	double error = calc - (VAL);\
	double relerr;\
	relerr = (VAL==0) ? error : error / (VAL);\
	if(fabs(relerr)>maxrelerr)maxrelerr=fabs(relerr);\
	if(fabs(relerr) > RELTOL){\
		fprintf(stderr,"ERROR (%s:%d): %s = %e, should be %e, error %10e %% exceeds tol %10e %%\n",\
			__FILE__,__LINE__,#EXPR, calc, (VAL), relerr*100., RELTOL*100.\
		);\
		/*exit(1);*/\
		errorflag = 1; \
	 }else if(verbose){ \
		fprintf(stderr,"OK: %s = %f with %e %% error (test value = %f).\n", #EXPR, calc, error/(VAL)*100,(VAL)); \
	} \
}

#define CHECK_INT(EXPR, VAL){ \
	int calc = (EXPR); \
	if(calc != (VAL)){\
		fprintf(stderr,"ERROR (%s:%d): %s = %d, should be %d!\n",\
			__FILE__,__LINE__,#EXPR, calc, (VAL));\
		errorflag = 1; \
	 }else if(verbose){ \
		fprintf(stderr,"OK: %s = %d\n", #EXPR, (VAL)); \
	} \
}

/*------------------------------------------------------------------------------
  REGION 1: FORWARDS
*/

#define RELTOL 5e-9

void test_region1_point(double T,double p, double v,double h,double u, double s, double cp, double w){

/*
	Note: inputs to this function need units conversion!
		Temperature temp;    ///< K
		Pressure pres;       ///< MPa
		SpecificVolume v;    ///< m³/kg
		SpecificEnergy h;    ///< enthalpy / kJ/kg
		SpecificEnergy u;    ///< internal energy / kJ/kg
		SpecificEntropy s;   ///< kJ/kg.K
		SpecHeatCap cp;      ///< specific heat capacity at constant pressure
		Velocity w;          ///< speed of sound
*/

	SteamState S = freesteam_region1_set_pT(p*1e6, T);
	CHECK_VAL(freesteam_p(S),p*1e6,RELTOL);
	CHECK_VAL(freesteam_T(S),T,RELTOL);
	CHECK_VAL(freesteam_v(S),v,RELTOL);
	CHECK_VAL(freesteam_h(S),h*1e3,RELTOL);
	CHECK_VAL(freesteam_u(S),u*1e3,RELTOL);
	CHECK_VAL(freesteam_s(S),s*1e3,RELTOL);
	CHECK_VAL(freesteam_cp(S),cp*1e3,RELTOL);
	CHECK_VAL(freesteam_w(S),w,RELTOL);

}

void testregion1(void){
	fprintf(stderr,"REGION 1 TESTS\n");
	test_region1_point(300., 3., 0.100215168E-2, 0.115331273E3, 0.112324818E3, 0.392294792, 0.417301218E1, 0.150773921E4);
	test_region1_point(300., 80., 0.971180894E-3, 0.184142828E3, 0.106448356E3, 0.368563852, 0.401008987E1, 0.163469054E4);
	test_region1_point(500., 3., 0.120241800E-2, 0.975542239E3, 0.971934985E3, 0.258041912E1, 0.465580682E1, 0.124071337E4);
}

/*------------------------------------------------------------------------------
  REGION 2: FORWARDS
*/

void test_region2_point(double T,double p, double v,double h,double u, double s, double cp, double w){

	/* units of measurement as for region1 test */

	SteamState S = freesteam_region2_set_pT(p*1e6, T);
	CHECK_VAL(freesteam_p(S),p*1e6,RELTOL);
	CHECK_VAL(freesteam_T(S),T,RELTOL);
	CHECK_VAL(freesteam_v(S),v,RELTOL);
	CHECK_VAL(freesteam_h(S),h*1e3,RELTOL);
	CHECK_VAL(freesteam_u(S),u*1e3,RELTOL);
	CHECK_VAL(freesteam_s(S),s*1e3,RELTOL);
	CHECK_VAL(freesteam_cp(S),cp*1e3,RELTOL);
	CHECK_VAL(freesteam_w(S),w,RELTOL);
}

void testregion2(void){
	fprintf(stderr,"REGION 2 TESTS\n");
	test_region2_point(300., 0.0035, 0.394913866E2, 0.254991145E4, 0.241169160E4, 0.852238967E1, 0.191300162E1, 0.427920172E3);
	test_region2_point(700., 0.0035, 0.923015898E2, 0.333568375E4, 0.301262819E4, 0.101749996E2, 0.208141274E1, 0.644289068E3);
	test_region2_point(700., 30., 0.542946619E-02, 0.263149474E+4, 0.246861076E+4, 0.517540298E+1, 0.103505092E+2, 0.480386523E+3);
}

/*------------------------------------------------------------------------------
  REGION 3: FORWARDS
*/

void test_region3_point(double T,double rho, double p,double h,double u, double s, double cp, double w){

	/* units of measurement as for region1 test */

	SteamState S = freesteam_region3_set_rhoT(rho, T);
	CHECK_VAL(freesteam_p(S),p*1e6,RELTOL);
	CHECK_VAL(freesteam_T(S),T,RELTOL);
	CHECK_VAL(freesteam_v(S),1./rho,RELTOL);
	CHECK_VAL(freesteam_h(S),h*1e3,RELTOL);
	CHECK_VAL(freesteam_u(S),u*1e3,RELTOL);
	CHECK_VAL(freesteam_s(S),s*1e3,RELTOL);
	CHECK_VAL(freesteam_cp(S),cp*1e3,RELTOL);
	CHECK_VAL(freesteam_w(S),w,RELTOL);
}

void testregion3(void){
	fprintf(stderr,"REGION 3 TESTS\n");

	test_region3_point(650., 500., 0.255837018E2,
			           0.186343019E4, 0.181226279E4, 0.405427273E1,
			           0.138935717E2, 0.502005554E3);

	test_region3_point(650., 200., 0.222930643E2,
			           0.237512401E4, 0.226365868E4, 0.485438792E1,
			           0.446579342E2, 0.383444594E3);

	test_region3_point(750., 500., 0.783095639E2, 0.225868845E4,
			           0.210206932E4, 0.446971906E1, 0.634165359E1,
			           0.760696041E3);
}

/*------------------------------------------------------------------------------
  REGION 4 SATURATION LINE
*/

void test_region4_point(double T,double p){
	SteamState S = freesteam_region4_set_Tx(T,0.);
	double p1 = freesteam_p(S);
	CHECK_VAL(p1,p*1e6,RELTOL);
	double T1 = freesteam_region4_Tsat_p(p1);
	CHECK_VAL(T1,T,RELTOL);
}

void testregion4(void){
	fprintf(stderr,"REGION 4 TESTS\n");
	test_region4_point(300.,	0.353658941E-2);
	test_region4_point(500.,	0.263889776E1);
	test_region4_point(600.,	0.123443146E2);
}

/*------------------------------------------------------------------------------
  REGION 1 BACKWARDS (P,H)
*/

void test_region1_ph_point(double p,double h, double T){
	double T1 = freesteam_region1_T_ph(p*1e6,h*1e3);
	CHECK_VAL(T1,T,RELTOL);
}

void testregion1ph(void){
	fprintf(stderr,"REGION 1 (P,H) TESTS\n");
	test_region1_ph_point(3.,	500.,	0.391798509e3);
	test_region1_ph_point(80.,	500.,	0.378108626e3);
	test_region1_ph_point(80.,	1500.,	0.611041229e3);
}

#if 0
void test_region1_ps_point(double p,double s, double T){
	double T1 = freesteam_region1_T_ps(p*1e6,s*1e3);
	CHECK_VAL(T1,T,RELTOL);
}

void testregion1ps(void){
	fprintf(stderr,"REGION 1 (P,S) TESTS\n");
	test_region1_ps_point(3.,	0.5.,  0.307842258e3);
	test_region1_ps_point(80.,	0.5.,  0.309979785e3);
	test_region1_ps_point(80.,	3.,    0.565899909E3);
}
#endif


/*------------------------------------------------------------------------------
  REGION 2 BACKWARDS (P,H)
*/

void test_region2_ph_point(double p,double h, double T){
	double T1 = freesteam_region2_T_ph(p*1e6,h*1e3);
	CHECK_VAL(T1,T,RELTOL);
}

void testregion2ph(void){
	fprintf(stderr,"REGION 2 (P,H) TESTS\n");
	test_region2_ph_point(0.001,3000.,	0.534433241e3);
	test_region2_ph_point(3.,	3000.,	0.575373370e3);
	test_region2_ph_point(3.,	4000.,	0.101077577e4);

	test_region2_ph_point(5.,	3500.,	0.801299102e3);
	test_region2_ph_point(5.,	4000.,	0.101531583e4);
	test_region2_ph_point(25.,	3500.,	0.875279054e3);

	test_region2_ph_point(40.,	2700.,	0.743056411e3);
	test_region2_ph_point(60., 	2700.,	0.791137067e3);
	test_region2_ph_point(60.,	3200.,	0.882756860e3);
}

/*------------------------------------------------------------------------------
  REGION 3 BACKWARDS (P,H)
*/

void test_region3_ph_point(double p,double h, double T, double v){
	double T1 = freesteam_region3_T_ph(p*1e6,h*1e3);
	CHECK_VAL(T1,T,RELTOL);
	double v1 = freesteam_region3_v_ph(p*1e6,h*1e3);
	CHECK_VAL(v1,v,RELTOL);
}

void testregion3ph(void){
	fprintf(stderr,"REGION 3 (P,H) TESTS\n");
	test_region3_ph_point(20.,	1700.,	6.293083892e2, 1.749903962e-3);
	test_region3_ph_point(50.,	2000.,	6.905718338e2, 1.908139035e-3);
	test_region3_ph_point(100.,	2100.,	7.336163014e2, 1.676229776e-3);

	test_region3_ph_point(20.,	2500.,	6.418418053e2, 6.670547043e-3);
	test_region3_ph_point(50.,	2400.,	7.351848618e2, 2.801244590e-3);
	test_region3_ph_point(100.,	2700.,	8.420460876e2, 2.404234998e-3);
}

/*------------------------------------------------------------------------------
  REGION 3 PSAT(H)
*/

void test_region3_psath_point(double h,double p){
	double p1 = freesteam_region3_psat_h(h*1e3);
	CHECK_VAL(p1,p*1e6,RELTOL);
}

void testregion3psath(void){
	fprintf(stderr,"REGION 3 PSAT(H) TESTS\n");
	test_region3_psath_point(1700., 1.724175718e1);
	test_region3_psath_point(2000., 2.193442957e1);
	test_region3_psath_point(2400., 2.018090839e1);
}

/*------------------------------------------------------------------------------
  REGION 3 PSAT(S)
*/

void test_region3_psats_point(double s,double p){
	double p1 = freesteam_region3_psat_s(s*1e3);
	CHECK_VAL(p1,p*1e6,RELTOL);
}

void testregion3psats(void){
	fprintf(stderr,"REGION 3 PSAT(S) TESTS\n");
	test_region3_psats_point(3.8, 1.687755057e1);
	test_region3_psats_point(4.2, 2.164451789e1);
	test_region3_psats_point(5.2, 1.668968482e1);
}

/*------------------------------------------------------------------------------
  REGION 2-3 BOUNDARY
*/

void testb23(){
	double T = 623.15;
	double p = 0.165291643e8;
	fprintf(stderr,"REGION 2-3 BOUNDARY TESTS\n");
	double p1 = freesteam_b23_p_T(T);
	CHECK_VAL(p1,p,RELTOL);
	double T1 = freesteam_b23_T_p(p);
	CHECK_VAL(T1,T,RELTOL);
}

/*------------------------------------------------------------------------------
  FULL (P,H) ROUTINES
*/

/* #define PHRELTOL 6e-5 ---region 2 */
#define PHRELTOL 1e-3 /* region 1 */

void test_steam_ph(double p,double h){
	//fprintf(stderr,"------------\n");
	//fprintf(stderr,"p = %f MPa, h = %f kJ/kg\n",p, h);
	SteamState S = freesteam_set_ph(p*1e6,h*1e3);
	//if(S.region !=1)return;
	//fprintf(stderr,"--> region = %d\n", S.region);
	CHECK_VAL(freesteam_p(S),p*1e6,PHRELTOL);
	CHECK_VAL(freesteam_h(S),h*1e3,PHRELTOL);

};

void testph(void){
	const double pp[] = {0.001, 0.0035, 0.01, 0.1, 1, 2, 5, 10, 20, 22, 22.06, 22.064, 22.07, 23, 25, 30, 40, 50, 80, 90, 100};
	const int np = sizeof(pp)/sizeof(double);
	const double hh[] = {100, 300, 400, 450, 500, 800, 1000, 1500, 2000, 2107, 2108, 2109, 2500, 2600, 2650, 2700, 2800, 2900, 3000};
	const int nh = sizeof(hh)/sizeof(double);
	const double *p, *h;

	fprintf(stderr,"FULL (P,H) TESTS\n");
	for(p=pp; p<pp+np; ++p){
		for(h=hh; h<hh+nh; ++h){
			if(freesteam_bounds_ph(*p*1e6, *h*1e3, 0))continue;
			if(freesteam_region_ph(*p*1e6, *h*1e3)!=3)continue;
			test_steam_ph(*p,*h);
		}
	}
}

/*------------------------------------------------------------------------------
  PROPERTY EVALULATION WITHIN REGION 4
*/

#define R4RELTOL 4.3e-4

typedef struct R4TestProps_struct{
	double T, p, rhof, rhog, hf, hg, sf, sg;
} R4TestProps;

/**
	Test data from IAPWS95 for the saturation region. We should conform to this
	with reasonable accuracy.
*/
const R4TestProps r4testprops_data[] = {
	{275.,	0.698451167e-3,	0.999887406e3,	0.550664919e-2,	0.775972202e1,	0.250428995e4,	0.283094670e-1,	0.910660121e1}
	,{450.,	0.932203564,	0.890341250e3,	0.481200360e1,	0.749161585e3,	0.277441078e4,	0.210865845e1,	0.660921221e1}
	,{625.,	0.169082693e2,	0.567090385e3,	0.118290280e3,	0.168626976e4,	0.255071625e4,	0.380194683e1,	0.518506121e1}
};

const int r4testprops_max = sizeof(r4testprops_data)/sizeof(R4TestProps);

void test_steam_region4_props(const R4TestProps *P){
	SteamState S;
	S = freesteam_region4_set_Tx(P->T, 0.);
	CHECK_VAL(freesteam_p(S),P->p*1e6,R4RELTOL);
	CHECK_VAL(freesteam_v(S),1./P->rhof,R4RELTOL);
	CHECK_VAL(freesteam_h(S),P->hf*1e3,R4RELTOL);
	CHECK_VAL(freesteam_s(S),P->sf*1e3,R4RELTOL);
	S = freesteam_region4_set_Tx(P->T, 1.);
	CHECK_VAL(freesteam_p(S),P->p*1e6,R4RELTOL);
	CHECK_VAL(freesteam_v(S),1./P->rhog,R4RELTOL);
	CHECK_VAL(freesteam_h(S),P->hg*1e3,R4RELTOL);
	CHECK_VAL(freesteam_s(S),P->sg*1e3,R4RELTOL);
};

void testregion4props(void){
	int i;
	fprintf(stderr,"REGION 4 PROPERTY EVALUATION TESTS\n");
	for(i=0; i< r4testprops_max; ++i){
		test_steam_region4_props(&r4testprops_data[i]);
	}
}

/*------------------------------------------------------------------------------
  DERIVATIVE ROUTINES
*/

void test_ph_derivs(double p, double h){
	SteamState S;
	S = freesteam_set_ph(p,h);
	freesteam_fprint(stderr,S);

#if 1
	if(S.region!=3)return;
	double dp = 1.;
	SteamState Sdp;
	switch(S.region){
		case 1: Sdp = freesteam_region1_set_pT(p+dp,freesteam_region1_T_ph(p+dp,h)); break;
		case 2: Sdp = freesteam_region2_set_pT(p+dp,freesteam_region2_T_ph(p+dp,h)); break;
		case 3: Sdp = freesteam_region3_set_rhoT(1./freesteam_region3_v_ph(p+dp,h),freesteam_region3_T_ph(p+dp,h)); break;
		case 4: 
			{
				double T1 = freesteam_region4_Tsat_p(p+dp);
				double hf = freesteam_region4_h_Tx(T1,0.);
				double hg = freesteam_region4_h_Tx(T1,1.);
				double x1 = (h - hf)/(hg - hg);
				Sdp = freesteam_region4_set_Tx(T1,x1);
			}
			break;
	}
	//fprintf(stderr,"S(p+dp = %g, h = %g) = ",p+dp,h);
	//freesteam_fprint(stderr,Sdp);

	double dvdp_h_fdiff = (freesteam_v(Sdp) - freesteam_v(S))/dp;
	double dvdp_h = freesteam_deriv(S,"vph");
	CHECK_VAL(dvdp_h,dvdp_h_fdiff,1e-3);
#endif

	double dh = 1.;
	SteamState Sdh;
	switch(S.region){
		case 1: Sdh = freesteam_region1_set_pT(p,freesteam_region1_T_ph(p,h+dh)); break;
		case 2: Sdh = freesteam_region2_set_pT(p,freesteam_region2_T_ph(p,h+dh)); break;
		case 3: Sdh = freesteam_region3_set_rhoT(1./freesteam_region3_v_ph(p,h+dh),freesteam_region3_T_ph(p,h+dh)); break;
		case 4: 
			{
				double hf = freesteam_region4_h_Tx(S.R4.T,0.);
				double hg = freesteam_region4_h_Tx(S.R4.T,1.);
				double x1 = ((h+dh) - hf)/(hg - hg);
				Sdh = freesteam_region4_set_Tx(S.R4.T,x1);
			}
	}

	//fprintf(stderr,"S(p+dp = %g, h = %g) = ",p+dp,h);
	//freesteam_fprint(stderr,Sdp);

	double dvdh_p_fdiff = (freesteam_v(Sdh) - freesteam_v(S))/dh;
	
	double dvdh_p = freesteam_deriv(S,"vhp");

	CHECK_VAL(dvdh_p,dvdh_p_fdiff,1e-3);


}

void testderivs(void){
	const double pp[] = {0.001, 0.0035, 0.01, 0.1, 1, 2, 5, 10, 20, 22, 22.06 , 22.064, 22.07, 23, 25, 30, 40, 50, 80, 90, 100};
	const int np = sizeof(pp)/sizeof(double);
	const double hh[] = {100, 300, 400, 450, 500, 800, 1000/*, 1500, 2000, 2107, 2108, 2109, 2200 2500, 2600, 2650, 2700, 2800, 2900, 3000*/};
	const int nh = sizeof(hh)/sizeof(double);
	const double *p, *h;
	
	fprintf(stderr,"DERIVATIVE ROUTINE TESTS\n");
	for(p=pp; p<pp+np; ++p){
		for(h=hh; h<hh+nh; ++h){
			test_ph_derivs((*p)*1e6,(*h)*4e3);
		}
	}
}

/*------------------------------------------------------------------------------
  ZEROIN TEST
*/

typedef struct{
	double a,b,c;
} TestQuadratic;

double test_zeroin_subject(double x, void *user_data){
#define Q ((TestQuadratic *)user_data)
	double res = Q->a*x*x + Q->b*x + Q->c;
	//fprintf(stderr,"f(x = %f) = %f x² + %f x + %f = %f\n",x,Q->a,Q->b, Q->c,res);
	return res;
#undef Q
}

void testzeroin(void){
	TestQuadratic Q1 = {1, 0, -4};
	fprintf(stderr,"BRENT SOLVER TESTS\n");
	double sol = 0, err = 0;
	zeroin_solve(&test_zeroin_subject,&Q1, -10., 4.566, 1e-10, &sol, &err);
	CHECK_VAL(sol,2.,1e-10);
}

/*------------------------------------------------------------------------------
  SOLVER2 TESTS
*/

void testsolver2(void){
	fprintf(stderr,"SOLVER2 TESTS\n");
	SteamState S;

	/* test in region 3 */
	S = freesteam_region3_set_rhoT(IAPWS97_RHOCRIT, IAPWS97_TCRIT + 50.);
	assert(S.region==3);
	double p = freesteam_p(S);
	double h = freesteam_h(S);
	int status;
	SteamState S2;
	fprintf(stderr,"Solving for p = %g MPa, h = %g kJ/kgK (rho = %g, T = %g)\n",p/1e6, h/1e3,S.R3.rho, S.R3.T);
	SteamState guess = freesteam_region3_set_rhoT(1./0.00317, 673.15);	
	S2 = freesteam_solver2_region3('p','h',p,h,guess,&status);
	assert(status==0);
	CHECK_VAL(freesteam_p(S2),p, 1e-7);
	CHECK_VAL(freesteam_h(S2),h, 1e-7);

	/* test in region 4 */
	S = freesteam_region4_set_Tx(440., 0.9);
	p = freesteam_p(S);
	h = freesteam_h(S);
	fprintf(stderr,"Solving for p = %g MPa, h = %g kJ/kgK (region 4: T = %g, x = %g)\n",p/1e6, h/1e3,S.R4.T, S.R4.x);
	guess = freesteam_region4_set_Tx(IAPWS97_TCRIT - 1.,0.5);
	S2 = freesteam_solver2_region4('p','h',p,h,guess,&status);
	assert(status==0);
	CHECK_VAL(freesteam_p(S2),p, 1e-7);
	CHECK_VAL(freesteam_h(S2),h, 1e-7);

	/* test in region 2 */
	S = freesteam_region2_set_pT(1e5, 273.15+180.);
	p = freesteam_p(S);
	h = freesteam_h(S);
	fprintf(stderr,"Solving for p = %g MPa, h = %g kJ/kgK (region 2: p = %g, T = %g)\n",p/1e6, h/1e3,S.R2.p, S.R2.T);
	guess = freesteam_region2_set_pT(200e5,273.15+500.);
	S2 = freesteam_solver2_region2('p','h',p,h,guess,&status);
	assert(status==0);
	CHECK_VAL(freesteam_p(S2),p, 1e-7);
	CHECK_VAL(freesteam_h(S2),h, 1e-7);

	/* test in region 1 */
	S = freesteam_region1_set_pT(1e5, 273.15+40.);
	p = freesteam_p(S);
	h = freesteam_h(S);
	fprintf(stderr,"Solving for p = %g MPa, h = %g kJ/kgK (region 1: p = %g, T = %g)\n",p/1e6, h/1e3,S.R1.p, S.R1.T);
	guess = freesteam_region1_set_pT(200e5,273.15+20.);
	S2 = freesteam_solver2_region1('p','h',p,h,guess,&status);
	assert(status==0);
	CHECK_VAL(freesteam_p(S2),p, 1e-7);
	CHECK_VAL(freesteam_h(S2),h, 1e-7);
}


/*------------------------------------------------------------------------------
  FULL (P,T) ROUTINES
*/

void test_point_pT(double p, double T){
	SteamState S = freesteam_set_pT(p,T);
	//fprintf(stderr,"region = %d\n",S.region);
	CHECK_VAL(freesteam_p(S),p,1e-7);
	CHECK_VAL(freesteam_T(S),T,1e-7);
}

void testpT(void){
	int np = 100, nT = 100;
	double p,T, dp = (IAPWS97_PMAX - 0.)/np, dT = (IAPWS97_TMAX - IAPWS97_TMIN)/nT;
	fprintf(stderr,"FULL (P,T) TESTS\n");
	for(p = 0.; p <= IAPWS97_PMAX; p += dp){
		for(T = IAPWS97_TMIN; T <= IAPWS97_TMAX; T += dT){
			test_point_pT(p,T);
		}
	}
}

/*------------------------------------------------------------------------------
  REGION 3 (p,s) TEST DATA
*/

void test_region3_ps_point(double p,double s, double T, double v){
	double T1 = freesteam_region3_T_ps(p*1e6,s*1e3);
	CHECK_VAL(T1,T,RELTOL);
	double v1 = freesteam_region3_v_ps(p*1e6,s*1e3);
	CHECK_VAL(v1,v,RELTOL);

	//SteamState S = freesteam_set_ps(p*1e6,s*1e3);
	//CHECK_VAL(freesteam_p(S)/1e6,p,RELTOL);
	//CHECK_VAL(freesteam_s(S)/1e3,s,RELTOL);
}

void testregion3ps(void){
	fprintf(stderr,"REGION 3 (P,S) TESTS\n");
	test_region3_ps_point(20.,	3.8,	6.282959869e2, 1.733791463e-3);
	test_region3_ps_point(50.,	3.6,	6.297158726e2, 1.469680170e-3);
	test_region3_ps_point(100.,	4.0,	7.056880237e2, 1.555893131e-3);

	test_region3_ps_point(20.,	5.0,	6.401176443e2, 6.262101987e-3);
	test_region3_ps_point(50.,	4.5,	7.163687517e2, 2.332634294e-3);
	test_region3_ps_point(100.,	5.0,	8.474332825e2, 2.449610757e-3);
}	

/*------------------------------------------------------------------------------
  FULL (P,S) ROUTINES
*/

/* #define PHRELTOL 6e-5 ---region 2 */
#define PHRELTOL 1e-3 /* region 1 */

void test_steam_ps(double p,double s){
	//fprintf(stderr,"------------\n");
	//fprintf(stderr,"%s: p = %f MPa, s = %f kJ/kgK\n",__func__, p, s);
	freesteam_bounds_ps(p*1e6,s*1e3,1);
	SteamState S = freesteam_set_ps(p*1e6,s*1e3);
	//if(S.region !=1)return;
	//fprintf(stderr,"--> region = %d\n", S.region);
	//if(S.region==4)fprintf(stderr,"--> p = %g\n", freesteam_region4_psat_T(S.R4.T));
	CHECK_VAL(freesteam_p(S),p*1e6,PHRELTOL);
	CHECK_VAL(freesteam_s(S),s*1e3,PHRELTOL);

};

void testps(void){
	const double pp[] = {0.001, 0.0035, 0.01, 0.1, 1, 2, 3, 5, 10, 17, 18, 20, 22, 22.06, 22.064, 22.07, 23, 25, 30, 40, 50, 80, 90, 100};
	const int np = sizeof(pp)/sizeof(double);
	const double ss[] = {0.01,1,2,3,3.5,4,5,6,7,8,9,10,11,12};
	const int ns = sizeof(ss)/sizeof(double);
	const double *p, *s;

	fprintf(stderr,"FULL (P,S) TESTS\n");
	for(p=pp; p<pp+np; ++p){
		for(s=ss; s<ss+ns; ++s){
			if(freesteam_bounds_ps(*p*1e6,*s*1e3,0))continue;
			//if(freesteam_region_ps(*p*1e6,*s*1e3)!=3)continue;
			test_steam_ps(*p,*s);
		}
	}
}

/*------------------------------------------------------------------------------
  FULL (T,S) ROUTINES
*/

void test_steam_Ts(double T,double s){
	//fprintf(stderr,"------------\n");
	//fprintf(stderr,"%s: T = %f K, s = %f kJ/kgK\n",__func__, T, s);
	freesteam_bounds_Ts(T,s*1e3,1);
	SteamState S = freesteam_set_Ts(T,s*1e3);
	//if(S.region !=1)return;
	//fprintf(stderr,"--> region = %d\n", S.region);
	//if(S.region==4)fprintf(stderr,"--> p = %g\n", freesteam_region4_psat_T(S.R4.T));
	CHECK_VAL(freesteam_T(S),T,RELTOL);
	CHECK_VAL(freesteam_s(S),s*1e3,RELTOL);
};

void testTs(void){
	const double TT[] = {273.15, 276.15, 283.15, 300, 400, 500, 600, 621
		, REGION1_TMAX, 630, 647, IAPWS97_TCRIT, 648, 680, 700,800,900
		, 1000,1073.15
	};
	const int nT = sizeof(TT)/sizeof(double);
	const double ss[] = {0,0.01,1,2,3,3.5,4,5,6,7,8,9,10,11,12};
	const int ns = sizeof(ss)/sizeof(double);
	const double *T, *s;

	fprintf(stderr,"FULL (T,S) TESTS\n");
	int n = 0;
	for(T=TT; T<TT+nT; ++T){
		for(s=ss; s<ss+ns; ++s){
			if(freesteam_bounds_Ts(*T,*s*1e3,0))continue;
			test_steam_Ts(*T,*s);
			++n;
		}
	}
	fprintf(stderr,"...tested %d points.\n",n);
}

/*------------------------------------------------------------------------------
  FULL (P,V) ROUTINES
*/

#define PVRELTOL 1.e-8

void test_steam_pv(double p,double v){
	//fprintf(stderr,"------------\n");
	//fprintf(stderr,"%s: p = %f MPa, v = %f m3/kg\n",__func__, p, v);
	freesteam_bounds_pv(p*1e6,v,1);
	SteamState S = freesteam_set_pv(p*1e6,v);
	//if(S.region != 3)return;
	//fprintf(stderr,"--> region = %d\n", S.region);
	//if(S.region==4)fprintf(stderr,"--> T = %g\n", freesteam_T(S));
	CHECK_VAL(freesteam_p(S),p*1e6,PVRELTOL);
	CHECK_VAL(freesteam_v(S),v,PVRELTOL);
};

void testpv(void){
	const double pp[] = {1e-5, 2e-5, 5e-5, 1e-4, 5e-4, 0.001, 0.0035, 0.01, 0.1, 1, 2, 3, 5, 8, 10, 12, 17, 18, 20, 22, 22.06
		, 22.064, 22.07, 23, 25, 30, 40, 50, 80, 90, 100
	};
	const int np = sizeof(pp)/sizeof(double);
	const double vv[] = {0.0009, 0.001, 0.0012, 0.0014, 0.0017, 0.002, 0.003, 0.004, 0.005, 0.01, 0.02, 0.03, 0.04, 0.06, 0.1, 0.2};
	const int nv = sizeof(vv)/sizeof(double);
	const double *p, *v;

	fprintf(stderr,"FULL (P,V) TESTS\n");
	int n = 0;
	for(p=pp; p<pp+np; ++p){
		for(v=vv; v<vv+nv; ++v){
			if(freesteam_bounds_pv(*p * 1e6, *v, 0))continue;
			//if(freesteam_region_ps(*p*1e6,*s*1e3)!=3)continue;
			test_steam_pv(*p,*v);
			++n;
		}
	}
	fprintf(stderr,"...tested %d points.\n",n);
}

/*------------------------------------------------------------------------------
  FULL (T, x) ROUTINES
*/

#define TXRELTOL 1.e-4

void testTx(void){
	SteamState S;

	const double xx[] = {-1, -2, -1e-6, 0, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1, 0.3, 0.5, 0.7
		, 0.9, 0.99, 0.999, 0.9999, 0.99999, 0.999999, 1, 1.00000001, 1.1, 2, 5
	};
	const int nx = sizeof(xx)/sizeof(double);

	const double TT[] = {273.15, 273.16, 273.2, 274, 280, 290, 300, 310, 350
		, 400, 450, 500, 550, 600, 620, 630, 640, 645, 647, 647.09, IAPWS97_TCRIT
		, 647.1, 650, 700, 800, 900, 1000, 1073.15
	};
	const int nT = sizeof(TT)/sizeof(double);

	fprintf(stderr,"FULL (T,X) TESTS\n");

	const double *x,*T;
	int n = 0;
	for(x = xx; x < xx+nx; ++x){
		for(T = TT; T < TT+nT; ++T){
			if(freesteam_bounds_Tx(*T, *x, 0))continue;
			if(*T == IAPWS97_TCRIT)continue;
			S = freesteam_set_Tx(*T, *x);
			//fprintf(stderr,"T = %f, x = %f... region %d\n", *T, *x, S.region);
			CHECK_VAL(freesteam_T(S), *T, TXRELTOL);
			CHECK_VAL(freesteam_x(S), *x, TXRELTOL);
			++n;
		}
	}
	fprintf(stderr,"...tested %d points.\n",n);
}


/*------------------------------------------------------------------------------
  (u, v) ROUTINES
*/


void testuv(void){
	SteamState S;

	const double xx[] = {-1, -2, -1e-6, 0, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 1e-1, 0.3, 0.5, 0.7
		, 0.9, 0.99, 0.999, 0.9999, 0.99999, 0.999999, 1, 1.00000001, 1.1, 2, 5
	};
	const int nx = sizeof(xx)/sizeof(double);

	const double TT[] = {273.15, 273.16, 273.2, 274, 280, 290, 300, 310, 350
		, 400, 450, 500, 550, 600, 620, 630, 640, 645, 647, 647.09, IAPWS97_TCRIT
		, 647.1, 650, 700, 800, 900, 1000, 1073.15
	};
	const int nT = sizeof(TT)/sizeof(double);

	fprintf(stderr,"FULL (T,X) TESTS\n");

	const double *x,*T;
	int n = 0;
	for(x = xx; x < xx+nx; ++x){
		for(T = TT; T < TT+nT; ++T){
			if(freesteam_bounds_Tx(*T, *x, 0))continue;
			if(*T == IAPWS97_TCRIT)continue;
			S = freesteam_set_Tx(*T, *x);
			//fprintf(stderr,"T = %f, x = %f... region %d\n", *T, *x, S.region);
			CHECK_VAL(freesteam_T(S), *T, TXRELTOL);
			CHECK_VAL(freesteam_x(S), *x, TXRELTOL);
			++n;
		}
	}
	fprintf(stderr,"...tested %d points.\n",n);
}


/*------------------------------------------------------------------------------
  VISCOSITY ROUTINES
*/

#define MURELTOL 1e-6

void test_viscosity_rhoT_point(double rho, double T, double mu){
	double mu1 = freesteam_mu_rhoT(rho,T)*1e6; // compare in microPascal-s
	CHECK_VAL(mu1,mu,MURELTOL);
}

void testviscosityrhoT(void){
	fprintf(stderr,"VISCOSITY (RHO,T) TESTS\n");
	test_viscosity_rhoT_point(998.,     298.15,	    889.735100);
	test_viscosity_rhoT_point(1200.,    298.15,	    1437.649467);
	test_viscosity_rhoT_point(1000.,    373.15,	    307.883622);
	test_viscosity_rhoT_point(1.,       433.15,	    14.538324);
	test_viscosity_rhoT_point(1000.,    433.15,	    217.685358);
	test_viscosity_rhoT_point(1.,       873.15,	    32.619287);
	test_viscosity_rhoT_point(100.,     873.15,	    35.802262);
	test_viscosity_rhoT_point(600., 	873.15,     77.430195);
	test_viscosity_rhoT_point(1.,       1173.15,	44.217245);
	test_viscosity_rhoT_point(100.,     1173.15,	47.640433);
	test_viscosity_rhoT_point(400.,     1173.15,	64.154608);
}

/*------------------------------------------------------------------------------
  THERMAL CONDUCTIVITY ROUTINES
*/

#define KRELTOL 0.0013
/*
	@param p pressure/[MPa]
	@param T temperature/[°C]
*/
void test_k_pT_point(double p, double T, double k){
#if 0
	fprintf(stderr,"\n\np = %f MPa, T = %f °C, expect k = %f mW/m·K\n", p, T, k);
#endif

	SteamState S = freesteam_set_pT(p * 1e6, T + 273.15);

#if 0
	CHECK_VAL(freesteam_p(S), p*1e6, 1e-5);
	CHECK_VAL(freesteam_T(S), T + 273.15,1e-5);
	fprintf(stderr,"rho = %f\n", freesteam_rho(S));
#endif

	double k1 = freesteam_k_rhoT(freesteam_rho(S),T + 273.15) * 1.e3; // compare in mW/m·K

#if 0
	fprintf(stderr,"===> error = %f mW/m·K\n", k1 - k);
#endif

	CHECK_VAL(k1,k,KRELTOL);
}

void testconductivitypT(void){
	fprintf(stderr,"THERMAL CONDUCTIVITY (P,T) TESTS\n");

#define P_COUNT 29
#define T_COUNT 22
	const double p_raw[P_COUNT]={0.1, 0.5, 1, 2.5, 5, 7.5, 10, 12.5, 15, 17.5, 20, 22.5, 25, 27.5, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100};

	const double T_raw[T_COUNT]={0, 25, 50, 75, 100, 150, 200, 250, 300, 350, 375, 400, 425, 450, 475, 500, 550, 600, 650, 700, 750, 800};

	const double k[T_COUNT][P_COUNT]={
		{562,562.3,562.6,563.4,564.9,566.4,567.8,569.3,570.8,572.2, 573.6,575.1,576.5,577.9,579.3,582.1,584.9,587.6,590.3,593,595.7,598.3,600.9,603.5,606.1,608.6,611.1,613.6,616}
		,{607.5,607.7,608,608.8,610.1,611.4,612.7,614.1,615.4,616.7, 617.9,619.2,620.5,621.8,623.1,625.6,628.1,630.6,633,635.5,637.9,640.3,642.6,645,647.3,649.6,651.9,654.2,656.4}
		,{640.5,640.7,641,641.7,643,644.3,645.6,646.9,648.1,649.4,650.6, 651.9,653.1,654.4,655.6,658,660.4,662.8,665.2,667.6,669.9,672.2,674.5,676.8,679,681.3,683.5,685.7,687.8}
		,{663.5,663.7,663.9,664.7,666,667.4,668.6,669.9,671.2,672.5, 673.8,675,676.3,677.5,678.8,681.3,683.7,686.1,688.5,690.9,693.2,695.6,697.9,700.2,702.4,704.7,706.9,709.1,711.3}
		,{24.8,678,678.3,679.1,680.5,681.9,683.2,684.6,685.9,687.3, 688.6,689.9,691.2,692.5,693.8,696.4,699,701.5,704,706.5,708.9,711.3,713.7,716,718.4,720.7,723,725.2,727.5}
		,{28.8,683.9,684.2,685.2,686.9,688.5,690.2,691.8,693.4,695, 696.5,698.1,699.6,701.2,702.7,705.7,708.6,711.6,714.4,717.3,720,722.8,725.5,728.2,730.8,733.4,736,738.5,741}
		,{33.4,34.2,36.1,664.2,666.4,668.6,670.7,672.8,674.9,676.9, 678.9,680.9,682.9,684.8,686.7,690.5,694.2,697.8,701.3,704.8,708.1,711.5,714.7,717.9,721.1,724.2,727.2,730.2,733.2}
		,{38.3,38.8,39.7,43.9,619.1,622.3,625.5,628.5,631.5,634.4, 637.2,640,642.7,645.4,648,653.2,658.1,662.9,667.5,672,676.4,680.6,684.8,688.8,692.8,696.6,700.4,704.1,707.7}
		,{43.5,43.9,44.5,46.8,53,64,548.1,553.6,558.7,563.6,568.3, 572.9,577.2,581.4,585.5,593.2,600.5,607.4,614,620.3,626.3,632.1,637.7,643,648.2,653.3,658.1,662.8,667.4}
		,{49,49.3,49.8,51.5,55.2,60.6,68.5,81.1,104.1,441.9,454.1,464.7, 474.1,482.7,490.6,504.7,517.3,528.7,539.1,548.7,557.7,566.1,574,581.5,588.7,595.5,602,608.3,614.3}
		,{51.8,52.1,52.6,54.1,57.1,61.1,66.4,73.7,84.5,103.1,145.2, 477.1,386.9,405.8,420.6,443.9,462.4,478.2,492,504.4,515.8,526.2,535.9,545,553.5,561.5,569.2,576.4,583.4}
		,{54.7,55,55.4,56.8,59.5,62.9,67.2,72.8,79.9,89.6,103.4,124.2, 160,232.4,328.1,373,398.5,419.9,438.3,454.4,468.8,481.8,493.7,504.7,514.9,524.5,533.5,542,550}
		,{57.7,58,58.4,59.6,62.1,65.1,68.6,73,78.3,84.9,93.4,104.3, 118.9,138.9,167.3,253.6,321.1,354.9,379.4,400,417.9,433.9,448.3,461.5,473.7,485,495.5,505.4,514.7}
		,{60.7,61,61.4,62.5,64.8,67.5,70.6,74.2,78.5,83.6,89.8,97.2, 106.3,117.5,131.5,170.8,225,277.9,315.7,343.1,365.2,384.3,401.3,416.8,430.9,443.9,456,467.3,477.9}
		,{63.8,64,64.4,65.5,67.6,70.1,72.8,76,79.7,83.9,88.8,94.4, 101.1,108.9,118,141.6,173.2,211.9,251.3,285.4,312.9,335.5,355.1,372.5,388.4,402.9,416.4,429,440.8}
		,{66.9,67.2,67.5,68.6,70.6,72.8,75.3,78.2,81.4,85,89.1,93.7, 99,105,111.9,128.5,149.7,175.7,205.5,236,264.6,289.8,311.7,330.9,348.2,363.9,378.5,392.1,404.8}
		,{73.3,73.6,73.9,74.9,76.7,78.7,80.8,83.2,85.8,88.7,91.9,95.4, 99.2,103.4,108,118.6,131.2,145.9,162.9,181.7,201.8,222.4,242.7,262,280.2,297.1,312.7,327.3,341}
		,{79.9,80.1,80.4,81.4,83,84.8,86.8,88.9,91.1,93.6,96.2,99.1, 102.1,105.4,109,116.9,125.9,136.2,147.7,160.3,174.1,188.7,203.8,219.2,234.6,249.6,264.2,278.3,291.7}
		,{86.7,86.9,87.2,88,89.6,91.2,93,94.9,96.9,99.1,101.4,103.8, 106.4,109.2,112.1,118.5,125.7,133.6,142.3,151.8,162.1,173,184.4,196.3,208.5,220.8,233.1,245.3,257.3}
		,{93.6,93.8,94,94.9,96.3,97.8,99.5,101.2,103,105,107,109.2, 111.5,113.9,116.4,121.8,127.8,134.3,141.4,149.1,157.2,165.9,175,184.5,194.3,204.3,214.5,224.7,235}
		,{100.6,100.8,101,101.8,103.2,104.6,106.1,107.7,109.4,111.2, 113,115,117,119.2,121.4,126.2,131.4,136.9,143,149.4,156.2,163.4,171,178.8,187,195.3,203.9,212.5,221.3}
		,{107.7,107.9,108.2,108.9,110.2,111.5,113,114.4,116,117.6, 119.3,121.1,123,124.9,126.9,131.2,135.8,140.7,145.9,151.5,157.4,163.6,170,176.7,183.7,190.8,198.2,205.6,213.2}
	};

	int it, ip;
	for(it=0; it < T_COUNT; ++it){
		for(ip=0; ip < P_COUNT; ++ip){
			test_k_pT_point(p_raw[ip], T_raw[it], k[it][ip]);
		}
	}
#undef P_COUNT
#undef T_COUNT

}

/*------------------------------------------------------------------------------
  SURFACE TENSION ROUTINE
*/

typedef struct{
	double T, sigma;
} SurfTensData;

void testsurftens(void){
	fprintf(stderr,"SURFACE TENSION (T) TESTS\n");

#define SURFTENS_RELTOL 5e-3
#define SURFTENS_COUNT 75
	SurfTensData td[SURFTENS_COUNT] = {
		{0.01,	75.65}
		,{5,	74.94}
		,{10,	74.22}
		,{15,	73.49}
		,{20,	72.74}
		,{25,	71.97}
		,{30,	71.19}
		,{35,	70.40}
		,{40,	69.60}
		,{45,	68.78}
		,{50,	67.94}
		,{55,	67.10}
		,{60,	66.24}
		,{65,	65.37}
		,{70,	64.48}
		,{75,	63.58}
		,{80,	62.67}
		,{85,	61.75}
		,{90,	60.82}
		,{95,	59.87}
		,{100,	58.91}
		,{105,	57.94}
		,{110,	56.96}
		,{115,	55.97}
		,{120,	54.97}
		,{125,	53.96}
		,{130,	52.93}
		,{135,	51.90}
		,{140,	50.86}
		,{145,	49.80}
		,{150,	48.74}
		,{155,	47.67}
		,{160,	46.59}
		,{165,	45.50}
		,{170,	44.41}
		,{175,	43.30}
		,{180,	42.19}
		,{185,	41.07}
		,{190,	39.95}
		,{195,	38.81}
		,{200,	37.67}
		,{205,	36.53}
		,{210,	35.38}
		,{215,	34.23}
		,{220,	33.07}
		,{225,	31.90}
		,{230,	30.74}
		,{235,	29.57}
		,{240,	28.39}
		,{245,	27.22}
		,{250,	26.04}
		,{255,	24.87}
		,{260,	23.69}
		,{265,	22.51}
		,{270,	21.34}
		,{275,	20.16}
		,{280,	18.99}
		,{285,	17.83}
		,{290,	16.66}
		,{295,	15.51}
		,{300,	14.36}
		,{305,	13.22}
		,{310,	12.09}
		,{315,	10.97}
		,{320,	9.86}
		,{325,	8.77}
		,{330,	7.70}
		,{335,	6.65}
		,{340,	5.63}
		,{345,	4.63}
		,{350,	3.67}
		,{355,	2.74}
		,{360,	1.88}
		,{365,	1.08}
		,{370,	0.39}
	};

	int i;
	for(i=0; i<SURFTENS_COUNT; ++i){
		double sig = td[i].sigma * 1e-3;
		double sig1 = freesteam_surftens_T(td[i].T + 273.15);
		CHECK_VAL(sig1, sig, SURFTENS_RELTOL);
	}
}

/*------------------------------------------------------------------------------
  MAIN ROUTINE
*/

int main(void){
	errorflag = 0;
	maxrelerr = 0;

#if 1
	testregion1();
	testregion2();
	testregion3();
	testregion4();
	testregion1ph();
	testregion2ph();
	testregion3ph();
	testregion3ps();
	testregion3psath();
	testregion3psats();
	testb23();

	fprintf(stderr,"%s Max rel err = %e %%\n",errorflag?"ERRORS ENCOUNTERED":"SUCCESS!",maxrelerr*100);
#endif

	maxrelerr = 0;
#if 0
	fprintf(stderr,"\nFurther tests...\n");
#endif
	testps();
	testpT();
	testTs();
	testpv();
	testTx();

	fprintf(stderr,"%s Max rel err = %e %%\n",errorflag?"ERRORS ENCOUNTERED":"SUCCESS!",maxrelerr*100);
	maxrelerr = 0;

	/* the following tests cause the larger errors, and are not part of the
	formal validation of freesteam. It is *expected* that T(p,h) routines and
	v(p,h) routines will introduce some errors, and we are seeing this.

	Having said that, the big errors are coming from region 1 T(p,h); without
	that, the value of PHRELTOL could be reduced to 

		1e-3 (region 1)
		6e-5 (region 2)
		3e-4 (region 3)
		5e-7 (region 4)
	*/	
	maxrelerr = 0;
	testph();
	fprintf(stderr,"%s Max rel err = %e %%\n",errorflag?"ERRORS ENCOUNTERED":"SUCCESS!",maxrelerr*100);

#if 0
	/* Also, the region4props test uses data from IAPWS95, which is not in
	perfect agreement with IAPWS-IF97. */

	//testregion4props();

	//testderivs();
	//testzeroin();
	testsolver2();

	//testTu(); .. not implemented
	
	fprintf(stderr,"%s Max rel err = %e %%\n",errorflag?"ERRORS ENCOUNTERED":"SUCCESS!",maxrelerr*100);
#endif

	maxrelerr = 0;
    testviscosityrhoT();
	fprintf(stderr,"%s Max rel err = %e %%\n",errorflag?"ERRORS ENCOUNTERED":"SUCCESS!",maxrelerr*100);

	maxrelerr = 0;
	testconductivitypT();
	fprintf(stderr,"%s Max rel err = %e %%\n",errorflag?"ERRORS ENCOUNTERED":"SUCCESS!",maxrelerr*100);

	maxrelerr = 0;
	testsurftens();
	fprintf(stderr,"%s Max rel err = %e %%\n",errorflag?"ERRORS ENCOUNTERED":"SUCCESS!",maxrelerr*100);

	
	if(errorflag)fprintf(stderr,"Return code %d.\n",errorflag);
	return errorflag;
}

=#