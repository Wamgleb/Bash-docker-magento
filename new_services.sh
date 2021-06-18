#!/bin/bash

#Update
sudo apt update -y
sudo apt upgrade -y

#Install Docker
sudo apt-get remove docker docker-engine docker.io containerd runc -y
sudo apt-get install  -y apt-transport-https ca-certificates curl gnupg lsb-release
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io

echo "msg to STDERR"
echo "msg to STDOUT"

#Enable and start docker
sudo systemctl enable docker
sudo systemctl start docker

#Install Docker-Compose
sudo apt install -y python3 python3-pip
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
echo "msg to STDOUT"

#Pull Yaml file for Nginx






