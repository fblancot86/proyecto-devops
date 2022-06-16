# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# AWS Infrastructure Resources
/*
resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "local_file" "ssh_private_key_pem" {
  filename = "keys/id_rsa"
  sensitive_content = tls_private_key.global_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "keys/id_rsa.pub"
  content = tls_private_key.global_key.public_key_openssh
}

# Temporary key pair used for SSH accesss
resource "aws_key_pair" "rancher_key_pair" {
  key_name_prefix = "rancher-cluster-${var.entity}-${var.environment}-"
  #key_name = "rancher-cluster-${var.entity}-${var.environment}"
  public_key = tls_private_key.global_key.public_key_openssh
}
*/

resource "aws_key_pair" "rancher_key_pair" {
  key_name   = "rancher-sshkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCscT2uuSeNoOBa5Nh69v6asFXQtqcfJjyed+FU+fM3OVXkuoq0D3l6zjc7ClDTI39f6vzeQ1mV1ZmS9HYIra5K1ioztC/Yrmxa9pWmCSF5RmoHo24IzAK02+IleqBzkTR9MdF0+jYzUR7GCYy5sCvmUG6iOE27waxveNHxCR5zPgYYaPu1Ll6vVD2up0UwuaDA17pIW+0Z8nfASkvjjFQ1caIC2CdXQrsMjuJ7gm2XIKRIwhzVfXJuMyNgB0WCIT7VbRNFmgWa3hGg9+LmZOmkUCBX6l5YsEV4Qi/hVJoJcD21Y9uWsVCpaA70cbX/GX4uLtNxKArARJMwidlDo7ET"
}
# AWS EC2 instance for creating a single node RKE cluster and installing the Rancher server
resource "aws_instance" "rancher_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = aws_key_pair.rancher_key_pair.key_name
  subnet_id = data.aws_subnet.eu-central-1-1a.id
  private_ip = var.private_ip
  security_groups = [aws_security_group.rancher_sg_allowall.id]
  user_data = templatefile(
  join("/", [
    path.module, "user-data/userdata_rancher_server.template"]), {
    docker_version = var.docker_version
    username = var.node_username
  }
  )
  ebs_optimized = true
  root_block_device {
    volume_type = "gp2"
    volume_size = 16
    encrypted = true
    kms_key_id = data.vault_generic_secret.kms_key_id.data["kms_key_id"]
  }

  tags = {
    Name = "${var.entity}-rancher-server"
    Creator = var.creator
    Role = "Rancher Server"
    Team = var.team
    Environment = var.environment
    Entity = var.entity
  }
  depends_on = [aws_security_group.rancher_sg_allowall]
}

# Admin Password Generator
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Delay time to Rancher Up
resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 300"
  }
  depends_on = [aws_instance.rancher_server]
}

# Create a new rancher2_bootstrap using bootstrap provider config
resource "rancher2_bootstrap" "admin" {
  provider   = rancher2.bootstrap
  password   = random_password.password.result
  #password = var.admin_password # Optional Custom Password Var
  depends_on = [
    aws_instance.rancher_server,
    null_resource.delay
  ]

}