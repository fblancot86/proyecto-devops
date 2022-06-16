# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

variable "region" {
  type    = string
  default = "eu-central-1"
}
variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}

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