# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# Output Sensitive Information
output "rancher_public_ip" {
  value = aws_instance.rancher_server.public_ip
}
output "rancher_admin_password" {
  value = nonsensitive(random_password.password.result)
}
output "rancher_admin_url" {
  value = rancher2_bootstrap.admin.url
}
output "rancher_admin_url2" {
  value = rancher2_bootstrap.admin.url
}