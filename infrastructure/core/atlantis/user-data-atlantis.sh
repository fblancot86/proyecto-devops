#!/bin/bash
# KeepCoding DevOps & Cloud Computing Full Stack Bootcamp (Final Project)
# Team: KeepCoding Masters
# Staff: Jonas Marquez, Ruben Martin, Yilis Ramirez, Francesc Blanco
# IaC (Infrastructure as Code) & GitOps with Terraform + Atlantis & K8s (Rancher RKE in AWS)
# Technologies: HashiCorp Terraform & Packer, AWS, Docker, Atlantis
# --------------------------------------------------------------------------
set -e

##--------------------------------------------------------------------
# CONFIGURATION OF AWS EFS VOL (ATLANTIS PERSISTENT DATA)
sudo apt install -y nfs-common
sudo mkdir -p /mnt/efs
echo "${tpl_efs_id}.efs.${tpl_aws_region}.amazonaws.com:/ /mnt/efs nfs4 nfsvers=4.1,auto 0 0" | sudo tee -a /etc/fstab
sudo mount -a
sudo mkdir -p /mnt/efs/keepcoding/services/atlantis/data
sudo mkdir -p /mnt/efs/keepcoding/services/atlantis/config
sudo chmod -R 755 /mnt/efs/*
sudo chown -R systemd-network:ubuntu /mnt/efs/*

##--------------------------------------------------------------------
# VAULT INSTALL/CONFIGURATION
sudo wget https://releases.hashicorp.com/vault/1.9.3/vault_1.9.3_linux_amd64.zip
sudo unzip vault_1.9.3_linux_amd64.zip -d /usr/local/bin/
sudo cp /usr/local/bin/vault /bin/
sudo chown ubuntu:ubuntu /usr/local/bin/vault

##--------------------------------------------------------------------
# CREATE AUTH-APP-ROLE IN VAULT WITH ATLANTIS ROLE
export VAULT_ADDR="https://${tpl_vault_server_addr}:8200"
export VAULT_SKIP_VERIFY=true
vault login ${tpl_vault_root_token}
vault write -force auth/aws/role/${tpl_app_role} auth_type=iam bound_iam_principal_arn="${tpl_iam_role_arn_atlantis_cluster}" policies=atlantis-app-pol ttl=24h
sleep 180

##--------------------------------------------------------------------
# CONFIGURATION VAULT-AGENT
sudo mkdir -pm 0755 /etc/vault.d
sudo tee /etc/vault.d/vault.hcl <<EOF
exit_after_auth = false
pid_file = "./pidfile"

auto_auth {
  method "aws" {
    mount_path = "auth/aws"
    config = {
      type = "iam"
      role = "${tpl_app_role}"
    }
  }

  sink "file" {
    config = {
      #path = "/home/ubuntu/vault-token-via-agent"
      path = "./vault-token"
      mode = 644
    }
  }
}

vault {
  address = "https://${tpl_vault_server_addr}:8200"
  tls_skip_verify = true
  retry {
    num_retries = 5
  }
}

cache {
  use_auto_auth_token = true
}

listener "tcp" {
  address = "127.0.0.1:8100"
  tls_disable = true
}
EOF
sudo chmod -R 0644 /etc/vault.d/vault.hcl

# SYSTEMD VAULT-AGENT
sudo tee -a /etc/systemd/system/vault.service <<EOF
[Unit]
Description=Vault Agent
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault.d/vault.hcl

[Service]
WorkingDirectory=/etc/vault.d
#ProtectSystem=full
ProtectHome=read-only
#PrivateTmp=yes
#PrivateDevices=yes
#NoNewPrivileges=yes

Restart=on-failure
PermissionsStartOnly=true
ExecStart=/usr/local/bin/vault agent -config=/etc/vault.d/vault.hcl -log-level=debug
ExecReload=/bin/kill -HUP
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
EOF
sudo chmod 644 /etc/systemd/system/vault.service

# SERVICE VAULT AGENT START
sudo systemctl daemon-reload
sudo systemctl start vault.service
sudo systemctl enable vault.service
sleep 60
export VAULT_AGENT_ADDR="http://127.0.0.1:8100"

##--------------------------------------------------------------------
# AWS CREDENTIALS CONFIGURATION
mkdir /home/ubuntu/.aws
sudo tee -a /home/ubuntu/.aws/credentials <<EOF
[nonprod]
aws_access_key_id = ${tpl_access_key}
aws_secret_access_key = ${tpl_secret_key}
EOF
sudo chmod 644 /home/ubuntu/.aws/credentials
sudo chown ubuntu:ubuntu /home/ubuntu/.aws/credentials

##--------------------------------------------------------------------
# ATLANTIS REPO SERVER CONFIGURATION
sudo mkdir -pm 0755 /etc/atlantis.d/config
sudo tee -a /etc/atlantis.d/config/repos.yaml <<EOF
repos:
  - id: /.*/
    allowed_overrides: [apply_requirements, workflow, delete_source_branch_on_merge]
    allow_custom_workflows: true
workflows:
  nonprod:
    plan:
      steps:
        - env:
            name: ENV_NAME
            value: nonprod
        - env:
            name: ENV_REGION
            value: ${tpl_aws_region}
        - env:
            name: BUCKET_NAME
            value: ${tpl_bucket-name}
        - env:
            name: DYNAMO_NAME
            value: ${tpl_dynamo-name}
        - run: echo PLANNING && rm -rf .terraform
        - run: terraform init -backend-config="region=\$ENV_REGION" -backend-config="bucket=\$BUCKET_NAME" -backend-config="dynamodb_table=\$DYNAMO_NAME" -backend-config="key=\$BASE_REPO_NAME/\$BASE_BRANCH_NAME/\$PROJECT_NAME.tfstate"
        - plan:
            extra_args: [ -var-file=\$ENV_NAME.tfvars ]
    apply:
      steps:
        - run: echo APPLYING
        - apply
EOF

##--------------------------------------------------------------------
# ATLANTIS CONTAINER SERVICE
sudo tee -a /etc/systemd/system/atlantis.service <<EOF
[Unit]
Description=atlantis-server as a service
Requires=docker.service
After=docker.service

[Service]
Restart=on-failure
RestartSec=10
ExecStart=/usr/bin/docker run --name %p --rm --privileged -p 4141:4141 -v /mnt/efs/keepcoding/services/atlantis/data:/home/atlantis/.atlantis -v /etc/atlantis.d/config:/home/atlantis/config -v /home/ubuntu/.aws/credentials:/home/atlantis/.aws/credentials -v /etc/vault.d/vault-token:/home/atlantis/.vault-token:rw keepcoding/atlantis:v${tpl_atlantis_version} server --gh-user="${tpl_git-user}" --gh-token="${tpl_git-token}" --gh-webhook-secret="${tpl_git-webhook-secret}" --repo-allowlist="*" --repo-config=/home/atlantis/config/repos.yaml
ExecStop=-/usr/bin/docker stop -t 2 %p

[Install]
WantedBy=multi-user.target
EOF
sudo chmod 644 /etc/systemd/system/atlantis.service

# SERVICE  ATLANTIS START
sudo systemctl daemon-reload
sudo systemctl start atlantis.service
sudo systemctl enable atlantis.service
sleep 120

# SET PERMISSIONS TO VAULT TOKEN IN ATLANTIS CONTAINER
docker exec atlantis chmod 644 /home/atlantis/.vault-token

##--------------------------------------------------------------------
# IMPORTANT!
