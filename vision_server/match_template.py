import cv2
import numpy as np

def midpoint(matched):
    x = (matched[1][0] - matched[0][0])/2
    y = (matched[1][1] - matched[0][1])/2
    return((x,y))

def find_match(big_image, small_image):
    img_gray = cv2.cvtColor(big_image, cv2.COLOR_BGR2GRAY)
    w, h = small_image.shape[::-1]
    res = cv2.matchTemplate(img_gray,small_image,cv2.TM_CCOEFF_NORMED)
    threshold = 0.8
    loc = np.where( res >= threshold)
    matched = None
    for pt in zip(*loc[::-1]):
        matched = pt, (pt[0] + w, pt[1] + h)
        point1,point2 = pt, (pt[0] + w, pt[1] + h)
    
    cv2.rectangle(big_image, point1, point2, (0,0,255), 2)

    cv2.imwrite('/tmp/vision_output.jpeg',big_image)
    return(midpoint(matched))
