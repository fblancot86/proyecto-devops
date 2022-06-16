# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# Creacion de un  Cluster de Rancher 2 RKE
resource "rancher2_cluster" "rancher-cluster" {
  name = "rancher-cluster"
  description = "Rancher2 Test Cluster"
  rke_config {
    network {
      plugin = "canal"
    }
  }
  depends_on = [
    aws_instance.rancher_server,
    rancher2_bootstrap.admin,
  ]
}
# Creacion de credenciales de Servicios Cloud (AWS)
resource "rancher2_cloud_credential" "aws-credentials" {
  name = "aws-credentials"
  description= "AWS Credentials Terraform"
  amazonec2_credential_config {
    default_region = var.aws_region
    access_key = data.vault_generic_secret.access_key.data["access_key"]
    secret_key = data.vault_generic_secret.secret_key.data["secret_key"]
  }
}
# Kubeconfig file
resource "local_file" "kubeconfig" {
  filename        = "${path.module}/.kube/kube_config.yaml"
  content         = rancher2_cluster.rancher-cluster.kube_config
  file_permission = "0600"
  depends_on = [rancher2_cluster.rancher-cluster]
}