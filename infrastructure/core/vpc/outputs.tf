# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

output "vpc_id" {
  value = aws_vpc.keepcoding.id
}
output "subnet10_id" {
  value = aws_subnet.public_subnet_10.id
}
output "subnet11_id" {
  value = aws_subnet.public_subnet_11.id
}
output "subnet12_id" {
  value = aws_subnet.public_subnet_12.id
}