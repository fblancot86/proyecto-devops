# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# AWS module to create S3 Object
module "s3" {
  source            = "../modules/mod-aws-s3"
  aws_region        = var.region
  bucket_name       = "keepcoding-masters-${var.environment}" # IMPORTANT! Conflict with bucket_prefix
  #bucket_prefix     = "core-" # IMPORTANT! Conflict with bucket
  count             = 1
  #kms_master_key_id = var.kms_master_key_id
  tags              = {
    Name        = "keepcoding-masters-${var.environment}"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
  }
}
# AWS DynamoDB Resource
module "dynamodb_table" {
  source     = "../modules/mod-aws-dynamodb"
  aws_region = var.region
  count      = 1

  name     = "state-lock-keepcoding-masters"
  hash_key = "LockID"

  read_capacity  = 20
  write_capacity = 20

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  tags = {
    Name        = "state-lock-keepcoding-masters"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
  }
}