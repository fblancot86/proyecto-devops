# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# TFVARS
# Custom values of Variables
ami_id = "ami-07df0313733462994" # pkr-rancher-node-v0.0.1-1651962210
instance_type = "t3a.medium"
docker_version = "19.03"
node_username = "ubuntu"
private_ip = "172.31.10.10"
vpc_name = "keepcoding-masters"
subnet_zone_a_name = "PublicSubnet10"
subnet_zone_b_name = "PublicSubnet11"
subnet_zone_c_name = "PublicSubnet12"
entity = "keepcoding"

# VAULT
vault_ip_addr = "3.72.52.128"
#vault_token = ""

aws_region = "eu-central-1"
#iam_instance_profile = "ec2-instance-profile-staging"
k8version = "v1.20.6-rancher1-1"
/*
rancher2_ip = "18.185.188.140"
bearer_token = "token-jzh2t:n6gqzs9dqxmrljgpgt2mdh9kbblj7l644f25bb87t8nsnc8cmkvxbx"
*/
