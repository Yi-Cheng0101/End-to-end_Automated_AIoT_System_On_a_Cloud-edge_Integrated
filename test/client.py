import argparse
import json

import numpy as np
import requests
from keras.applications import xception
from keras.preprocessing import image

# Argument parser for giving input image_path from command line
ap = argparse.ArgumentParser()
ap.add_argument("-i", "--image", required=True,
                help="path of the image")
ap.add_argument("-u", "--url", required=True, 
                help="the IP address of Pod / Node")
ap.add_argument("-p", "--port",  required=True,
                help="the port number of Pod / Node")
args = vars(ap.parse_args())

image_path = args['image']
# Preprocessing our input image
img = image.img_to_array(image.load_img(image_path, target_size=(299, 299))) / 255.

# this line is added because of a bug in tf_serving(1.10.0-dev)
img = img.astype('float16')

# payload = {
#     "instances": [{'image': img.tolist()}]
# }
payload = {
    "instances": [{'image': img.tolist()}, {'image': img.tolist()}] # To simulate multiple photos
}
# sending post request to TensorFlow Serving server
# r = requests.post('http://140.114.91.184:8501/v2/models/x_test:predict', json=payload)
url = args['url']+":"+args['port']
r = requests.post('http://'+url+'/v1/models/x_test:predict', json=payload)
print(r)
pred = json.loads(r.content.decode('utf-8'))

print("---------------------------------------------------------")
print("---------------------------------------------------------")
print(pred)
print("---------------------------------------------------------")
print("---------------------------------------------------------")
# Decoding the response
# decode_predictions(preds, top=5) by default gives top 5 results
# You can pass "top=10" to get top 10 predicitons
for i in range(len(pred['predictions'])):
    print("\n========  This is image {} = =======".format(i))
    print('cat = ', end="")
    print(json.dumps(pred['predictions'][i][0]))
    print('dog = ', end="")
    print(json.dumps(pred['predictions'][i][1]))
