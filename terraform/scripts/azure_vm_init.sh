#!/bin/bash

## Install Docker

echo "Starting azure_vm_init.sh execution"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
docker run hello-world
usermod -aG docker ubuntu
newgrp docker

systemctl enable docker.service
systemctl enable containerd.service

## Run demo web application

docker run -p 80:3000 -e "RESPONSE_MESSAGE=Hello from Azure west-europe" stephengreer08/demo-web-server

echo "Completed azure_vm_init.sh execution"
