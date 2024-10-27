#!/bin/bash

# Update the package list and install dependencies
sudo apt-get update

# Install prerequisite packages
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key and repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Install Docker Compose
DOCKER_COMPOSE_VERSION="1.29.2" # Change to the desired version
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Loop through each Docker Compose file in the current directory
for COMPOSE_FILE in ./*.yml; do
  if [ -f "$COMPOSE_FILE" ]; then
    echo "Starting Docker Compose for $COMPOSE_FILE"
    sudo docker-compose -f "$COMPOSE_FILE" up -d
  fi
done

echo "All Docker Compose files are up and running!"
