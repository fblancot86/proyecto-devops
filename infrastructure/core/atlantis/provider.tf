# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# VAULT PROVIDER
# ------------------------------------------------------------------------------
provider "vault" {
  skip_tls_verify = true
  address      = "https://${var.vault_addr}:8200/"
  token        = var.vault_root_token
}

# AWS PROVIDER
# ------------------------------------------------------------------------------
provider "aws" {
  region     = var.region
  access_key = data.vault_generic_secret.access_key.data["access_key"]
  secret_key = data.vault_generic_secret.secret_key.data["secret_key"]
}
