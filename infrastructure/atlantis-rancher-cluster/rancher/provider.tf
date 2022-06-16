# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# Provider
# HashiCorp Vault Provider
provider "vault" {
  skip_tls_verify = true
  address = "https://${var.vault_ip_addr}:8200"
}

# AWS Cloud Provider
provider "aws" {
  region     = var.aws_region
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
}

# Rancher Provider bootstrap config
provider "rancher2" {
  alias     = "bootstrap"
  api_url   = "https://${aws_instance.rancher_server.public_ip}"
  bootstrap = true
  insecure  = true
}
provider "rancher2" {
  alias     = "admin"
  api_url   = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
  insecure  = true
}

# Rancher
provider "rancher2" {
  insecure = true
  /*api_url = "https://${var.rancher2_ip}/v3"
  token_key = var.bearer_token*/
  api_url = "https://${aws_instance.rancher_server.public_ip}/v3"
  token_key = rancher2_bootstrap.admin.token
}