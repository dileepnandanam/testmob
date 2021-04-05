import numpy
import math
import matplotlib.pyplot as plt 

def equn1(x1,y1,x2,y2):

	dp = 500
	if abs(x2-x1) == 0:
	    [x3,y3] = [x2-dp,y2]
	    [x4,y4] = [x1-dp,y1]
	elif abs(y2 - y1) == 0:
	    [x3,y3] = [x2,y2-dp]
	    [x4,y4] = [x1,y1-dp]

	else:
		m = (y2 - y1)/(x2-x1)
		mp = -1/m
		x3 = x2 - (math.sqrt((dp**2)/(1+mp**2)))
		y3 = y2 - (mp*(math.sqrt((dp**2)/(1+mp**2))))
		x4 = x1 - (math.sqrt((dp**2)/(1+mp**2)))
		y4 = y1 - (mp*(math.sqrt((dp**2)/(1+mp**2))))

	list1=[x3,y3,x4,y4]
	#print (list1)
	return list1

def equn2(x1,y1,x2,y2):
	dp = 500
	if abs(x2-x1) == 0:
	    [x3,y3] = [x2+dp,y2]
	    [x4,y4] = [x1+dp,y1]
	elif abs(y2 - y1) == 0:
	    [x3,y3] = [x2,y2+dp]
	    [x4,y4] = [x1,y1+dp]

	else:
		m = (y2 - y1)/(x2-x1)
		mp = -1/m
		x3 = x2 + (math.sqrt((dp**2)/(1+mp**2)))
		y3 = y2 + (mp*(math.sqrt((dp**2)/(1+mp**2))))
		x4 = x1 + (math.sqrt((dp**2)/(1+mp**2)))
		y4 = y1 + (mp*(math.sqrt((dp**2)/(1+mp**2))))

	list1=[x3,y3,x4,y4]
	#print (list1)
	
	return list1
	   

