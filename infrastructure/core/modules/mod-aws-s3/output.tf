# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

output "s3_bucket_name" {
  value = [aws_s3_bucket.s3-bucket[*].id]
}
output "s3_bucket_region" {
  value = [aws_s3_bucket.s3-bucket[*].arn]
}