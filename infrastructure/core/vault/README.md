# Vault Deployment
## (Auto Scaling Group  with Elastic Load Balancer, HTTPS, and Route 53 CNAME record Configuration)

**IMPORTANT!:** this repository will be progressively updated, many of the resources will be modularized and parameterized. Modules will be relocated to individual repositories.

> **Requirements:**
> - Terraform binary installed! ref: https://learn.hashicorp.com/tutorials/terraform/install-cli
> - Cloud Provider credentials AWS required to authenticate.
> - Access/Visibility with the network in which you want to make the deployment.

# Basics:

### File description:

- Right now we have two directories, the **modules** directory contains the modules that will be used in the deployment and the **examples** directory contains the vault-auto-unseal directory that deploys Vault Unsealed (Version not used for PROD).
- **variables.tf:** this files defines variables that will be used with some values by default.
- **terraform.tfvars:** defines custom variables that override the default values of the variables.tf.
- **provider.tf:** this file defines the credentials of the AWS provider and the HashiCorp Vault provider with a token to access the secrets and the provider to be cloud services.
- **main.tf:** defines all the infrastructure that will be created in the cloud service provider.
- **lb.tf:** this file defines the Load Balancer infrastructure and CNAME record in Route 53.
- **data.tf:** this file gets data from data sources and queries both the secrets provider and the cloud service provider.
- **backend.tf:** defines the bucket, path and name of the tfstate file that stores the deployment information maintaining a remote state, in the case of AWS S3 and DynamoDB are used and in the case of Azure a Storage Account is used.
- **outputs.tf:** this file defines the output of the data such as Ids, arn, dns, etc of the created resources.
- **user-data-consul.sh / user-data-vault.sh:** this file contains (if necessary) custom configurations in the case of virtual instances or other types of resources that require it.

---

# HowToUse:
1. git clone https://github.com/KeepCodingCloudDevops5/keepcoding-masters-proyecto-final.git
2. cd keepcoding-masters-proyecto-final/infrastructure/core/vault/examples/vault-auto-unseal
3. Assign default values in variables.tf or create a terraform.tfvars file in which to assign sensible data. (remember to add it to gitignore).
4. Export the access and secret keys of your AWS subscription as environment variables (ex: export AWS_ACCESS_KEY_ID=<KEY-ID> && export AWS_SECRET_ACCESS_KEY=<KEY-ID> && export AWS_DEFAULT_REGION=eu-central-1)
5. Execute the command: ***terraform init (if it is necessary to modify the backend.tf file to change the s3 bucket, dynamodb table or key path of the tfstate)
6. Execute the command: ***terraform plan -out=tfplan***
7. Execute the command: ***terraform apply --auto-approve tfplan***
8. Wait for the infrastructure to be deployed!
9. At the end, the Output will show the IDs, IPs, DNS, etc to access Vault by HTTP(s)
10. Customize the Vault initialization by adding the secrets you need on the instance so that Vault is initialized and all necessary. It is important to save the information of the keys and the root token generated in the initialization.
11. You can now access Vault from https://url or access it from the CLI with the Vault binary installed locally. You can also configure the Vault provider in Terraform to be able to deploy infrastructure by getting secrets from Vault.

---

# Makefile (Optional):
**Important!:** requires having "make" installed in the operating system. All execution is saved in a log file called launch.log
1. git clone https://github.com/KeepCodingCloudDevops5/keepcoding-masters-proyecto-final.git
2. cd keepcoding-masters-proyecto-final/infrastructure/core/vault
3. Modify Makefile with the correct ENV variable (ENV=nonprod or ENV=prod).
4. Create files $HOME/.aws/nonprod.credentials or $HOME/.aws/prod.credentials depending on the environment with the AWS access and secret keys as follows:
   > aws_access_key_id = AKIA56XXXXXXXXXXXX\
   > aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxx
5. Execute the command: ***make deployvault***
6. Follow steps 8-12 of the HowToUse explained above
7. If you want to remove the deployment run the command: **make destroyvault**
8. You can also run only part of the deployment, such as: **cleanvault** (delete the tfplan file), **cleanvaultall** (remove the tfplan file and all files downloaded during the last deploy), **backendinitvault** (initialize the deployment with the remote backend), **planvault** (generates the deployment plan and displays it on the screen and saves it in the tfplan file), **applyvault** (apply planning, requires having executed planvault)

---

# Important!
In the step 3 the "ID" corresponds to the access key and secret key of the selected AWS account, it is important to initialize Terraform in this way to activate the backend for the remote state!

With Azure the init just require de access_key in -backend-config.

---

# References:

### Terraform:
https://www.terraform.io/

### Vault:
https://www.vaultproject.io/