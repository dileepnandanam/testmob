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
cam = 0

#TO DO
def capture():
    print("CAPTURING SCREENSHOT")

    filename = '/tmp' + '/vision_output.bmp'
    r,img = cam.read()
    cv2.imwrite(filename, img)
    return filename

def execute_touch():
    print("EXECUTING TOUCH")
    input_image = cv2.imread('/tmp/vision_input.jpeg')
    r, vision_image = cam.read()

def execute_text_command(command):
    print("EXECUTING COMMAND: " + command)

def execute_predefined_actions():
    print("EXECUTING PREDEFINED ACTIONS")




#SERVER, DO NOT CHANGE
class MyServer(BaseHTTPRequestHandler):
    def send_image_filename(self, filename):
        self.send_response(200)
        self.send_header("Content-type", "text")
        self.end_headers()
        self.wfile.write(bytes(filename, "ascii"))

    def do_GET(self):
        if self.path == '/capture':
            self.send_image_filename(capture())

    def get_params(self):
        ctype, pdict = cgi.parse_header(self.headers['content-type'])
        pdict['boundary'] = bytes(pdict['boundary'], "utf-8")
        pdict['CONTENT-LENGTH'] = int(self.headers['Content-Length'])
        return cgi.parse_multipart(self.rfile, pdict)

    def do_POST(self):
        
        if self.path == '/execute_touch':
            execute_touch()
            self.send_image_filename(capture())

        if self.path == '/execute_text_command':
            command = self.get_params()['text'][0]
            execute_text_command(command)
            self.send_image_filename(capture())
        
        if self.path == '/execute_predefined_actions':
            execute_predefined_actions()
            self.send_image_filename(capture())   


if __name__ == "__main__":
  
  #camera....................................
  cam = cv2.VideoCapture(1)
  #...........................................

  webServer = HTTPServer((hostName, serverPort), MyServer)
  print("Server started http://%s:%s" % (hostName, serverPort))
  try:
    webServer.serve_forever()
  except KeyboardInterrupt:
    pass
  webServer.server_close()
  print("Server stopped.")