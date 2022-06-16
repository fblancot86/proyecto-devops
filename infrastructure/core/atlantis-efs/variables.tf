# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

variable "vpc_id" {
  type        = string
  default = "vpc-0726c3e67dfe1631a"
}
variable "region" {
  type    = string
  default = "eu-central-1"
}
/*variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}*/
variable "subnets" {
  type    = list(string)
  default = [
    "subnet-0e122e2c429bffb8e",
    "subnet-09df7861c30494169",
    "subnet-0a2b458e6fc835474",
  ]
}
variable "encrypted" {
  type    = bool
  default = true
}
variable "performance_mode" {
  type    = string
  default = "generalPurpose"
}
variable "throughput_mode" {
  type    = string
  default = "bursting"
}
variable "availability_zone_name" {
  type    = list(string)
  default = ["eu-central-1a","eu-central-1b","eu-central-1c"]
}
variable "environment" {
  type = string
  default = "nonprod" # [nonprod | prod | qa]
}
variable "creator" {
  type = string
  default = "Terraform"
}
variable "team" {
  type = string
  default = "IAC"
}
variable "entity" {
  type = string
  default = "KeepCoding"
}

# ------------------------------------------------------------------------------
# CUSTOM VAULT VARS
# ------------------------------------------------------------------------------
variable "vault_addr" {
  type = string
}
variable "vault_root_token" {
  type = string
}