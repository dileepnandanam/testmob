from http.server import BaseHTTPRequestHandler, HTTPServer
import time
import cgi
from cgi import parse_header, parse_multipart
import base64
import os
from pypylon import pylon
from PIL import Image as im
import cv2
from io import BytesIO
import pathlib
from aruco_module_line_detector import detect
from UndistortedImg_module import calculate_camera_matrix
from match_template import find_match
from match_template_advanced import match_image
import rect_drw_eqn
from perspective_transform import  four_point_transform
import numpy as np

#interactive console
#import code; code.interact(local=dict(globals(), **locals()))


hostName = "localhost"
serverPort = 8080


#Globals for Camera
img = pylon.PylonImage()

#TO DO

class Camera:
    def __init__(self):
        self.output_filename = '/tmp/vision_output.jpeg'
        self.cam = None

    def connect(self):
        pylon_cam = pylon.TlFactory.GetInstance()
        self.cam = pylon.InstantCamera(pylon_cam.CreateFirstDevice())

    def ploat_marker(self):
        x1,y1,x2,y2,s = self.marker_data
        vision_output = cv2.imread(self.output_filename)
        cv2.rectangle(vision_output, (int(x1)-30,int(y1)-30),(int(x1)+30,int(y1)+30), (0,0,255))
        cv2.rectangle(vision_output, (int(x2)-30,int(y2)-30),(int(x2)+30,int(y2)+30), (0,0,255))
        cv2.imwrite(self.output_filename, vision_output)

    def detect_marker(self):
        global pix_per_mm
        image = self.capture_image_array()
        for threshold in range(1, 30):
            self.marker_data = detect(image, 31, threshold)
            if self.marker_data != None:
                self.threshold = threshold

                x1 = int(self.marker_data[0])
                y1 = int(self.marker_data[1])
                x2 = int(self.marker_data[2])
                y2 = int(self.marker_data[3])

                pix_per_mm = self.marker_data[4] 
            
                if y1 < y2:
                    values=rect_drw_eqn.equn1(x1,y1,x2,y2)
                else:
                    values=rect_drw_eqn.equn2(x1,y1,x2,y2)
        
                self.pts = np.array([(x1, y1), (x2, y2), (values[0], values[1]), (values[2], values[3])])
                self.reference = True
                break;
            else:
                self.reference = False  
        return self.marker_data


    def get_processed_frame(self, img):
        if self.reference == True:
            self.processed_frame = four_point_transform(img, self.pts)
        return self.processed_frame

    def disconnect(self):
        self.cam = None

    def capture_image_array(self):
        self.cam.Open()
        self.cam.StartGrabbing(pylon.GrabStrategy_LatestImageOnly)
        grabResult = self.cam.RetrieveResult(5000, pylon.TimeoutHandling_ThrowException)
        converter = pylon.ImageFormatConverter()
        converter.OutputPixelFormat = pylon.PixelType_BGR8packed
        converter.OutputBitAlignment = pylon.OutputBitAlignment_MsbAligned
        image = converter.Convert(grabResult)
        img = image.GetArray()
        self.cam.StopGrabbing()
        self.cam.Close()
        return(calculate_camera_matrix(img))

    def save_to_disk(self, image_array):
        cv2.imwrite(self.output_filename, image_array)
    
    def save_image(self):
        image = self.capture_image_array()
        image = self.get_processed_frame(image)
        self.save_to_disk(image)
        return(self.output_filename)

def get_real_coordinates(data):
    global pix_per_mm

    REF_X1 = 256
    REF_Y1 = 100

    real_x_mm = int(REF_X1 - ( data[0] * pix_per_mm))
    real_y_mm = int(REF_Y1 + ( data[1] * pix_per_mm ))
    real_coordinates = [int(real_x_mm),int(real_y_mm)]

    return real_coordinates

def get_coordinates_from_image():
    input_image = cv2.imread('/tmp/vision_input.jpeg',0)
    vision_image = cv2.imread('/tmp/vision_output.jpeg')
    return(find_match(vision_image, input_image))

def get_coordinates_from_command(command):
    return(None)

def get_coordinates(x,y):
    return(x,y)

class VisionServer(BaseHTTPRequestHandler):
    def send_data(self, data):
        self.send_response(200)
        self.send_header("Content-type", "text")
        self.end_headers()
        self.wfile.write(bytes(data, "ascii"))

    def do_GET(self):
        if self.path == '/capture':
            if cam.cam == None:
                self.send_data('cam_not_detected')
            else:    
                cam.save_image()
                self.send_data('ok')
        
        if self.path == '/get_coordinates_from_image':
            data = get_coordinates_from_image()
            if data == None:
                self.send_data('coordinates_not_found')
            else:
                real_coordinate = get_real_coordinates(data)
                self.send_data(str(real_coordinate))

        if self.path == '/connect':
            try:
                cam.connect()
                self.send_data('cam connected')
            except:
                self.send_data('cam_not_conneted')
    
        if self.path == '/disconnect':
            cam.disconnect()
            self.send_data('ok')

        if self.path == '/detect_marker':
            if cam.cam == None:
                self.send_data('cam_not_detected')
                return()
            marker_data = cam.detect_marker()
            if marker_data == None:
                self.send_data('marker_not_found')
            else:
                self.send_data(str(marker_data))


    def get_params(self):
        ctype, pdict = cgi.parse_header(self.headers['content-type'])
        pdict['boundary'] = bytes(pdict['boundary'], "utf-8")
        pdict['CONTENT-LENGTH'] = int(self.headers['Content-Length'])
        return cgi.parse_multipart(self.rfile, pdict)

    def do_POST(self):

        if self.path == '/get_coordinates':
            x,y = eval(self.get_params()['c'][0].replace('\\',''))
            data = get_real_coordinates(x,y)
            self.send_data(str([data[0],[1]]))

        if self.path == '/get_coordinates_from_command':
            command = self.get_params()['text_command'][0]
            data = get_coordinates_from_command(command)
            if data == None:
                self.send_data('coordinates_not_found')
            else:
                self.send_data(data)



if __name__ == "__main__":
    cam = Camera()
    webServer = HTTPServer((hostName, serverPort), VisionServer)
    print("Server started http://%s:%s" % (hostName, serverPort))
    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass
    webServer.server_close()
    print("Server stopped.")