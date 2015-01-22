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
@test length(getallnamesforproperty("CpPoly")) == 61 
@test length(getallnamesforproperty("CpHyper")) == 341 
@test length(getallnamesforproperty("Criticals")) == 345 
@test_throws getallnamesforproperty("criticals") == ArgumentError
@test_throws getvalueforname("Criticals","Argone") == KeyError
