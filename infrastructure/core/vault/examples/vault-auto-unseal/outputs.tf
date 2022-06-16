# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

output "asg_name_vault_cluster" {
  value = module.vault_cluster.asg_name
}

output "launch_config_name_vault_cluster" {
  value = module.vault_cluster.launch_config_name
}

output "iam_role_arn_vault_cluster" {
  value = module.vault_cluster.iam_role_arn
}

output "iam_role_id_vault_cluster" {
  value = module.vault_cluster.iam_role_id
}

output "security_group_id_vault_cluster" {
  value = module.vault_cluster.security_group_id
}

output "asg_name_consul_cluster" {
  value = module.consul_cluster.asg_name
}

output "launch_config_name_consul_cluster" {
  value = module.consul_cluster.launch_config_name
}

output "iam_role_arn_consul_cluster" {
  value = module.consul_cluster.iam_role_arn
}

output "iam_role_id_consul_cluster" {
  value = module.consul_cluster.iam_role_id
}

output "security_group_id_consul_cluster" {
  value = module.consul_cluster.security_group_id
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "vault_servers_cluster_tag_key" {
  value = module.vault_cluster.cluster_tag_key
}

output "vault_servers_cluster_tag_value" {
  value = module.vault_cluster.cluster_tag_value
}

output "ssh_key_name" {
  value = var.ssh_key_name
}

output "vault_cluster_size" {
  value = var.vault_cluster_size
}

output "launch_config_name_servers" {
  value = module.consul_cluster.launch_config_name
}

output "iam_role_arn_servers" {
  value = module.consul_cluster.iam_role_arn
}

output "iam_role_id_servers" {
  value = module.consul_cluster.iam_role_id
}

output "security_group_id_servers" {
  value = module.consul_cluster.security_group_id
}

output "consul_cluster_cluster_tag_key" {
  value = module.consul_cluster.cluster_tag_key
}

output "consul_cluster_cluster_tag_value" {
  value = module.consul_cluster.cluster_tag_value
}

/*output "consul_private_ip" {
  description = "The private IP address assigned to the instance."
  #value       = try(aws_instance.this[0].private_ip, aws_spot_instance_request.this[0].private_ip, "")
  value = try(module.consul_cluster.this[0].private_ip, "")
}

output "vault_private_ip" {
  description = "The private IP address assigned to the instance."
  value = try(module.vault_cluster.this[0].private_ip, "")
}*/

output "private-ips-consul" {
  value      = data.aws_instances.consul_nodes.private_ips
  depends_on = [data.aws_instances.consul_nodes]
}

output "private-ips-vault" {
  value      = data.aws_instances.vault_nodes.private_ips
  depends_on = [data.aws_instances.vault_nodes]
}

output "public-ips-consul" {
  value      = data.aws_instances.consul_nodes.public_ips
  depends_on = [data.aws_instances.consul_nodes]
}

output "public-ips-vault" {
  value      = data.aws_instances.vault_nodes.public_ips
  depends_on = [data.aws_instances.vault_nodes]
}

output "aws_lb_dns" {
  value = aws_lb.load_balancer.dns_name
}

output "aws_lb_dns_link" {
  value = "https://${ aws_lb.load_balancer.dns_name }:8200"
}

/*output "dns-record" {
  value = module.route53-cname-record.dns-record
}

output "dns-record-https" {
  value = "https://${module.route53-cname-record.dns-record-https}"
}

output "dns-record-https-8200" {
  value = "https://${module.route53-cname-record.dns-record-https}:8200"
}*/
