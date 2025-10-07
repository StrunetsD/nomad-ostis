#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
set -e

echo ">>> Update packages"
sudo apt-get update -y

echo ">>> Basic dependencies "
sudo apt-get install -y curl unzip gpg software-properties-common git

if ! command -v docker &> /dev/null
then
    echo ">>> Docker install"
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
    echo ">>> Docker has been installed yet"
fi

if ! command -v nomad &> /dev/null
then
    echo ">>>HashiCorp (Nomad, Consul)..."
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update -y

    sudo apt-get install -y nomad consul
else
    echo ">>> Nomad и Consul have been installed yet"
fi


echo ">>> Configuration of  Consul..."

sudo mkdir -p /etc/consul.d
sudo tee /etc/consul.d/consul.hcl > /dev/null <<EOF

datacenter = "dc1"
data_dir = "/opt/consul"
server = true
bootstrap_expect = 1
ui_config {
  enabled = true
}
client_addr = "0.0.0.0"
bind_addr = "0.0.0.0" 
EOF

echo ">>> Configuration of  Nomad..."
sudo mkdir -p /etc/nomad.d
sudo tee /etc/nomad.d/nomad.hcl > /dev/null <<EOF
datacenter = "dc1"
data_dir = "/opt/nomad"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
}
EOF

echo ">>> Launching services"
sudo systemctl enable consul
sudo systemctl start consul
sudo systemctl enable nomad
sudo systemctl start nomad

echo ">>> knowledge base clonning"
sudo rm -rf /opt/kb
sudo git clone https://github.com/ostis-ai/ims.ostis.kb.git /opt/kb

echo ">>> Nice"

