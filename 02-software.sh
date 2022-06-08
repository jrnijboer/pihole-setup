#!/bin/bash
echo "-- Install required packages"
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    dirmngr \
    vim 
echo""

echo "-- Add Hashicorp repo"
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
apt-add-repository "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main"
echo ""

echo "-- Add docker repo"
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" |tee /etc/apt/sources.list.d/docker.list > /dev/null
echo ""

echo "-- Install packages (consul, nomad, vault, docker)"
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin nomad consul vault ufw tmux jq
echo ""
