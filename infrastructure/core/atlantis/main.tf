# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# DEPLOY THE ATLANTIS SERVER CLUSTER
# ------------------------------------------------------------------------------

module "atlantis_cluster" {
  source = "../modules/mod-aws-atlantis-cluster"

  cluster_name  = var.atlantis_cluster_name
  cluster_size  = var.atlantis_cluster_size
  instance_type = var.atlantis_instance_type

  ami_id    = var.ami_id
  user_data = data.template_file.user_data_atlantis_cluster.rendered

  vpc_id = data.aws_vpc.default.id
  subnet_ids = var.subnet_ids

  kms_key_id = data.vault_generic_secret.kms_key_id.data["kms_key_id"]

  encrypted = var.encrypted

  allowed_ssh_cidr_blocks              = ["0.0.0.0/0"]
  allowed_inbound_cidr_blocks          = ["0.0.0.0/0"]
  allowed_inbound_security_group_ids   = []
  allowed_inbound_security_group_count = 0
  ssh_key_name                         = var.ssh_key_name
  cluster_extra_tags                   = var.cluster_extra_tags

  environment = var.environment
  region      = var.region
  creator     = var.creator
  team        = var.team
  entity      = var.entity
  sequence    = var.sequence
  service     = var.service
  function    = var.function

}

