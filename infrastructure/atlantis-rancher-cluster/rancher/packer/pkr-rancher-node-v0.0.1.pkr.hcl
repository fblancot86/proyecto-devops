# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

// AWS Packer Builder
variable "ami_name" {
  default = "pkr-rancher-node-v0.0.1"
}

source "amazon-ebs" "packerami" {
  region = "eu-central-1"

  ami_name      = "${var.ami_name}-{{timestamp}}"
  source_ami    = "ami-0d51579f02ac97d77" # Ubuntu Server 18.04 LTS (HVM), SSD Volume Type
  instance_type = "t2.micro"

  #Subnet Select
  subnet_filter {
    filters = {
      "tag:Name" : "PublicSubnet10"
    }
    #most_free = true
    #random = false
  }

  ssh_username = "ubuntu"
  tags         = {
    OS_Version        = "Ubuntu Server 18.04 LTS (HVM), SSD Volume Type"
    Release           = "Latest"
    Base_AMI_Name     = "{{ .SourceAMIName }}"
    Name              = "${var.ami_name}-{{timestamp}}"
    Creator           = "Packer"
    Team              = "IAC"
    Service           = "Rancher"
    Docker_Version    = "Docker 20.10.12"
  }
}

build {
  sources = ["source.amazon-ebs.packerami"]

  provisioner "shell" {
    script = "./bootstrap.sh"
  }
}