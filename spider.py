
# Larry To
# BIOEN 336 Assignment 2, Problem 5,6
# 1/21/16
# Compute the steady state concentration of S1 and plot a perturbed model

#Importing Library
import tellurium as te
import matplotlib.pyplot as plt
import numpy

#Executing roadrunner
rr = te.loada('''
     $Xo -> S1; k1*Xo;
     S1 -> $X1; k2*S1;
     S1 -> $X2; k3*S1;
     
     // Initial Value
     Xo = 10; X1 = 0; 
     X2 = 0; k1 = 3;
     k2 = 1.5; k3 = 0.5;
     
     // Initial Starting Point
     S1 = 1;
''')
     
#rr.steadyState()
     
print rr.S1
m1 = rr.simulate(0,20,100,["time","S1"])
rr.Xo = rr.Xo + 0.75
m2 = rr.simulate(20,40,100,["time","S1"])
m3 = numpy.vstack((m1,m2))
rr.Xo = rr.Xo - 0.75
m4 = rr.simulate(40,60,100,["time","S1"])
result = numpy.vstack((m3,m4))

#Plotting
te.plotWithLegend(rr, result)
plt.title('Concentration of S1 with Perturbation',fontsize = 14)
plt.xlabel('Time(s)', fontsize = 14)
plt.ylabel('Concentration(M)',fontsize = 14)




