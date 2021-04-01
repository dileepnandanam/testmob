
import numpy as np
import cv2
import cv2.aruco as aruco
import glob

result =[]
# font for displaying text (below)
font = cv2.FONT_HERSHEY_SIMPLEX

marker_x_plus = False
marker_x_minus = False

pix_per_mm_plus_side = 0
pix_per_mm_minus_side = 0

marker_x_plus_x = ''
marker_x_plus_y = ''
marker_x_minus_x = ''
marker_x_minus_y = ''
avg_pix_per_mm = 0

id_1 = 45#15#45 
id_2 = 25

def detect(frame , marker_size): #frame = img , marker_size = 31
    global marker_x_plus
    global marker_x_minus

    global marker_x_plus_x
    global marker_x_plus_y
    global marker_x_minus_x
    global marker_x_minus_y
    global avg_pix_per_mm

    global pix_per_mm_plus_side
    global pix_per_mm_minus_side

    global id_1
    global id_2

    # operations on the frame
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    # set dictionary size depending on the aruco marker selected
    aruco_dict = aruco.Dictionary_get(aruco.DICT_6X6_250)
    # detector parameters can be set here (List of detection parameters[3])
    parameters = aruco.DetectorParameters_create()
    parameters.adaptiveThreshConstant = 10
    # lists of ids and the corners belonging to each id
    corners, ids, rejectedImgPoints = aruco.detectMarkers(gray, aruco_dict, parameters=parameters)
    # check if the ids list is not empty
    # if no check is added the code will crash
    #print("detecting...")
    if np.all(ids != None):
        # draw a square around the markers
        aruco.drawDetectedMarkers(frame, corners)

        if marker_x_plus != True:
            if id_1 in ids :
            
                index  = np.where(ids == id_1)
                marker_x_plus_x = (corners[int(index[0])][0][0][0] + corners[int(index[0])][0][2][0]) /2
                marker_x_plus_y = (corners[int(index[0])][0][0][1] + corners[int(index[0])][0][2][1]) /2

                len_x_plus_x = abs(corners[0][0][1][0] - corners[0][0][0][0])
                len_x_plus_y = abs(corners[0][0][1][1] - corners[0][0][2][1])

                pix_per_mm_plus_side = marker_size/len_x_plus_x 
                marker_x_plus = True
            
            else:
                marker_x_plus_x = None
                marker_x_plus_y = None

                
        if marker_x_minus != True:
            if id_2 in ids :

                index  = np.where(ids == id_2)
                marker_x_minus_x = (corners[int(index[0])][0][0][0] + corners[int(index[0])][0][2][0]) /2
                marker_x_minus_y = (corners[int(index[0])][0][0][1] + corners[int(index[0])][0][2][1]) /2
                
                len_x_minus_x = abs(corners[0][0][1][0] - corners[0][0][0][0])
                len_x_minus_y = abs(corners[0][0][1][1] - corners[0][0][2][1])
                
                pix_per_mm_minus_side = marker_size/len_x_minus_x
                marker_x_minus = True

            else:
                marker_x_minus_x = None
                marker_x_minus_y = None

        if marker_x_plus == True and marker_x_minus == True:
            marker_dif_in_pixel =  abs( marker_x_plus_x - marker_x_minus_x )
            avg_pix_per_mm = float((pix_per_mm_plus_side + pix_per_mm_minus_side) / 2)

            result =[ marker_x_plus_x , marker_x_plus_y , marker_x_minus_x , marker_x_minus_y , avg_pix_per_mm ]
        
        else:
             result = None

    else:
        result = None
        # code to show 'No Ids' when no markers are found
        #cv2.putText(frame, "No Ids", (0,64), font, 1, (0,255,0),2,cv2.LINE_AA)
        print ("Marker Not Found")


    return result



