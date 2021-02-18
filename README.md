# DL-Pipeline-Tutorial
![image](https://github.com/NTHU-LSALAB/DL-Pipeline-Tutorial/blob/main/picture/system.png)
![image](https://github.com/NTHU-LSALAB/DL-Pipeline-Tutorial/blob/main/picture/MLPipeline.png)

## <h2> Environment
- Ubuntu        18.04
- Python        3.6.9       
`sudo apt-get install python3` 
- pip3          20.3.1      
`sudo apt-get install python3-pip`  
`pip3 install --upgrade pip`  
- Tensorflow    1.15.0  
`pip3 install tensorflow==1.15.0`  
- Keras         2.3.1      
`pip3 install keras==2.3.1`  
- Docker  
`Make sure that you have  installed!!`  
- Kubenetes  
`Make sure that you have installed!!`  

## <h2> Command Tutorial
![image](https://github.com/NTHU-LSALAB/DL-Pipeline-Tutorial/blob/main/picture/tutorial.png)
## <h3> Part one: 
`cd $HOME/DL-Pipeline-Tutorial/model_retrain/model`  
`wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1zwrqgdkeHkxU7mwMHTtidkPK_10kNAW7' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1zwrqgdkeHkxU7mwMHTtidkPK_10kNAW7" -O top_model_weights.h5&& rm -rf /tmp/cookies.txt`  

`model_retrain/model_retrain.sh`  

- Data is located at `model_retrain/data/`.
- `model_retrain/retrain.py` generates a new model at `model_retrain/model/`.
- Write the trainging log to file `output_<version>_<accuracy>`.This file is used to serve the website, which needs information about the model to display.
- After training a new model, the `.h5` file is copied to `saved_model/input_models/`.
- `saved_model/export_saved_model.py` generate saved model to `saved_model/x_test/`.

## <h3> Part two: 
`model_retrain/model_remove_bad_perf.sh`  
If the newest model's performance is low, you may remove it with this script.

## <h3> Part three: 
`model_retrain/model_deploy.sh`  
- Deploy a specific version model to the cluster. It writes a new yaml file at `deploy/tfserving_<version>.yml` and creates a new pod.

## <h3> Part four:
`model_retrain/model_delete.sh`  
- Remove specific version of TF serving pod.
  
## Part two and Part four is not necessary

## <h2> Overall Command
1.Download the model  
```bash
$ cd $HOME/DL-Pipeline-Tutorial/model_retrain/model
$ wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1zwrqgdkeHkxU7mwMHTtidkPK_10kNAW7' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1zwrqgdkeHkxU7mwMHTtidkPK_10kNAW7" -O top_model_weights.h5&& rm -rf /tmp/cookies.txt
```

2.Training script  
```bash
$ cd model_retrain/ && ./model_retrain.sh  
```
3.Deploy script  
```bash
$ cd model_retrain/ && sudo ./model_deploy.sh $version $DockerName
```

+ $version: model version that you generated
+ $DockerName: Dockerhub account

## <h2> Check

Check the pod is running and get the IP of pod
```
$ kubectl get pod -o wide
```
![image](https://github.com/NTHU-LSALAB/DL-Pipeline-Tutorial/blob/main/picture/pod.PNG)
Check the service and the NodePort  
```
$ kubectl get svc
```
![image](https://github.com/NTHU-LSALAB/DL-Pipeline-Tutorial/blob/main/picture/tfs-service.PNG)

## <h2> Test

1. get the metadata 

  + the node address
	```
	$ curl $NodeIP:$NodePort/v1/models/x_test/metadata
	```
  + the pod address
	```
	$ curl $PodIP:$Port/v1/models/x_test/metadata
	```
  ![image](https://github.com/NTHU-LSALAB/DL-Pipeline-Tutorial/blob/main/picture/metadata.PNG)

2. predict the picture

```bash
$ python3 test/client.py -i $picture -u $ip -p $port
```
  ![image](https://github.com/NTHU-LSALAB/DL-Pipeline-Tutorial/blob/main/picture/test_client.PNG)
