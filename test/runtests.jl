using ThermodynamicsTable
using Base.Test

# write your own tests here
for i in [1:5]
  @test_approx_eq getValueForCasNo("C0Poly","7440-37-1")[i] (20786,0.0,0.0,0.0,0.0)[i] #argon , perry 8ed. p 2-174
  @test_approx_eq getValueForCasNo("C0Hyper","132259-10-0")[i] (0.28958e5,0.0939e5,3.012e3,0.0758e5,1484)[i] #air , perry 8ed. p 2-176
end
for i in [1:3]
  @test_approx_eq getValueForCasNo("Criticals","7440-37-1")[i] (150.86,4.898e6,0.0)[i] #argon , perry 8ed. p 2-138
end
