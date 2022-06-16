# Infrastructure as Code (IaC)

This directory contains the definition of the entire infrastructure as code based on [HashiCorp Terraform](https://www.terraform.io).

The infrastructure is deployed in two phases, core infrastructure is deployed from a local environment and is composed of networking (vpc, subnets, internet gateway, routing table, etc), AWS EFS Volume and Bucket S3 and DynamoDB table to store remote Terraform tfstates.

The Rancher (Kubernetes) cluster is deployed using Atlantis with a Pull Request, for this it is necessary to define a project based on a YAML file, the definition of this is in the atlantis-rancher-cluster directory.

![Alt text](../docs/img/atlantis_workflow.png?raw=true "Atlantis Workflow")

### Minimal requirements:

- Linux Host or Instance (recommended), Windows can also be used
- Installation of the Terraform binary (>= 0.12.26)
- AWS subscription (access and secret keys) with sufficient permissions

### Used technologies:
- HashiCorp [Terraform](https://www.terraform.io), [Consul](https://www.consul.io), [Vault](https://www.vaultproject.io)
- [GitHub](https://github.com)(version control)
- [Amazon Web Services](https://aws.amazon.com)
- [Atlantis](https://www.runatlantis.io)

### The order of infrastructure deployment is as follows:

1. [Network Deployment](core/vpc/README.md)
2. [Terraform Backend State Deployment](core/tfbackend/README.md)
3. [HashiCorp Consul / Vault Deployment](core/vault/README.md)
4. [AWS EFS Volume Deployment](core/atlantis-efs/README.md) to be used by Atlantis
5. [Atlantis Deployment](core/atlantis/README.md) (as a deployment automation tool with Terraform)
6. [Rancher Cluster Deployment Automation with Atlantis and GitHub](atlantis-rancher-cluster/README.md) (Kubernetes cluster based on Rancher RKE using AWS provider)