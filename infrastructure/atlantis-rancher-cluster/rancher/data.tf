# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# Data sources

# VAULT / AWS CLOUD PROVIDER CREDENTIALS
# ----------------------------------------------------------
# SECRETS FROM AWS SECRET ENGINE / VAULT
data "vault_aws_access_credentials" "creds" {
  backend = "aws"
  role = "aws-iam-credentials"
  type = "creds"
}

# AWS CLOUD PROVIDER CREDENTIALS
# ----------------------------------------------------------
data "vault_generic_secret" "access_key" {
  path = "cloud/aws/${var.entity}/${var.environment}/access_key"
}
data "vault_generic_secret" "secret_key" {
  path = "cloud/aws/${var.entity}/${var.environment}/secret_key"
}
data "vault_generic_secret" "kms_key_id" {
  path = "cloud/aws/${var.entity}/${var.environment}/kms_key_id"
}

# AWS Infrastructure Data
# ----------------------------------------------------------
data "aws_vpc" "vpc-id-staging" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "eu-central-1-1a" {
  filter {
    name   = "tag:Name"
    values = ["${var.subnet_zone_a_name}"]
  }
}
data "aws_subnet" "eu-central-1-1b" {
  filter {
    name   = "tag:Name"
    values = ["${var.subnet_zone_b_name}"]
  }
}
data "aws_subnet" "eu-central-1-1c" {
  filter {
    name   = "tag:Name"
    values = ["${var.subnet_zone_c_name}"]
  }
}

# Use latest Ubuntu 18.04 AMI
# ----------------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}