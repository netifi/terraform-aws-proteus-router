#!/bin/bash

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -aG docker ubuntu


sudo tee /etc/docker/daemon.json > /dev/null << EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-file": "3",
    "max-size": "10m"
  }
}
EOF

sudo systemctl restart docker

sudo docker run \
    -d \
    --net=host \
    -e ROUTER_SERVER_OPTS='
      -Dnetifi.authentication.0.accessKey=${access_key}
      -Dnetifi.authentication.0.accessToken=${access_token}
      -Dnetifi.authentication.0.accountId=${account_id}
      ' \
    --restart=unless-stopped \
    --name proteus-router \
    netifi/proteus
