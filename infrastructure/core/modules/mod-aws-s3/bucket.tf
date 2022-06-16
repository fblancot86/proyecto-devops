# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

#------------------
# RESOURCE S3
#------------------
resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.bucket_name # IMPORTANT! Conflict with bucket_prefix
  #bucket_prefix = var.bucket_prefix # IMPORTANT! Conflict with bucket
  acl = "private"
   # Versioning Configuration
   versioning {
    enabled = var.versioning
  }

  # Encryption Configuracion for S3 Bucket
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_master_key_id
        sse_algorithm     = var.sse_algorithm
      }
    }
  }
  # TAGs of Resources
  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "s3-bucket-acl" {
  bucket = aws_s3_bucket.s3-bucket.id

  block_public_acls   = var.block_public_acls
  block_public_policy = var.block_public_policy
  restrict_public_buckets = true
  ignore_public_acls = true
}
