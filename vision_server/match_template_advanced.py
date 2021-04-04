import cv2
import numpy as np
import imutils


maximum_val_ncc = 0.375

rotations = [ cv2.cv2.ROTATE_90_CLOCKWISE , cv2.cv2.ROTATE_180 , cv2.cv2.ROTATE_90_COUNTERCLOCKWISE]

def match(template,gray_image):

	global maximum_val_ncc

	temp_found = None
	result = None

	tmplt_mask = cv2.cvtColor(template, cv2.COLOR_BGR2GRAY)

	template = cv2.Canny(template, 10, 25)
	(height, width) = template.shape[:2]

	for scale in np.linspace(0.2, 1.0, 20)[::-1]:
		#resize the image and store the ratio
		resized_img = imutils.resize(gray_image, width = int(gray_image.shape[1] * scale))
		ratio = gray_image.shape[1] / float(resized_img.shape[1])
		if resized_img.shape[0] < height or resized_img.shape[1] < width:
			break
		#Convert to edged image for checking
		processed_img = cv2.Canny(resized_img, 10, 25)
		match = cv2.matchTemplate(processed_img, template, cv2.TM_CCORR_NORMED, mask=tmplt_mask )
		(val_min, val_max, loc_min, loc_max) = cv2.minMaxLoc(match) # New  minVal,maxVal,minLoc,maxLoc = cv2.minMaxLoc(res)
		

		max_val_ncc = '{:.3f}'.format(val_max)
		print("correlation match score: " + max_val_ncc)

		if float(max_val_ncc) > maximum_val_ncc and max_val_ncc != 'inf':
			if temp_found is None or val_max>temp_found[0]:
				temp_found = (val_max, loc_max, ratio)
				
				#Get information from temp_found to compute x,y coordinate
				(_, loc_max, r) = temp_found
				(x_start, y_start) = (int(loc_max[0]), int(loc_max[1]))
				(x_end, y_end) = (int((loc_max[0] + width)), int((loc_max[1] + height)))
				
				result = (int((loc_max[0] + (width/2))), int((loc_max[1] + (height/2))))
				#print(result)
				break
			else:	
				result = None
				break
		else:
			result = None
			break

	return result


def match_image(main_image, template , rotate_check = False):


	result = None

	gray_image = cv2.cvtColor(main_image, cv2.COLOR_BGR2GRAY)
	##template = cv2.cvtColor(template, cv2.COLOR_BGR2GRAY)

	template_1 = template

	if rotate_check == True:
		for rot in rotations:		
			result = match(template_1 , gray_image)
			if result != None:
				break
			template_1 = cv2.rotate(template, rot)

	else:
		result = match(template , gray_image)
	
    cv2.rectangle(cv2.imread('/tmp/vision_output.jpeg'), (result[0]-30,result[1]-30), (result[0]+30,result[1]+30), (0,0,255), 2)

    cv2.imwrite('/tmp/vision_output.jpeg',big_image)
	return result