import cv2
import numpy as np

def midpoint(matched):
    x = (matched[1][0] - matched[0][0])/2
    y = (matched[1][1] - matched[0][1])/2
    return((matched[0][0] + x, matched[0][1] + y))

def find_match(big_image, small_image):
    img_gray = cv2.cvtColor(big_image, cv2.COLOR_BGR2GRAY)
    w, h = small_image.shape[::-1]
    res = cv2.matchTemplate(img_gray,small_image,cv2.TM_CCOEFF_NORMED)
    threshold = 0.9
    loc = np.where( res >= threshold)
    matched = None
    for pt in zip(*loc[::-1]):
        matched = pt, (pt[0] + w, pt[1] + h)

    if matched == None:
        return(None)
    return(midpoint(matched))
