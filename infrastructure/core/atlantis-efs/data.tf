# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# VAULT CREDENTIALS
# ------------------------------------------------------------------------------
data "vault_generic_secret" "access_key" {
  path = "cloud/aws/keepcoding/${var.environment}/access_key"
}
data "vault_generic_secret" "secret_key" {
  path = "cloud/aws/keepcoding/${var.environment}/secret_key"
}
data "vault_generic_secret" "kms_key_id" {
  path = "cloud/aws/keepcoding/${var.environment}/kms_key_id"
}