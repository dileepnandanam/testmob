import cv2
import numpy as np
import numpy
calib = numpy.load('calibration_file/calib.npz')


def calculate_camera_matrix(img ,crop = False):
	#img = cv2.imread(img)
	h, w = img.shape[:2]
	# Obtain the new camera matrix and undistort the image
	newCameraMtx, roi = cv2.getOptimalNewCameraMatrix(calib['mtx'], calib['dist'], (w, h), 1, (w, h))
	undistortedImg = cv2.undistort(img, calib['mtx'], calib['dist'], None, newCameraMtx)
	if crop == True:
		x, y, w, h = roi
		undistortedImg = undistortedImg[y:y+h,x:x+w]
	return undistortedImg
	
