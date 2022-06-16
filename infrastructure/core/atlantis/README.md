# Atlantis Deployment
## (Auto Scaling Group  with Elastic Load Balancer and Vault Agent Configuration)

**IMPORTANT!:** this repository will be progressively updated, many of the resources will be modularized and parameterized.

> **Requirements:**
> - Terraform binary installed! ref: https://learn.hashicorp.com/tutorials/terraform/install-cli
> - Cloud Provider credentials AWS required to authenticate.
> - Access/Visibility with the network in which you want to make the deployment.
> - AWS ASG Atlantis Module

# Basics:

### File description:

- **variables.tf:** this files defines variables that will be used with some values by default.
- **terraform.tfvars:** defines custom variables that override the default values of the variables.tf.
- **terraform.tf:** defines the version of terraform and providers required.
- **provider.tf:** this file defines the credentials of the AWS provider and the HashiCorp Vault provider with a token to access the secrets and the provider to be cloud services.
- **main.tf:** defines all the infrastructure that will be created in the cloud service provider.
- **lb.tf:** this file defines the Load Balancer infrastructure and CNAME record in Route 53.
- **data.tf:** this file gets data from data sources and queries both the secrets provider and the cloud service provider.
- **backend.tf:** defines the bucket, path and name of the tfstate file that stores the deployment information maintaining a remote state in AWS S3 and DynamoDB are used.
- **outputs.tf:** this file defines the output of the data such as Ids, arn, dns, etc of the created resources.
- **user-data-atlantis.sh:** this file contains (if necessary) custom configurations in the case of virtual instances or other types of resources that require it.

---

# HowToUse:
1. git clone https://github.com/KeepCodingCloudDevops5/keepcoding-masters-proyecto-final.git
2. cd keepcoding-masters-proyecto-final/infrastructure/core/atlantis
3. Modify terraform.tfvars with the custom data.
4. Modify the module path, you can point to a local path or directly to the module repository on GitHub with or without defining the Git username and password, example of this in main.tf (source = "../mod-aws-atlantis-cluster")
5. Execute the command: ***terraform init (if it is necessary to modify the backend.tf file to change the s3 bucket, dynamodb table or key path of the tfstate)
6. Execute the command: ***terraform plan -out=tfplan***
7. Execute the command: ***terraform apply --auto-approve tfplan***
8. Wait for the infrastructure to be deployed!
9. At the end, the Output will show the IDs, DNS, etc to access Atlantis by HTTP(s)
10. Wait approximately 5 minutes until the Load Balancer has fully activated and the services on the Atlantis instance have come up.
11. Now you can configure a WebHook in GIT repository to be used from Atlantis using the obtained DNS, for example: http://atlantis.example:4141/events (It is very important set /events in the URL and the service port 4141).

---

# Makefile (Optional):
**Important!:** requires having "make" installed in the operating system. All execution is saved in a log file called launch.log
1. git clone https://github.com/KeepCodingCloudDevops5/keepcoding-masters-proyecto-final.git
2. cd keepcoding-masters-proyecto-final/infrastructure/core/atlantis
3. Modify Makefile with the correct ENV variable (ENV=nonprod or ENV=prod).
4. Create files $HOME/.aws/nonprod.credentials or $HOME/.aws/prod.credentials depending on the environment with the AWS access and secret keys as follows:
   > aws_access_key_id = AKIA56XXXXXXXXXXXX\
   > aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxx
5. Execute the command: ***make deployatlantis***
6. Follow steps 8-11 of the HowToUse explained above
7. If you want to remove the deployment run the command: **make destroyatlantis**
8. You can also run only part of the deployment, such as: **cleanatlantis** (delete the tfplan file), **cleanatlantisall** (remove the tfplan file and all files downloaded during the last deploy), **backendinitatlantis** (initialize the deployment with the remote backend), **planatlantis** (generates the deployment plan and displays it on the screen and saves it in the tfplan file), **applyatlantis** (apply planning, requires having executed planatlantis)

# Important!
In the step 4 the "ID" corresponds to the access key and secret key of the selected AWS account, it is important to initialize Terraform in this way to activate the backend for the remote state!

With Azure the init just require de access_key in -backend-config.

---

# Terraform Remote TFSTATE Backend configuration in Atlantis Workflows
The remote state of Terraform is stored in AWS using S3 and DynamoDB, the Atlantis Workflows configuration is used to parameterize the Paths of the tfstate files, in this way we get the information to be organized by environment, repository, branch and project as shown explain below.

The /etc/atlantis.d/config/repos.yaml file contains the configuration of the workflow on the server side **(we can adjust this as we want)**, a workflow is defined with the name of the environment, in this workflow we define as steps the creation of environment variables using the variables that we pass to the user-data from the Terraform module template with the prefix ${tpl_XXXXX}, in this way we define from the deployment .tfvars the data of the environment, the AWS region, the names of the S3 Bucket and the DynamoDB table and together with the GitHub environment variables we define the Path of the tfstate for each project, according to environment, repository name, branch and project name.

**Example:** 

>$BASE_REPO_NAME/$BASE_BRANCH_NAME/$PROJECT_NAME.tfstate

**Amazon S3 Buckets keepcoding-masters-nonprod result:**
> env:/nonprod/demo-atlantis-workflow/master/bucket.tfstate

**Example of Atlantis repos.yaml file:**
````
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
````

Then in the root of the deployment repositories we create an atlantis.yaml file that contains our project, documentation will be created in the Atlantis section on the use or definition of this type of file.

**Example of Terraform Project atlantis.yaml file:**

````
version: 3
automerge: false
delete_source_branch_on_merge: false
parallel_plan: false
parallel_apply: false
projects:
- name: test
  dir: ./ec2
  workspace: nonprod
  terraform_version: v1.1.4
  delete_source_branch_on_merge: false
  autoplan:
  when_modified: ["*.tf"]
  enabled: true
  apply_requirements: [mergeable, approved]
  workflow: nonprod
````

---
# References:

### Terraform:
https://www.terraform.io/

### Atlantis:
https://www.runatlantis.io/

### Vault:
https://www.vaultproject.io/