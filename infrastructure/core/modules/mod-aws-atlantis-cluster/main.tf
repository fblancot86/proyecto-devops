# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.26"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# CREATE AN AUTO SCALING GROUP (ASG) TO RUN ATLANTIS
# ------------------------------------------------------------------------------

resource "aws_autoscaling_group" "autoscaling_group" {
  #name_prefix = var.cluster_name
  name = "asg_${var.environment}_${var.region}_${var.function}_${var.sequence}"

  launch_configuration = aws_launch_configuration.launch_configuration.name

  availability_zones  = var.availability_zones
  vpc_zone_identifier = var.subnet_ids

  # Use a fixed-size cluster
  min_size             = var.cluster_size
  max_size             = var.cluster_size
  desired_capacity     = var.cluster_size
  termination_policies = [var.termination_policies]

  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  enabled_metrics = var.enabled_metrics

  tag {
    key                 = var.cluster_tag_key
    value               = var.cluster_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.cluster_extra_tags

    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate_at_launch
    }
  }

  lifecycle {
    create_before_destroy = true

    # For further discussion and links to relevant documentation, see
    # https://github.com/hashicorp/terraform-aws-vault/issues/210
    ignore_changes = [load_balancers, target_group_arns]
  }
}

# ------------------------------------------------------------------------------
# CREATE LAUNCH CONFIGURATION TO DEFINE WHAT RUNS ON EACH INSTANCE IN THE ASG
# ------------------------------------------------------------------------------

/*resource "random_pet" "instance" {
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    ami_id = "${var.ami_id}"
  }
}*/

resource "aws_launch_configuration" "launch_configuration" {
  #name_prefix   = "${var.cluster_name}-" # Conflicts with name
  name = "lc_${var.environment}_${var.region}_${var.function}_${var.sequence}"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = var.user_data

  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  key_name             = var.ssh_key_name

  security_groups   = concat(
  [
    aws_security_group.lc_security_group.id
  ], var.additional_security_group_ids, )
  placement_tenancy = var.tenancy
  #associate_public_ip_address = var.associate_public_ip_address

  ebs_optimized = var.root_volume_ebs_optimized

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = var.root_volume_delete_on_termination
    encrypted             = var.encrypted
  }
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  # https://terraform.io/docs/configuration/resources.html
  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------------------
# CREATE A SECURITY GROUP TO CONTROL WHAT REQUESTS CAN GO IN AND OUT
# OF EACH EC2 INSTANCE
# ------------------------------------------------------------------------------

# Security group to allow all traffic
resource "aws_security_group" "lc_security_group" {
  #name_prefix = var.cluster_name
  name        = "sg_${var.environment}_${var.region}_${var.function}_${var.sequence}"
  description = "Security group for the ${var.service} launch configuration"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  # INGRESS RULES
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provide SSH"
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provides HTTP access from client web browsers"
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provides HTTPS access from client web browsers"
  }

  ingress {
    from_port   = "4141"
    to_port     = "4141"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Atlantis Ingress"
  }

  ingress {
    from_port   = "2049"
    to_port     = "2049"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NFS"
  }

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provides ping"
  }

  # EGRESS RULES / ALLOW ALL
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sg_${var.environment}_${var.region}_${var.function}_${var.sequence}"
    Creator     = var.creator
    Service     = var.service
    Team        = var.team
    Entity      = var.entity
    Environment = var.environment
  }

  /*tags = merge(
  {
    "Name" = var.cluster_name
  },
  var.security_group_tags,
  )*/

}

# ------------------------------------------------------------------------------
# ATTACH AN IAM ROLE TO EACH EC2 INSTANCE
# ------------------------------------------------------------------------------

resource "aws_iam_instance_profile" "instance_profile" {
  #name_prefix = var.cluster_name
  name = "iam_instprof_${var.environment}_${var.region}_${var.function}_${var.sequence}"
  path = var.instance_profile_path
  role = aws_iam_role.instance_role.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "instance_role" {
  #name_prefix        = var.cluster_name
  name               = "iam_role_${var.environment}_${var.region}_${var.function}_${var.sequence}"
  assume_role_policy = data.aws_iam_policy_document.instance_role.json

  permissions_boundary = var.iam_permissions_boundary

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "vault-client" {
  name   = "iam_rpolicy_${var.environment}_${var.region}_${var.function}_${var.sequence}"
  role   = aws_iam_role.instance_role.id
  policy = data.aws_iam_policy_document.vault-client.json
}

data "aws_iam_policy_document" "instance_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "vault-client" {
  statement {
    sid    = "VaultAutoJoin"
    effect = "Allow"

    actions = ["ec2:DescribeInstances"]

    resources = ["*"]
  }
}