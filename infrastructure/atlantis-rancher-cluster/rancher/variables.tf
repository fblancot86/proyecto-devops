# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# VARS
variable "ami_id" {
  type = string
  default = "ami-07df0313733462994" # pkr-rancher-node-v0.0.1-1651962210
}
variable "instance_type" {
  type = string
  default = "t3a.medium"
}
variable "docker_version" {
  type = string
  default = "19.03"
}
variable "private_ip" {
  type = string
  default = "172.31.10.10"
}
variable "node_username" {
  type = string
  default = "ubuntu"
}
variable "vpc_name" {
  type = string
  default = "keepcoding-masters"
}
variable "subnet_zone_a_name" {
  type = string
  default = "PublicSubnet10"
}
variable "subnet_zone_b_name" {
  type = string
  default = "PublicSubnet11"
}
variable "subnet_zone_c_name" {
  type = string
  default = "PublicSubnet12"
}

# VAULT
variable "vault_ip_addr" {
  type = string
}
/*variable "vault_token" {
  type = string
}*/

# --- Cluster VARS -----------------------------------------------
variable "aws_region" {
  type = string
  default = "eu-central-1"
}
#variable "iam_instance_profile" {default = "ec2-instance-profile-staging"}
variable "k8version" {
  type = string
  default = "v1.20.6-rancher1-1"
}
/*
variable "rancher2_ip" {}
variable "bearer_token" {}
*/

# ------------------------------------------------------------------------------
# CUSTOM VARS
# You must provide a custom variables
# ------------------------------------------------------------------------------
variable "environment" {
  type    = string
  default = "nonprod" # [nonprod | prod | qa]
}
variable "creator" {
  type    = string
  default = "Terraform"
}
variable "team" {
  type    = string
  default = "IAC"
}
variable "entity" {
  type    = string
  default = "keepcoding"
}