#!/bin/bash

## Install Docker

yum update
yum -y install docker
systemctl enable docker.service
systemctl start docker.service

## Run demo web application

docker run -p 80:3000 -e "RESPONSE_MESSAGE=Hello from AWS us-west-2" stephengreer08/demo-web-server
