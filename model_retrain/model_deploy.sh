#!/bin/bash

if [[ -z $1 ]]; then
	echo "No version is given !!!"
	exit
fi

if [[ -z $2 ]]; then
	echo "Please give the dockerhub account"
	exit
fi

version=$1
DockerName=$2
mkdir -p $HOME/DL-Pipeline-Tutorial/tf-serving/x_test
cp -r $HOME/DL-Pipeline-Tutorial/saved_model/x_test/$version $HOME/DL-Pipeline-Tutorial/tf-serving/x_test/$version
sed -i "s/rest_api_port=850[0-9]/rest_api_port=850$version/" $HOME/DL-Pipeline-Tutorial/tf-serving/Dockerfile
docker build $HOME/DL-Pipeline-Tutorial/tf-serving -t $DockerName/tf-serving:v$version --no-cache
docker push $DockerName/tf-serving:v$version

# tfserving.yml -> tfserving_v#.yml
cp $HOME/DL-Pipeline-Tutorial/deploy/tfserving.yml $HOME/DL-Pipeline-Tutorial/deploy/tfserving_v$version.yml
# metadata.name
sed -i "s/tfserving-deployment.*/tfserving-deployment-v$version/" $HOME/DL-Pipeline-Tutorial/deploy/tfserving_v$version.yml
# spec.template.spec.containers.image
sed -i "s/tf-serving:v[0-9]\+/tf-serving:v$version/" $HOME/DL-Pipeline-Tutorial/deploy/tfserving_v$version.yml
# spec.template.spec.containers.ports.containerPort
sed -i "s/containerPort: 850[0-9]\+/containerPort: 850$version/" $HOME/DL-Pipeline-Tutorial/deploy/tfserving_v$version.yml
# Uncomment when the environment is KubeEdge
# spec.template.spec.containers.ports.hostPort
#sed -i "s/hostPort: 850[0-9]\+/hostPort: 850$version/" $HOME/DL-Pipeline-Tutorial/deploy/tfserving_v$version.yml
# spec.containers.image
sed -i "s/{DockerName}/$DockerName/" $HOME/DL-Pipeline-Tutorial/deploy/tfserving_v$version.yml

# tfs-service.yml -> tfs-service_v#.yml
cp $HOME/DL-Pipeline-Tutorial/deploy/tfs-service.yml $HOME/DL-Pipeline-Tutorial/deploy/tfs-service_v$version.yml
# spec.ports.port [for in-cluster]
sed -i "s/port: 850[0-9]\+/port: 850$version/" $HOME/DL-Pipeline-Tutorial/deploy/tfs-service_v$version.yml
# spec.ports.targetPort [the port of pod]
sed -i "s/targetPort: 850[0-9]\+/targetPort: 850$version/" $HOME/DL-Pipeline-Tutorial/deploy/tfs-service_v$version.yml

kubectl apply -f $HOME/DL-Pipeline-Tutorial/deploy/tfserving_v$version.yml
# You don't need to apply the tfs-service.yml, just comment it:
# 1. when the environment is KubeEdge
# 2. do not want to open the service to the whole world
kubectl apply -f $HOME/DL-Pipeline-Tutorial/deploy/tfs-service_v$version.yml

