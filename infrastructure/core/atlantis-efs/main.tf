# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CREATE A EFS TO SHARE DATA SHARE DATA BETWEEN SERVICES
# ------------------------------------------------------------------------------
resource "aws_efs_file_system" "default" {
  count            = 1
  encrypted        = var.encrypted
  #kms_key_id       = data.vault_generic_secret.kms_key_id.data["kms_key_id"]
  performance_mode = var.performance_mode
  #provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode  = var.throughput_mode
  tags             = {
    Name     = "efs_${var.environment}_${var.region}_001"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
  }

}

# ------------------------------------------------------------------------------
# CREATE A SECURITY GROUP TO CONTROL WHAT REQUESTS CAN GO IN AND OUT
# OF EFS INSTANCE
# ------------------------------------------------------------------------------
resource "aws_security_group" "efs" {
  name        = "sg_${var.environment}_${var.region}_efs_001"
  description = "Security group for EFS Storage"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port   = "2049"
    to_port     = "2049"
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
    description = "Allow NFS Ingress"
  }

  # EGRESS RULES / ALLOW ALL
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sg_${var.environment}_${var.region}_efs_001"
    Environment = var.environment
    Creator     = var.creator
    Team        = var.team
    Entity      = var.entity
  }
}
# ------------------------------------------------------------------------------
# CREATE MOUNT TARGET TO EFS VOLUME
# ------------------------------------------------------------------------------
resource "aws_efs_mount_target" "default" {
  count           = length(var.subnets)
  file_system_id  = join("", aws_efs_file_system.default.*.id)
  subnet_id       = var.subnets[count.index]
  security_groups = [aws_security_group.efs.id]
}