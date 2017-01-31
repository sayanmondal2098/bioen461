import csv
import matplotlib.pyplot as plt
import math
# import plotly


list = []
time = []
number = 0
with open('Right_Bicep_Data.csv', 'rb') as csvfile:
    spamreader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    for row in spamreader:
        myList = row[0].split(',')
        list.append(myList[1])
        time.append(number)
        number +=1
        
mvc = 0.0025
newList = []
for number in list:
   newList.append(float(number)/mvc)

thresh = [1.0, .9, .8, .7, .6]
motor = {}
max = 255
for data in newList:
    for t in thresh:
        if data >= t:
          motor[data] = math.floor(max*data)  

print motor




#Plotting
plt.plot(time, newList)
#plt.title('Concentration of S1 with Perturbation',fontsize = 14)
#plt.xlabel('Time(s)', fontsize = 14)
#plt.ylabel('Concentration(M)',fontsize = 14)


