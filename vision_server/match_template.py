import cv2
import numpy as np

def find_match(big_image, small_image):
    img_gray = cv2.cvtColor(big_image, cv2.COLOR_BGR2GRAY)
    w, h = small_image.shape[::-1]
    res = cv2.matchTemplate(img_gray,small_image,cv2.TM_CCOEFF_NORMED)
    threshold = 0.8
    loc = np.where( res >= threshold)
    matched = None
    for pt in zip(*loc[::-1]):
        matched = pt, (pt[0] + w, pt[1] + h)
        cv2.rectangle(big_image, pt, (pt[0] + w, pt[1] + h), (0,0,255), 2)

    cv2.imwrite('/tmp/vision_output.jpeg',big_image)
    return(matched)
