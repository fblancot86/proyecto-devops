# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

output "asg_name_atlantis_cluster" {
  value = module.atlantis_cluster.asg_name
}

output "launch_config_name_atlantis_cluster" {
  value = module.atlantis_cluster.launch_config_name
}

output "iam_role_arn_atlantis_cluster" {
  value = module.atlantis_cluster.iam_role_arn
}

output "iam_role_id_atlantis_cluster" {
  value = module.atlantis_cluster.iam_role_id
}

output "security_group_id_atlantis_cluster" {
  value = module.atlantis_cluster.security_group_id
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "atlantis_servers_cluster_tag_key" {
  value = module.atlantis_cluster.cluster_tag_key
}

output "atlantis_servers_cluster_tag_value" {
  value = module.atlantis_cluster.cluster_tag_value
}

output "ssh_key_name" {
  value = var.ssh_key_name
}

output "atlantis_cluster_size" {
  value = var.atlantis_cluster_size
}

output "private-ips-atlantis" {
  value      = data.aws_instances.atlantis_nodes.private_ips
  depends_on = [data.aws_instances.atlantis_nodes]
}

output "public-ips-atlantis" {
  value      = data.aws_instances.atlantis_nodes.public_ips
  depends_on = [data.aws_instances.atlantis_nodes]
}

output "aws_lb_dns_http" {
  value = "http://${aws_lb.load_balancer.dns_name}"
}

output "aws_lb_dns" {
  value = aws_lb.load_balancer.dns_name
}

/*output "dns-record" {
  value = module.atlantis-route-cname.dns-record
}

output "dns-record-http" {
  value = "http://${module.atlantis-route-cname.dns-record-http}"
}

output "dns-record-https" {
  value = "https://${module.atlantis-route-cname.dns-record-https}"
}*/
