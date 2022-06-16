# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name of the Atlantis cluster (e.g. atlantis-stage). This variable is used to namespace all resources created by this module."
}

variable "ami_id" {
  description = "The ID of the AMI to run in this cluster. Should be an AMI that had Atlantis installed and configured by the install-atlantis module."
}

variable "instance_type" {
  description = "The type of EC2 Instances to run for each node in the cluster (e.g. t2.micro)."
}

variable "encrypted" {
  type = bool
  default = null
}

variable "vpc_id" {
  description = "The ID of the VPC in which to deploy the cluster"
}

variable "region" {
  type = string
  default = "eu-central-1"
}

variable "allowed_inbound_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow connections to Atlantis"
  type        = list(string)
}

variable "allowed_inbound_security_group_ids" {
  description = "A list of security group IDs that will be allowed to connect to Atlantis"
  type        = list(string)
}

variable "allowed_inbound_security_group_count" {
  description = "The number of entries in var.allowed_inbound_security_group_ids. Ideally, this value could be computed dynamically, but we pass this variable to a Terraform resource's 'count' property and Terraform requires that 'count' be computed with literals or data sources only."
}

variable "user_data" {
  description = "A User Data script to execute while the server is booting. We recommend passing in a bash script that executes the run-atlantis script, which should have been installed in the AMI by the install-atlantis module."
}

variable "cluster_size" {
  description = "The number of nodes to have in the cluster. We strongly recommend setting this to 3 or 5."
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "subnet_ids" {
  description = "The subnet IDs into which the EC2 Instances should be deployed. You should typically pass in one subnet ID per node in the cluster_size variable. We strongly recommend that you run Atlantis in private subnets. At least one of var.subnet_ids or var.availability_zones must be non-empty."
  type        = list(string)
  default     = null
}

variable "availability_zones" {
  description = "The availability zones into which the EC2 Instances should be deployed. You should typically pass in one availability zone per node in the cluster_size variable. We strongly recommend against passing in only a list of availability zones, as that will run Atlantis in the default (and most likely public) subnets in your VPC. At least one of var.subnet_ids or var.availability_zones must be non-empty."
  type        = list(string)
  default     = null
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  default     = ""
}

variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the EC2 Instances will allow SSH connections"
  type        = list(string)
  default     = []
}

variable "allowed_ssh_security_group_ids" {
  description = "A list of security group IDs from which the EC2 Instances will allow SSH connections"
  type        = list(string)
  default     = []
}

variable "additional_security_group_ids" {
  description = "A list of additional security group IDs to add to Atlantis EC2 Instances"
  type        = list(string)
  default     = []
}

variable "security_group_tags" {
  description = "Tags to be applied to the LC security group"
  type        = map(string)
  default     = {}
}

variable "cluster_tag_key" {
  description = "Add a tag with this key and the value var.cluster_name to each Instance in the ASG."
  default     = "Name"
}

variable "cluster_extra_tags" {
  description = "A list of additional tags to add to each Instance in the ASG. Each element in the list must be a map with the keys key, value, and propagate_at_launch"
  type        = list(object({
    key : string, value : string, propagate_at_launch : bool
  }))

  default = []
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default."
  default     = "Default"
}

variable "tenancy" {
  description = "The tenancy of the instance. Must be one of: default or dedicated."
  default     = "default"
}

variable "root_volume_ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized."
  default     = false
}

variable "root_volume_type" {
  description = "The type of volume. Must be one of: standard, gp2, or io1."
  default     = "standard"
}

variable "root_volume_size" {
  description = "The size, in GB, of the root EBS volume."
  default     = 16
}

variable "root_volume_delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination."
  default     = true
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  default     = "10m"
}

variable "health_check_type" {
  description = "Controls how health checking is done. Must be one of EC2 or ELB."
  default     = "EC2"
}

variable "health_check_grace_period" {
  description = "Time, in seconds, after instance comes into service before checking health."
  default     = 300
}

variable "instance_profile_path" {
  description = "Path in which to create the IAM instance profile."
  default     = "/"
}

variable "ssh_port" {
  description = "The port used for SSH connections."
  default     = 22
}

variable "enabled_metrics" {
  description = "List of autoscaling group metrics to enable."
  type        = list(string)
  default     = []
}

variable "iam_permissions_boundary" {
  description = "If set, restricts the created IAM role to the given permissions boundary"
  type        = string
  default     = null
}

# ------------------------------------------------------------------------------
# CUSTOM VARS
# You must provide a custom variables
# ------------------------------------------------------------------------------

variable "environment" {
  type = string
  #default = null # [nonprod | prod | qa]
}
variable "creator" {
  type = string
  #default = null
}
variable "team" {
  type = string
  #default = null
}
variable "entity" {
  type = string
  #default = null
}
variable "sequence" {
  type = string
  #default = null
}
variable "service" {
  type = string
  #default = null
}
variable "function" {
  type = string
  #default = null
}
variable "kms_key_id" {
  #default = null
}
#variable "associate_public_ip_address" {}