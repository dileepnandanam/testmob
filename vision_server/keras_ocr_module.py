import keras_ocr
import pytesseract
import numpy as np
import cv2


def detect_charectors(path):
    img = cv2.imread(path)
    result_string = ""

    # resize image
    scale_percent = 50 # percent of original size
    width = int(img.shape[1] * scale_percent / 100)
    height = int(img.shape[0] * scale_percent / 100)
    dim = (width, height) 
    img = cv2.resize(img, dim, interpolation = cv2.INTER_AREA)

    image = img
    #image = cv2.rotate(img, cv2.cv2.ROTATE_90_COUNTERCLOCKWISE)
    #image = cv2.rotate(img, cv2.cv2.ROTATE_90_CLOCKWISE)

    pipeline = keras_ocr.pipeline.Pipeline()    
    prediction_groups = pipeline.recognize([image])
    for i in range(len(prediction_groups[0])):
        result_string = result_string + str(prediction_groups[0][i][0]) + ' : '

    return result_string

def detect_charectors_tesseract(path):
    img = cv2.imread(path)

    # resize image
    scale_percent = 50 # percent of original size
    width = int(img.shape[1] * scale_percent / 100)
    height = int(img.shape[0] * scale_percent / 100)
    dim = (width, height) 
    img = cv2.resize(img, dim, interpolation = cv2.INTER_AREA)

    image = img
    #image = cv2.rotate(img, cv2.cv2.ROTATE_90_COUNTERCLOCKWISE)
    #image = cv2.rotate(img, cv2.cv2.ROTATE_90_CLOCKWISE)

    h,w,c = image.shape
    Gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    Blured = cv2.medianBlur(Gray,3)
    thresholdValue = 215 #180
    _, dst = cv2.threshold(Blured, thresholdValue , 255, 0)
    kernel = np.ones((1, 1), np.uint8)
    Dialated = cv2.dilate(dst, kernel, iterations=1) # APPLY DILATION
    Eroded = cv2.erode(Dialated, kernel, iterations=1) 
    blur = cv2.medianBlur(Eroded,3)
    Eroded_img =cv2.addWeighted(Eroded, 1.5, blur, -0.5, 0)
    ocr_text = pytesseract.image_to_string(Eroded_img, config='--psm 3', lang='eng')

    return ocr_text
