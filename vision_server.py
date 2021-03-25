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


#interactive console
#import code; code.interact(local=dict(globals(), **locals()))


hostName = "localhost"
serverPort = 8080


#Globals for Camera
img = pylon.PylonImage()

#TO DO

class Camera:
    def __init__(self):
        pylon_cam = pylon.TlFactory.GetInstance()
        self.cam = pylon.InstantCamera(pylon_cam.CreateFirstDevice())
        self.output_filename = '/tmp/vision_output.bmp'
    
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
        return(img)

    def save_to_disk(self, image_array):
        cv2.imwrite(self.output_filename, image_array)
    
    def save_image(self):
        self.save_to_disk(self.capture_image_array())
        return(self.output_filename)

def execute_touch():
    print("EXECUTING TOUCH")
    input_image = cv2.imread('/tmp/vision_input.jpeg')
    vision_image = cv2.imread('/tmp/vision_output.jpeg')

def execute_text_command(command):
    print("EXECUTING COMMAND: " + command)

def execute_predefined_actions():
    print("EXECUTING PREDEFINED ACTIONS")

class VisionServer(BaseHTTPRequestHandler):
    def send_image_filename(self, filename):
        self.send_response(200)
        self.send_header("Content-type", "text")
        self.end_headers()
        self.wfile.write(bytes(filename, "ascii"))

    def do_GET(self):
        if self.path == '/capture':
            filename = cam.save_image()
            self.send_image_filename(filename)

    def get_params(self):
        ctype, pdict = cgi.parse_header(self.headers['content-type'])
        pdict['boundary'] = bytes(pdict['boundary'], "utf-8")
        pdict['CONTENT-LENGTH'] = int(self.headers['Content-Length'])
        return cgi.parse_multipart(self.rfile, pdict)

    def do_POST(self):
        
        if self.path == '/execute_touch':
            execute_touch()
            filename = cam.save_image()
            self.send_image_filename(filename)

        if self.path == '/execute_text_command':
            command = self.get_params()['text'][0]
            execute_text_command(command)
            filename = cam.save_image()
            self.send_image_filename(filename)
        
        if self.path == '/execute_predefined_actions':
            execute_predefined_actions()
            filename = cam.save_image()
            self.send_image_filename(filename)   


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