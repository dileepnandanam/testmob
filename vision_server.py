from http.server import BaseHTTPRequestHandler, HTTPServer
import time
import cgi
from cgi import parse_header, parse_multipart
import base64

from pypylon import pylon
from PIL import Image as im
import cv2
from io import BytesIO



#interactive console
#import code; code.interact(local=dict(globals(), **locals()))


hostName = "localhost"
serverPort = 8080


#Globals for Camera
img = pylon.PylonImage()


#TO DO
def capture():
  print("CAPTURING SCREENSHOT")

  cam.StartGrabbing(pylon.GrabStrategy_LatestImageOnly)
  converter = pylon.ImageFormatConverter()
  # converting to opencv bgr format
  converter.OutputPixelFormat = pylon.PixelType_BGR8packed
  converter.OutputBitAlignment = pylon.OutputBitAlignment_MsbAligned
  grabResult = cam.RetrieveResult(5000, pylon.TimeoutHandling_ThrowException)
  # Access the image data
  image = converter.Convert(grabResult)
  img = image.GetArray()
  pil_img = im.fromarray(img)
  buff = BytesIO()
  pil_img.save(buff, format="JPEG")
  encoded_img = base64.b64encode(buff.getvalue()).decode("utf-8")
  cam.StopGrabbing()

  return encoded_img

def execute_touch(croped_image_base64):
  print("EXECUTING TOUCH")
  binary_img = base64.b64decode(croped_image_base64)
  print("RECIEVED: " + str(binary_img))

def execute_text_command(command):
  print("EXECUTING COMMAND: " + command)

def execute_predefined_actions():
  print("EXECUTING PREDEFINED ACTIONS")




#SERVER, DO NOT CHANGE
class MyServer(BaseHTTPRequestHandler):
    def send_image_response(self, image_base64):
        self.send_response(200)
        self.send_header("Content-type", "base64")
        self.end_headers()
        self.wfile.write(bytes(image_base64, "ascii"))

    def do_GET(self):
        if self.path == '/capture':
            self.send_image_response(capture())

    def get_params(self):
        ctype, pdict = cgi.parse_header(self.headers['content-type'])
        pdict['boundary'] = bytes(pdict['boundary'], "utf-8")
        pdict['CONTENT-LENGTH'] = int(self.headers['Content-Length'])
        return cgi.parse_multipart(self.rfile, pdict)

    def do_POST(self):
        
        if self.path == '/execute_touch':
            croped_image_base64 = self.get_params()['croped_image'][0]
            execute_touch(croped_image_base64)
            self.send_image_response(capture())

        if self.path == '/execute_text_command':
            command = self.get_params()['text'][0]
            execute_text_command(command)
            self.send_image_response(capture())
        
        if self.path == '/execute_predefined_actions':
            execute_predefined_actions()
            self.send_image_response(capture())   


if __name__ == "__main__":
  
  #camera....................................
  pylon_cam = pylon.TlFactory.GetInstance()
  cam = pylon.InstantCamera(pylon_cam.CreateFirstDevice())
  cam.Open()
  #...........................................

  webServer = HTTPServer((hostName, serverPort), MyServer)
  print("Server started http://%s:%s" % (hostName, serverPort))
  try:
    webServer.serve_forever()
  except KeyboardInterrupt:
    pass
  webServer.server_close()
  cam.Close()
  print("Server stopped.")