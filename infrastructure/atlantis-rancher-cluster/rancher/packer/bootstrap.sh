#!/bin/bash -x
# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

set -e

sudo tee -a /home/ubuntu/.ssh/authorized_keys <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCscT2uuSeNoOBa5Nh69v6asFXQtqcfJjyed+FU+fM3OVXkuoq0D3l6zjc7ClDTI39f6vzeQ1mV1ZmS9HYIra5K1ioztC/Yrmxa9pWmCSF5RmoHo24IzAK02+IleqBzkTR9MdF0+jYzUR7GCYy5sCvmUG6iOE27waxveNHxCR5zPgYYaPu1Ll6vVD2up0UwuaDA17pIW+0Z8nfASkvjjFQ1caIC2CdXQrsMjuJ7gm2XIKRIwhzVfXJuMyNgB0WCIT7VbRNFmgWa3hGg9+LmZOmkUCBX6l5YsEV4Qi/hVJoJcD21Y9uWsVCpaA70cbX/GX4uLtNxKArARJMwidlDo7ET
EOF

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker ubuntu
sudo chmod 666 /var/run/docker.sock
