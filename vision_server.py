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
#interactive console
#import code; code.interact(local=dict(globals(), **locals()))


hostName = "localhost"
serverPort = 8080


#Globals for Camera
img = pylon.PylonImage()

#TO DO

class Camera:
    def __init__(self):
        self.output_filename = '/tmp/vision_output.jpg'

    def connect(self):
        pylon_cam = pylon.TlFactory.GetInstance()
        self.cam = pylon.InstantCamera(pylon_cam.CreateFirstDevice())
        self.get_marker_data()

    def get_marker_data(self):
        self.marker_data = detect(self.capture_image_array(), 31)
        if marker_data == None:
            time.sleep(3)
            self.get_marker_data()

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
        self.save_to_disk(image)
        return(self.output_filename)

def get_coordinates_from_image():
    input_image = cv2.imread('/tmp/vision_input.jpeg')
    vision_image = cv2.imread('/tmp/vision_output.jpeg')
    return('122,122')

def get_coordinates_from_command(command):
    return('122,122')


class VisionServer(BaseHTTPRequestHandler):
    def send_data(self, data):
        self.send_response(200)
        self.send_header("Content-type", "text")
        self.end_headers()
        self.wfile.write(bytes(data, "ascii"))

    def do_GET(self):
        if self.path == '/capture':
            cam.save_image()
            self.send_data('ok')
        if self.path == '/get_coordinates_from_image':
            data = get_coordinates_from_image()
            self.send_data(data)

        if self.path == '/connect':
            cam.connect()
            self.send_data('ok')
        if self.path == '/disconnect':
            cam.disconnect()
            self.send_data('ok')

    def get_params(self):
        ctype, pdict = cgi.parse_header(self.headers['content-type'])
        pdict['boundary'] = bytes(pdict['boundary'], "utf-8")
        pdict['CONTENT-LENGTH'] = int(self.headers['Content-Length'])
        return cgi.parse_multipart(self.rfile, pdict)

    def do_POST(self):
        if self.path == '/get_coordinates_from_command':
            command = self.get_params()['text_command'][0]
            data = get_coordinates_from_command(command)
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