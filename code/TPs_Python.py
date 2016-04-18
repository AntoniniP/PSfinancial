# -*- coding: utf-8 -*-
import pandas.io.data as web
import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime

end = datetime.now()
start = datetime(end.year-1, end.month, end.day)
df = web.DataReader("A2A.MI", 'yahoo', start, end)

#change here the indicator
x = df["Close"]

# levels
N = 4 
   
#value and date of the time series
v = []
d = []

#value and date of the TP of the time series
tpv = [] 
tpd = [] 

#value and date with N level of deepness of the time series
tpvl = [] 
tpdl = [] 

#from dictionary to list for the values
for key, value in x.iteritems():
    temp = value
    v.append(temp)
#from dictionary to list fot the dates
for key, value in x.iteritems():
    temp = key
    d.append(temp)


#delete a point if has the same value of the previous one    
c = []  
for i in range (0, len(v)-1):
    if(v[i]==v[i+1]):
        c.append(i+1) 

for e in range(0, len(c)):
    del v[c[e]-e]  
    del d[c[e]-e]


#find the TP
tpv.append(v[0])
tpd.append(d[0])
for z in range(0,len(v)):
    if(z==len(v)-1):
        tpv.append(v[z])
        tpd.append(d[z]) 
    else:
        if (v[z]<=v[z-1] and v[z]<=v[z+1]):
            tpv.append(v[z])
            tpd.append(d[z])
        if (v[z]>=v[z-1] and v[z]>=v[z+1]):
            tpv.append(v[z])
            tpd.append(d[z])         

tpvl = list(tpv)
tpdl = list(tpd)

for h in range(0, N):
    a = 0
    b = []
    #finds the points to flatten
    while (a<len(tpvl)-3):                                                                                            
        if (tpvl[a]<tpvl[a+1] and tpvl[a]<tpvl[a+2] and tpvl[a+1]<tpvl[a+3] and tpvl[a+2]<tpvl[a+3] and (abs(tpvl[a+1]-tpvl[a+2])<(abs(tpvl[a]-tpvl[a+2])+abs(tpvl[a+1]-tpvl[a+3])))):
            b.append(a+1)
            b.append(a+2)
            a = a+3
        elif (tpvl[a]>tpvl[a+1] and tpvl[a]>tpvl[a+2] and tpvl[a+1]>tpvl[a+3] and tpvl[a+2]>tpvl[a+3] and (abs(tpvl[a+1]-tpvl[a+2])<(abs(tpvl[a]-tpvl[a+2])+abs(tpvl[a+1]-tpvl[a+3])))):
            b.append(a+1)
            b.append(a+2)
            a = a+3
        elif (tpvl[a+1]==tpvl[a+3] and tpvl[a]==tpvl[a+2]):
            b.append(a+1)
            b.append(a+2)
            a = a+3
        else:
            a = a+1   
    #delete the flattened points    
    for c in range(0, len(b)):
        del tpvl[b[c]-c]  
        del tpdl[b[c]-c]     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

#plot the original values
plt.plot(d, v, color='black', linewidth=0.5)
#plot the TP
plt.plot(tpd,tpv, color='blue', linewidth=1.5)
#plot at level N of deepness
#plt.plot(tpdl,tpvl, color='red', linewidth=1.5)
#plt.plot(tpdl,tpvl, 'ro')
 
plt.show()