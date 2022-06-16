# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------

# Security group to allow all traffic
resource "aws_security_group" "rancher_sg_allowall" {
  name        = "sg_${var.environment}_${var.aws_region}_rancher_001"
  description = "Rancher - Security Group"
  vpc_id      = data.aws_vpc.vpc-id-staging.id

  # INGRESS RULES
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provides HTTP access from client web browsers to the local user interface and connections from Cloud Data Sense"
  }

  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provides HTTP access from client web browsers to the local user interface and connections from Cloud Data Sense"
  }

  ingress {
    from_port   = "6443"
    to_port     = "6443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS traffic to Kubernetes API"
  }

  ingress {
    from_port   = "6783"
    to_port     = "6784"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Weave Port"
  }

  ingress {
    from_port   = "3260"
    to_port     = "3260"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "iSCSI access through the iSCSI data LIF"
  }

  ingress {
    from_port   = "4789"
    to_port     = "4789"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "sg-xxx (rancher-nodes)"
  }

  ingress {
    from_port   = "30000"
    to_port     = "32767"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NAT K8s Ports Temp"
  }

  ingress {
    from_port   = "32000"
    to_port     = "32000"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Traffic from the Load Balancer"
  }

  ingress {
    from_port   = "30000"
    to_port     = "32767"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NAT K8s Ports Temp"
  }

  ingress {
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Rancher webhook"
  }

  ingress {
    from_port   = "4443"
    to_port     = "4443"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Metrics Server"
  }

  ingress {
    from_port   = "8472"
    to_port     = "8472"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Canal/Flannel VXLAN overlay networking"
  }

  ingress {
    from_port   = "2380"
    to_port     = "2380"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "etcd peer communication"
  }

  ingress {
    from_port   = "9099"
    to_port     = "9099"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Canal/Flannel livenessProbe/readinessProbe"
  }

  ingress {
    from_port   = "9100"
    to_port     = "9100"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Default port required by Monitoring to scrape metrics from Linux node-exporters"
  }

  ingress {
    from_port   = "9443"
    to_port     = "9443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Rancher webhook"
  }

  ingress {
    from_port   = "9796"
    to_port     = "9796"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Default port required by Monitoring to scrape metrics from Windows node-exporters"
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provides HTTPS access from client web browsers to the local user interface"
  }

  ingress {
    from_port   = "179"
    to_port     = "179"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Calico BGP Port"
  }

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provides ping"
  }

  ingress {
    from_port   = "2049"
    to_port     = "2049"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NFS"
  }

  ingress {
    from_port   = "2379"
    to_port     = "2379"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "etcd client requests"
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Provide SSH"
  }

  ingress {
    from_port   = "10248"
    to_port     = "10248"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HealthCheck RKE"
  }

  ingress {
    from_port   = "10250"
    to_port     = "10250"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Metrics server communication with all nodes API"
  }

  ingress {
    from_port   = "10256"
    to_port     = "10256"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "sg-xxx (rancher-nodes)"
  }

  ingress {
    from_port   = "2376"
    to_port     = "2376"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Node driver Docker daemon TLS port"
  }

  ingress {
    from_port   = "10254"
    to_port     = "10254"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ingress controller livenessProbe/readinessProbe"
  }

  ingress {
    from_port   = "8500"
    to_port     = "8500"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Vault"
  }

  # EGRESS RULES / ALLOW ALL
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "sg_${var.environment}_${var.aws_region}_rancher_001"
    Terraform = "True"
  }
  depends_on = [aws_key_pair.rancher_key_pair]
}