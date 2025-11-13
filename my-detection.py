#from jetson_inference import detectNet
#from jetson_utils import videoSource, videoOutput
import jetson_inference
import jetson_utils
from jetson_inference import detectNet
from jetson_utils import videoSource, videoOutput

net = detectNet("ssd-mobilenet-v2",threshold = 0.5)
camera = videoSource("/dev/video0")
display = videoOutput("display://0")
while display.IsStreaming():
  img = camera.Capture()
  if img is None:
     continue
  detections = net.Detect(img)
  display.Render(img)
  display.SetStatus("Objiect Detction | Network {:.0f}FPS".format(net.GetNetworkFPS()))




