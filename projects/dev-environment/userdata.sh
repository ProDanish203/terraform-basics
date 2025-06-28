#!/bin/bash

# Update system packages
sudo apt-get update -y &&
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common &&

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&

# Update package index
sudo apt-get update -y &&

# Install Docker Engine
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &&

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add ubuntu user to docker group (allows running docker without sudo)
sudo usermod -aG docker ubuntu

# Install Docker Compose (standalone version for compatibility)
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create symbolic link for docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Log installation completion
echo "$(date): System updated and Docker installed successfully" >> /var/log/userdata.log

# Verify Docker installation
docker --version >> /var/log/userdata.log
docker-compose --version >> /var/log/userdata.log

# Create a test container to verify Docker is working
sudo docker run hello-world >> /var/log/userdata.log 2>&1

echo "$(date): User data script execution completed" >> /var/log/userdata.log