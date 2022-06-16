# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# Backend Remote Terraform State Configuration
# bucket: S3 Bucket ID
# key: file or directory/file path to save ej: testdir/terraform.tfstate
# dynamodb_table: Table in AWS DynamoDB created with "LockID" Main Key
# To force unlock the state excecute follow command
# terraform init -backend-config.yaml="access_key=<ID>" -backend-config.yaml="secret_key=<ID>"
terraform {
  backend "s3" {
    bucket         = "keepcoding-masters-nonprod"
    dynamodb_table = "state-lock-keepcoding-masters"
    key            = "environments/nonprod/atlantis/atlantis-asg.tfstate"
    region         = "eu-central-1"
  }
}
