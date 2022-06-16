# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# THE USER DATA SCRIPT THAT WILL RUN ON EACH CONSUL SERVER WHEN IT'S BOOTING
# This script will configure and start Consul
# ---------------------------------------------------------------------------------------------------------------------

data "template_file" "user_data_consul" {
  template = file("${path.module}/user-data-consul.sh")

  vars = {
    consul_cluster_tag_key   = var.consul_cluster_tag_key
    consul_cluster_tag_value = var.consul_cluster_name
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE CLUSTERS IN THE DEFAULT VPC AND AVAILABILITY ZONES
# Using the default VPC and subnets makes this example easy to run and test, but it means Consul and Vault are
# accessible from the public Internet. In a production deployment, we strongly recommend deploying into a custom VPC
# and private subnets.
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "default" {
  default = var.vpc_id == null ? true : false
  id      = var.vpc_id
}

data "aws_subnet_ids" "selected" {
  vpc_id = var.vpc_id
  filter {
    name   = "tag:Name"
    values = [
      "PublicSubnet10",
      "PublicSubnet11",
      "PublicSubnet12",
    ]
  }
}

# ------------------------------------------------------------------------------
# AWS DATA QUERY
# ------------------------------------------------------------------------------
/*data "aws_security_group" "sg_service_name" {
  name = var.sg_service_name
}*/
data "aws_subnet" "eu-central-1-1a" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_zone_a]
  }
}
data "aws_subnet" "eu-central-1-1b" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_zone_b]
  }
}
data "aws_subnet" "eu-central-1-1c" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_zone_c]
  }
}

data "aws_region" "current" {}

data "aws_instances" "consul_nodes" {
  filter {
    name   = "tag:Service"
    values = ["vault"]
  }
  filter {
    name   = "tag:Name"
    values = ["consul-001"]
  }
  depends_on = [module.vault_cluster, module.consul_cluster]
}

data "aws_instances" "vault_nodes" {
  filter {
    name   = "tag:Service"
    values = ["vault"]
  }
  filter {
    name   = "tag:Name"
    values = ["vault-001"]
  }
  depends_on = [module.vault_cluster, module.consul_cluster]
}