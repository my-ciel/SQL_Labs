#!/bin/bash
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# Add Docker APT repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# Update the package list again
apt-get update -y
# Install Docker CE
apt-get install -y docker-ce
# Start Docker service
systemctl start docker
# Enable Docker service to start on boot
systemctl enable docker
# Add ubuntu user to the docker group
usermod -aG docker ubuntu
# Install Git
apt-get install -y git

