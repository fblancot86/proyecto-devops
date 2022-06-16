# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "ami_id" {
  description = "The ID of the AMI to run in the cluster."
  type        = string
  default     = "ami-0b92c5e6d4637a3f7"
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  type        = string
  default     = "iac-nonprod"
}

variable "subnet_ids" {
  type    = list(any)
  default = [
    "subnet-0e122e2c429bffb8e",
    "subnet-09df7861c30494169",
    "subnet-0a2b458e6fc835474",
  ]
}

variable "subnet_zone_a" {
  type    = string
  default = "PublicSubnet10"
}
variable "subnet_zone_b" {
  type    = string
  default = "PublicSubnet11"
}
variable "subnet_zone_c" {
  type    = string
  default = "PublicSubnet12"
}

/*variable "route53_zone_id" {
  type = string
  default = null
}*/

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "atlantis_cluster_name" {
  description = "What to name the Vault server cluster and all of its associated resources"
  type        = string
  default     = "atlantis-001"
}

variable "atlantis_cluster_size" {
  description = "The number of Vault server nodes to deploy. We strongly recommend using 3 or 5."
  type        = number
  default     = 1
}

variable "atlantis_instance_type" {
  description = "The type of EC2 Instance to run in the Vault ASG"
  type        = string
  default     = "t2.micro"
}

variable "encrypted" {
  type = bool
  default = false
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy into. Leave an empty string to use the Default VPC in this region."
  type        = string
  default     = "vpc-0726c3e67dfe1631a"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "cluster_extra_tags" {
  description = "A list of additional tags to add to each Instance in the ASG. Each element in the list must be a map with the keys key, value, and propagate_at_launch"
  type        = list(object({ key : string, value : string, propagate_at_launch : bool }))

  default = [
    {
      key                 = "Creator"
      value               = "Terraform"
      propagate_at_launch = true
    }, {
      key                 = "Team"
      value               = "IAC"
      propagate_at_launch = true
    }, {
      key                 = "Environment"
      value               = "nonprod"
      propagate_at_launch = true
    }, {
      key                 = "Entity"
      value               = "keepcoding"
      propagate_at_launch = true
    }, {
      key                 = "Service"
      value               = "atlantis"
      propagate_at_launch = true
    }
  ]
}

# ------------------------------------------------------------------------------
# CUSTOM VARS
# You must provide a custom variables
# ------------------------------------------------------------------------------
variable "environment" {
  type    = string
  default = "nonprod" # [nonprod | prod | qa]
}
variable "creator" {
  type    = string
  default = "Terraform"
}
variable "team" {
  type    = string
  default = "IAC"
}
variable "entity" {
  type    = string
  default = "keepcoding"
}
variable "sequence" {
  type    = string
  default = "001"
}
variable "service" {
  type    = string
  default = "atlantis"
}
variable "function" {
  type    = string
  default = "atl"
}

# ------------------------------------------------------------------------------
# CUSTOM VARS ELB
# ------------------------------------------------------------------------------
variable "internal" {
  type    = bool
  default = false
}
variable "load_balancer_type" {
  type    = string
  default = "application"
}
variable "target-port" {
  type    = number
  default = 4141
}
variable "target-protocol" {
  type    = string
  default = "HTTP" # [HTTP | HTTPS]
}
variable "target-type" {
  type    = string
  default = "instance" # [instance | application | ip]
}
variable "listener-port" {
  type    = number
  default = 80
}
variable "listener-protocol" {
  type    = string
  default = "HTTP"
}
variable "listener-default-action-type" {
  type    = string
  default = "forward" # [forward | redirect]
}
variable "acm_cert_arn" {
  type = string
  default = null
}
# ------------------------------------------------------------------------------
# CUSTOM VAULT VARS
# ------------------------------------------------------------------------------
variable "vault_addr" {
  type = string
}
variable "vault_root_token" {
  type = string
}
variable "vault_app_role_name" {
  type = string
}

# ------------------------------------------------------------------------------
# CUSTOM TEMPLATE VARS
# ------------------------------------------------------------------------------
# ATLANTIS
variable "atlantis_version" {
  type = string
  default = "0.18.2"
}
# CUSTOM RUN COMMANDS VARS
# REF: https://www.runatlantis.io/docs/custom-workflows.html#custom-run-command

# AWS EFS
variable "efs_id" {
  type = string
}

# BACKEND AWS
variable "bucket_name" {
  type = string
}
variable "dynamo_name" {
  type = string
}
