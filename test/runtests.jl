using ThermodynamicsTable
using Base.Test

# write your own tests here
for i in [1:5]
  @test_approx_eq getvalueforname("CpPoly","Argon")[i] (20786,0.0,0.0,0.0,0.0)[i] #argon , perry 8ed. p 2-174
  @test_approx_eq getvalueforname("CpHyper","Air")[i] (0.28958e5,0.0939e5,3.012e3,0.0758e5,1484)[i] #air , perry 8ed. p 2-176
end
for i in [1:3]
  @test_approx_eq getvalueforname("Criticals","Argon")[i] (150.86,4.898e6,0.0)[i] #argon , perry 8ed. p 2-138
end
@test getnameforcasno("7440-37-1") == "Argon"
@test getnameforformula("Ar") == "Argon"
@test getvalueforname("Profile","Argon") == ("Ar","7440-37-1",39.948) 
println ("available CpPoly=",length(getallnamesforproperty("CpPoly"))) 
println ("available CpHyper=",length(getallnamesforproperty("CpHyper"))) 
println ("available Criticals=",length(getallnamesforproperty("Criticals"))) 
@test_throws DataType getallnamesforproperty("criticals") == ArgumentError
@test_throws DataType getvalueforname("Criticals","Argone") == KeyError
chemicalNames=getallnamesforproperty("Criticals")
MIN_Tc=typemax(Float64)
MAX_Tc=0
MIN_Pc=typemax(Float64)
MAX_Pc=0
SUM_Pc=0
SUM_Tc=0
i=0
for chemical in chemicalNames
  (Tc,Pc,Zc)=(getvalueforname("Criticals",chemical))
  println (chemical," ",Tc,Pc,Zc)
  Tc>MAX_Tc && (MAX_Tc=Tc)
  Tc<MIN_Tc && (MIN_Tc=Tc)
  Pc<MIN_Pc && (MIN_Pc=Pc) 
  Pc>MAX_Pc && (MAX_Pc=Pc) 
  i+=1
  SUM_Pc+=Pc
  SUM_Tc+=Tc
end
@test i == 345
AVR_Pc=SUM_Pc/i
AVR_Tc=SUM_Tc/i
println ("(AVR_Tc,AVR_Pc,MAX_Tc,MAX_Pc,MIN_Tc,MIN_Pc)==",AVR_Tc,",",AVR_Pc,",",MAX_Tc,",",MAX_Pc,",",MIN_Tc,",",MIN_Pc)
