# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# Creacion de un Pool de Nodos de Rancher

#----------------------------------------------------------------------------
# RANCHER MASTER NODES
resource "rancher2_node_pool" "master-zona-a" {
  cluster_id =  rancher2_cluster.rancher-cluster.id
  name = "rancher-master-zona-a"
  hostname_prefix = "rancher-master-za-0"
  node_template_id = rancher2_node_template.template-t3a-medium-zona-a.id
  quantity = 1
  control_plane = true
  etcd = true
  worker = false
}
resource "rancher2_node_pool" "master-zona-b" {
  cluster_id =  rancher2_cluster.rancher-cluster.id
  name = "rancher-master-zona-b"
  hostname_prefix = "rancher-master-zb-0"
  node_template_id = rancher2_node_template.template-t3a-medium-zona-b.id
  quantity = 1
  control_plane = true
  etcd = true
  worker = false
}
resource "rancher2_node_pool" "master-zona-c" {
  cluster_id =  rancher2_cluster.rancher-cluster.id
  name = "rancher-master-zona-c"
  hostname_prefix =  "rancher-master-zc-0"
  node_template_id = rancher2_node_template.template-t3a-medium-zona-c.id
  quantity = 1
  control_plane = true
  etcd = true
  worker = false
}

#----------------------------------------------------------------------------
# RANCHER WORKER NODES
resource "rancher2_node_pool" "worker-zona-a" {
  cluster_id =  rancher2_cluster.rancher-cluster.id
  name = "rancher-worker-zona-a"
  hostname_prefix = "rancher-worker-za-0"
  node_template_id = rancher2_node_template.template-t3a-medium-zona-a.id
  quantity = 1
  control_plane = false
  etcd = false
  worker = true
}
resource "rancher2_node_pool" "worker-zona-b" {
  cluster_id =  rancher2_cluster.rancher-cluster.id
  name = "rancher-worker-zona-b"
  hostname_prefix = "rancher-worker-zb-0"
  node_template_id = rancher2_node_template.template-t3a-medium-zona-b.id
  quantity = 1
  control_plane = false
  etcd = false
  worker = true
}
resource "rancher2_node_pool" "worker-zona-c" {
  cluster_id =  rancher2_cluster.rancher-cluster.id
  name = "rancher-worker-zona-c"
  hostname_prefix =  "rancher-worker-zc-0"
  node_template_id = rancher2_node_template.template-t3a-medium-zona-c.id
  quantity = 1
  control_plane = false
  etcd = false
  worker = true
}