#!/bin/bash


#
# Installation 
#
sudo apt-get update -y;
apt-get install -y firewalld;
systemctl enable firewalld;
systemctl start firewalld;
firewall-cmd --add-port=80/tcp --permanent;
firewall-cmd --add-port=443/tcp --permanent;
firewall-cmd --add-port=51920/udp --permanent;
firewall-cmd --add-port=51820/udp --permanent;
firewall-cmd --add-port=53/udp --permanent;
firewall-cmd --add-port=67/udp --permanent;
firewall-cmd --add-port=8000/tcp --permanent;
firewall-cmd --add-port=9000/tcp --permanent;

firewall-cmd --add-masquerade --permanent;
systemctl restart firewalld;

# Prereqs and docker
sudo apt-get update &&
    sudo apt-get install -yqq \
        curl \
        git \
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        software-properties-common

# Install Docker repository and keys
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable" &&
    sudo apt-get update &&
    sudo apt-get install docker-ce docker-ce-cli containerd.io -yqq

# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
    sudo chmod +x /usr/local/bin/docker-compose &&
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    
cd /var/lib/docker    

# wirehole
git clone https://github.com/layen67/wirehole-1.git &&
    cd wirehole &&
    docker-compose up -d
    
sleep 10
apt update;
apt install wireguard -y;
apt install openresolv -y;
touch /etc/wireguard/wg0.conf


docker run -d -p 9000:9000 -p 8000:8000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
