using ThermodynamicsTable
using Base.Test

for i in 1:5
  @test_approx_eq getvalueforname("CpPoly","Argon")[i] (20786,0.0,0.0,0.0,0.0)[i] #argon , perry 8ed. p 2-174
  @test_approx_eq getvalueforname("CpHyper","Air")[i] (0.28958e5,0.0939e5,3.012e3,0.0758e5,1484)[i] #air , perry 8ed. p 2-176
end
for i in 1:3
  #argon , perry 8ed. p 2-138
  @test getvalueforname("Profile","Argon")[i] ==  ("Ar","7440-37-1",39.948)[i]
end
for i in 1:4
  #argon , perry 8ed. p 2-138
  @test_approx_eq getvalueforname("Criticals","Argon")[i] (150.86,4.898e6,0.0,0.291)[i]
end
for i in 1:6
  #argon , perry 8ed. p 2-98
  @test_approx_eq getvalueforname("LiquidsDensities","Argon")[i] (3.8469,0.2881,150.86,0.29783,83.78,150.86)[i]
end
for i in 1:7
  #argon , perry 8ed. p 2-55
  @test_approx_eq getvalueforname("LiquidsVaporPressure","Argon")[i] (42.127,-1093.1,-4.1425,5.7254e-05,2,83.78,150.86)[i]
end
for i in 1:7
  #argon , perry 8ed. p 2-165
  @test getvalueforname("LiquidsCp","Argon")[i] == (134390,-1989.4,11.043,"","",83.78,135.00)[i]
end
@test getnameforcasno("7440-37-1") == "Argon"
@test getnameforformula("Ar") == "Argon"
@test getvalueforname("Profile","Argon") == ("Ar","7440-37-1",39.948) 

namesAll=getallnamesforproperty("Criticals")
namescppoly=getallnamesforproperty("CpPoly")
namescphyper=getallnamesforproperty("CpHyper")
namesldens=getallnamesforproperty("LiquidsDensities")
nameslvp=getallnamesforproperty("LiquidsVaporPressure")
nameslcp=getallnamesforproperty("LiquidsCp")

@test length(namesAll) == length(Set(namesAll))
@test length(namescppoly) == length(Set(namescppoly))
@test length(namescphyper) == length(Set(namescphyper))
@test length(namesldens) == length(Set(namesldens))
@test length(nameslvp) == length(Set(nameslvp))
@test length(nameslcp) == length(Set(nameslcp))

println(setdiff(Set(namescppoly),Set(namesAll)))
println(setdiff(Set(namescphyper),Set(namesAll)))
println(setdiff(Set(namesldens),Set(namesAll)))
println(setdiff(Set(nameslvp),Set(namesAll)))
println(setdiff(Set(nameslcp),Set(namesAll)))

println("available Criticals=",length(namesAll))
println("available CpPoly=",length(namescppoly))
println("available CpHyper=",length(namescphyper))
println("available LiquidsDensities=",length(namesldens))
println("available LiquidsVaporPressure=",length(nameslvp))
println("available LiquidsCp=",length(nameslcp))

@test_throws DataType getallnamesforproperty("criticals") == ArgumentError
@test_throws DataType getvalueforname("Criticals","Argone") == KeyError
chemicalNames=getallnamesforproperty("Criticals")
MIN_Tc=typemax(Float64)
MAX_Tc=0
MIN_Pc=typemax(Float64)
MAX_Pc=0
MIN_Zc=typemax(Float64)
MAX_Zc=0
SUM_Pc=0
SUM_Tc=0
i=0
for chemical in chemicalNames
  (Tc,Pc,Af,Zc)=(getvalueforname("Criticals",chemical))
  Tc>MAX_Tc && (MAX_Tc=Tc)
  Tc<MIN_Tc && (MIN_Tc=Tc)
  Pc<MIN_Pc && (MIN_Pc=Pc) 
  Pc>MAX_Pc && (MAX_Pc=Pc) 
  Zc>MAX_Zc && (MAX_Zc=Zc)
  Zc<MIN_Zc && (MIN_Zc=Zc)
  i+=1
  SUM_Pc+=Pc
  SUM_Tc+=Tc
end
@test i == 345
AVR_Pc=SUM_Pc/i
AVR_Tc=SUM_Tc/i
println("(AVR_Tc,AVR_Pc,MAX_Tc,MAX_Pc,MIN_Tc,MIN_Pc,MIN_Zc,MAX_Zc)==",AVR_Tc,",",AVR_Pc,",",MAX_Tc,",",MAX_Pc,",",MIN_Tc,",",MIN_Pc,",",MIN_Zc,",",MAX_Zc)
