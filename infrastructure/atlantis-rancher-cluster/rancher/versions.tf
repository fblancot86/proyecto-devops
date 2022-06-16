# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    k8s = {
      source  = "banzaicloud/k8s"
      version = "0.9.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.22.2"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.3.0"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    shared_credentials_files = ["/home/atlantis/.aws/credentials"]
    profile                  = "nonprod"
  }
}