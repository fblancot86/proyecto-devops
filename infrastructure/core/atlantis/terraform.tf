# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.26"
  #required_version = ">=1.0.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.7.0"
      version = "4.12.1"
    }
    /*vault = {
      source  = "hashicorp/vault"
      version = "3.5.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }*/
  }
}