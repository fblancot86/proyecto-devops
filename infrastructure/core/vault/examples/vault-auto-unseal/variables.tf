# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "region" {
  type = string
  default = "eu-central-1"
}

variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}

variable "ami_id" {
  description = "The ID of the AMI to run in the cluster. This should be an AMI built from the Packer template under examples/vault-consul-ami/vault-consul.json."
  type        = string
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  type        = string
}

variable "auto_unseal_kms_key_alias" {
  description = "The alias of AWS KMS key used for encryption and decryption"
  type        = string
}

variable "subnet_ids" {
  type = list(any)
}

variable "subnet_zone_a" {
  type = string
  default = "PublicSubnet10"
}
variable "subnet_zone_b" {
  type = string
  default = "PublicSubnet11"
}
variable "subnet_zone_c" {
  type = string
  default = "PublicSubnet12"
}

variable "route53_zone_id" {
  type = string
  default = null
}

variable "acm_cert_arn" {
  type = string
  default = null
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "vault_cluster_name" {
  description = "What to name the Vault server cluster and all of its associated resources"
  type        = string
  default     = "vault-cluster"
}

variable "consul_cluster_name" {
  description = "What to name the Consul server cluster and all of its associated resources"
  type        = string
  default     = "consul-cluster"
}

variable "auth_server_name" {
  description = "What to name the server authenticating to vault"
  type        = string
  default     = "auth-example"
}

variable "vault_cluster_size" {
  description = "The number of Vault server nodes to deploy. We strongly recommend using 3 or 5."
  type        = number
  default     = 3
}

variable "consul_cluster_size" {
  description = "The number of Consul server nodes to deploy. We strongly recommend using 3 or 5."
  type        = number
  default     = 3
}

variable "vault_instance_type" {
  description = "The type of EC2 Instance to run in the Vault ASG"
  type        = string
  default     = "t2.micro"
}

variable "consul_instance_type" {
  description = "The type of EC2 Instance to run in the Consul ASG"
  type        = string
  default     = "t2.nano"
}

variable "consul_cluster_tag_key" {
  description = "The tag the Consul EC2 Instances will look for to automatically discover each other and form a cluster."
  type        = string
  default     = "consul-servers"
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy into. Leave an empty string to use the Default VPC in this region."
  type        = string
}

variable "cluster_extra_tags" {
  description = "A list of additional tags to add to each Instance in the ASG. Each element in the list must be a map with the keys key, value, and propagate_at_launch"
  type        = list(object({ key : string, value : string, propagate_at_launch : bool }))

  default = []
}

# ---

variable "environment" {
  type = string
  default = "nonprod" # [nonprod | prod | qa]
}
variable "creator" {
  type = string
  default = "Terraform"
}
variable "team" {
  type = string
  default = "IAC"
}
variable "entity" {
  type = string
  default = "KeepCoding"
}
variable "sequence" {
  type = string
  default = "001"
}
variable "service" {
  type = string
  default = "vault"
}
variable "function" {
  type = string
  default = "vlt"
}

variable "aws_lb_name" {
  type = string
  default = "elb-nonprod-eu-central-1-vlt-001"
}

variable "internal" {
  type = bool
  default = true
}

variable "load_balancer_type" {
  type = string
  default = "application"
}

variable "enable_deletion_protection" {
  type = bool
  default = true
}

variable "target-port" {
  type = number
  default = 8200
}

variable "target-protocol" {
  type = string
  default = "HTTPS" # [HTTP | HTTPS]
}

variable "target-type" {
  type = string
  default = "instance" # [instance | application | ip]
}

variable "listener-port" {
  type = number
  default = 80
}

variable "listener-protocol" {
  type = string
  default = "HTTPS"
}

variable "listener-default-action-type" {
  type = string
  default = "forward" # [forward | redirect]
}

variable "lb_port_443" {
  description = "The port the load balancer should listen on for API requests."
  default     = 443
}

variable "lb_port_8200" {
  description = "The port the load balancer should listen on for API requests."
  default     = 8200
}

variable "security_group_tags" {
  description = "Tags to be applied to the ELB security group."
  type        = map(string)
  default     = {
    "Creator"     = "Terraform"
    "Team"        = "IAC"
    "Environment" = "nonprod"
    "Entity"      = "KeepCoding"
    "Service"     = "vault"
  }
}

variable "allowed_inbound_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the ELB will accept requests."
  type        = list(string)
  default     = [
    /*"172.31.10.0/24",
    "172.31.11.0/24",
    "172.31.12.0/24",*/
    "0.0.0.0/0"
  ]
}

variable "allowed_outbound_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the ELB will accept requests."
  type        = list(string)
  default     = [
    /*"172.31.10.0/24",
    "172.31.11.0/24",
    "172.31.12.0/24",*/
    "0.0.0.0/0"
  ]
}