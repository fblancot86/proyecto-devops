# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# Creacion de un Template para Nodos de Rancher
resource "rancher2_node_template" "template-t3a-medium-zona-a" {
  name = "template-t3a-medium-zona-a"
  description = "Rancher Node Template t3a.medium zona a"
  cloud_credential_id = rancher2_cloud_credential.aws-credentials.id
  engine_install_url  = "https://releases.rancher.com/install-docker/${var.docker_version}.sh"
  amazonec2_config {
    ami =  var.ami_id
    region = var.aws_region
    security_group = [aws_security_group.rancher_sg_allowall.name]
    subnet_id = data.aws_subnet.eu-central-1-1a.id
    vpc_id = data.aws_vpc.vpc-id-staging.id
    zone = "a"
    instance_type = "t3a.medium"
    #iam_instance_profile = var.iam_instance_profile
    #private_address_only = true
  }
}
resource "rancher2_node_template" "template-t3a-medium-zona-b" {
  name = "template-t3a-medium-zona-b"
  description = "Rancher Node Template t3a.medium zona b"
  cloud_credential_id = rancher2_cloud_credential.aws-credentials.id
  engine_install_url  = "https://releases.rancher.com/install-docker/${var.docker_version}.sh"
  amazonec2_config {
    ami =  var.ami_id
    region = var.aws_region
    security_group = [aws_security_group.rancher_sg_allowall.name]
    subnet_id = data.aws_subnet.eu-central-1-1b.id
    vpc_id = data.aws_vpc.vpc-id-staging.id
    zone = "b"
    instance_type = "t3a.medium"
    #iam_instance_profile = var.iam_instance_profile
    #private_address_only = true
  }
}
resource "rancher2_node_template" "template-t3a-medium-zona-c" {
  name = "template-t3a-medium-zona-c"
  description = "Rancher Node Template t3a.medium zona c"
  cloud_credential_id = rancher2_cloud_credential.aws-credentials.id
  engine_install_url  = "https://releases.rancher.com/install-docker/${var.docker_version}.sh"
  amazonec2_config {
    ami =  var.ami_id
    region = var.aws_region
    security_group = [aws_security_group.rancher_sg_allowall.name]
    subnet_id = data.aws_subnet.eu-central-1-1c.id
    vpc_id = data.aws_vpc.vpc-id-staging.id
    zone = "c"
    instance_type = "t3a.medium"
    #iam_instance_profile = var.iam_instance_profile
    #private_address_only = true
  }
}