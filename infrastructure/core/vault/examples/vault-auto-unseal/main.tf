# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  # This module is now only being tested with Terraform 1.0.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 1.0.x code.
  #required_version = ">= 0.12.26"
  required_version = ">= 1.1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = ">= 2.7.0"
      version = "= 4.11.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "= 2.2.0"
    }
  }
}

data "aws_kms_alias" "vault-example" {
  name = "alias/${var.auto_unseal_kms_key_alias}"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE VAULT SERVER CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

module "vault_cluster" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  #source = "github.com/hashicorp/terraform-aws-vault.git//modules/vault-cluster?ref=v0.0.1"
  source = "../../modules/vault-cluster"

  cluster_name  = var.vault_cluster_name
  cluster_size  = var.vault_cluster_size
  instance_type = var.vault_instance_type

  ami_id    = var.ami_id
  user_data = data.template_file.user_data_vault_cluster.rendered

  #vpc_id     = data.aws_vpc.default.id
  vpc_id     = var.vpc_id
  #subnet_ids         = data.aws_subnet_ids.default.ids
  subnet_ids = data.aws_subnet_ids.selected.ids
  #subnet_ids = var.subnet_ids
  #availability_zones = var.az

  # This setting will create the AWS policy that allows the vault cluster to
  # access KMS and use this key for encryption and decryption
  enable_auto_unseal = true

  auto_unseal_kms_key_arn = data.aws_kms_alias.vault-example.target_key_arn

  # To make testing easier, we allow requests from any IP address here but in a production deployment, we *strongly*
  # recommend you limit this to the IP address ranges of known, trusted servers inside your VPC.

  allowed_ssh_cidr_blocks              = ["0.0.0.0/0"]
  allowed_inbound_cidr_blocks          = ["0.0.0.0/0"]
  allowed_inbound_security_group_ids   = []
  allowed_inbound_security_group_count = 0
  ssh_key_name                         = var.ssh_key_name
  cluster_extra_tags                   = var.cluster_extra_tags
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH IAM POLICIES FOR CONSUL
# To allow our Vault servers to automatically discover the Consul servers, we need to give them the IAM permissions from
# the Consul AWS Module's consul-iam-policies module.
# ---------------------------------------------------------------------------------------------------------------------

module "consul_iam_policies_servers" {
  #source = "github.com/hashicorp/terraform-aws-consul.git//modules/consul-iam-policies?ref=v0.8.0"
  source = "../../modules/consul-iam-policies"

  iam_role_id = module.vault_cluster.iam_role_id
}

# ---------------------------------------------------------------------------------------------------------------------
# THE USER DATA SCRIPT THAT WILL RUN ON EACH VAULT SERVER WHEN IT'S BOOTING
# This script will configure and start Vault
# ---------------------------------------------------------------------------------------------------------------------

data "template_file" "user_data_vault_cluster" {
  template = file("${path.module}/user-data-vault.sh")

  vars = {
    consul_cluster_tag_key   = var.consul_cluster_tag_key
    consul_cluster_tag_value = var.consul_cluster_name
    kms_key_id               = data.aws_kms_alias.vault-example.target_key_id
    aws_region               = data.aws_region.current.name
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# PERMIT CONSUL SPECIFIC TRAFFIC IN VAULT CLUSTER
# To allow our Vault servers consul agents to communicate with other consul agents and participate in the LAN gossip,
# we open up the consul specific protocols and ports for consul traffic
# ---------------------------------------------------------------------------------------------------------------------

module "security_group_rules" {
  #source = "github.com/hashicorp/terraform-aws-consul.git//modules/consul-client-security-group-rules?ref=v0.8.0"
  source = "../../modules/consul-client-security-group-rules"

  security_group_id = module.vault_cluster.security_group_id

  # To make testing easier, we allow requests from any IP address here but in a production deployment, we *strongly*
  # recommend you limit this to the IP address ranges of known, trusted servers inside your VPC.

  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]

}

# ------------------------------------------------------------------------------
# DEPLOY THE CONSUL SERVER CLUSTER
# ------------------------------------------------------------------------------

module "consul_cluster" {
  #source = "github.com/hashicorp/terraform-aws-consul.git//modules/consul-cluster?ref=v0.8.0"
  # To use follow module path we need to refactor path to other modules
  source = "../../modules/consul-cluster"

  cluster_name  = var.consul_cluster_name
  cluster_size  = var.consul_cluster_size
  instance_type = var.consul_instance_type

  # The EC2 Instances will use these tags to automatically discover each other and form a cluster
  cluster_tag_key   = var.consul_cluster_tag_key
  cluster_tag_value = var.consul_cluster_name

  ami_id    = var.ami_id
  user_data = data.template_file.user_data_consul.rendered

  #vpc_id     = data.aws_vpc.default.id
  vpc_id     = var.vpc_id
  #subnet_ids = data.aws_subnet_ids.default.ids
  subnet_ids = data.aws_subnet_ids.selected.ids
  #subnet_ids = var.subnet_ids
  #availability_zones = var.az

  # To make testing easier, we allow Consul and SSH requests from any IP address here but in a production
  # deployment, we strongly recommend you limit this to the IP address ranges of known, trusted servers inside your VPC.

  allowed_ssh_cidr_blocks     = ["0.0.0.0/0"]
  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  ssh_key_name                = var.ssh_key_name
  tags                        = var.cluster_extra_tags
}