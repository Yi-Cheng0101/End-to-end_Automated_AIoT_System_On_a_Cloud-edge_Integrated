#!/bin/bash

if [[ -z $1 ]]; then
	echo "No version is given !!!"
	exit
fi

version=$1

kubectl delete -f ~/keadm-v1.4.0-linux-amd64/keadm/tfserving_v$version.yml

