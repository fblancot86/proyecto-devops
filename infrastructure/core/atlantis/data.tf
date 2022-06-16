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
# ------------------------------------------------------------------------------
# GIT (GitHub)
data "vault_generic_secret" "git_user" {
  path = "cloud/github/keepcoding/user"
}
data "vault_generic_secret" "git_token" {
  path = "cloud/github/keepcoding/token"
}
# ------------------------------------------------------------------------------
# SERVICE (ATLANTIS)
data "vault_generic_secret" "atlantis-webhook" {
  path = "cloud/aws/keepcoding/nonprod/service/atlantis/git-webhook-secret"
}
/*data "vault_generic_secret" "atlantis-cert-acm" {
  path = "cloud/aws/keepcoding/nonprod/service/atlantis/acm_cert"
}*/
# ------------------------------------------------------------------------------
# AWS DATA QUERY
# ------------------------------------------------------------------------------

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

data "aws_instances" "atlantis_nodes" {
  filter {
    name   = "tag:Service"
    values = ["atlantis"]
  }
  filter {
    name   = "tag:Name"
    values = ["atlantis-001"]
  }
  depends_on = [module.atlantis_cluster]
}

# ------------------------------------------------------------------------------
# THE USER DATA SCRIPT THAT WILL RUN ON EACH SERVER WHEN IT'S BOOTING
# ------------------------------------------------------------------------------
data "template_file" "user_data_atlantis_cluster" {
  template = file("${path.module}/user-data-atlantis.sh")

  vars = {
    tpl_aws_region = var.region
    tpl_access_key = data.vault_generic_secret.access_key.data["access_key"]
    tpl_secret_key = data.vault_generic_secret.secret_key.data["secret_key"]
    tpl_vault_server_addr = var.vault_addr
    tpl_vault_root_token = var.vault_root_token
    tpl_app_role = var.vault_app_role_name
    tpl_iam_role_arn_atlantis_cluster = module.atlantis_cluster.iam_role_arn
    tpl_atlantis_version = var.atlantis_version
    tpl_git-user = data.vault_generic_secret.git_user.data["user"]
    tpl_git-token = data.vault_generic_secret.git_token.data["token"]
    tpl_git-webhook-secret = data.vault_generic_secret.atlantis-webhook.data["secret"]
    tpl_efs_id = var.efs_id
    tpl_bucket-name = var.bucket_name
    tpl_dynamo-name = var.dynamo_name
  }
}

# ------------------------------------------------------------------------------
# DEPLOY THE CLUSTERS IN THE DEFAULT VPC AND AVAILABILITY ZONES
# ------------------------------------------------------------------------------
data "aws_vpc" "default" {
  default = var.vpc_id == null ? true : false
  id      = var.vpc_id
}

data "aws_region" "current" {}