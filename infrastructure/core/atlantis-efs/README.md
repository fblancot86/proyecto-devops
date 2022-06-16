# AWS EFS Volume to persist Atlantis data

This manifest displays a AWS EFS volume to be used by Atlantis to persist data.

### HowToDeploy

1. git clone https://github.com/KeepCodingCloudDevops5/keepcoding-masters-proyecto-final.git
2. cd keepcoding-masters-proyecto-final/infrastructure/core/atlantis-efs/
3. edit variables.tf files and set access_key and secret_key or export them as environment variables
4. terraform init
5. terraform plan -out=tfplan
6. terraform apply --auto-approve tfplan

NOTE:

As a best practice, it is recommended not to define the AWS credentials in the AWS manifests. To carry out the deployment, it is recommended to export the credentials as environment variables, for example in the following way:

```export AWS_ACCESS_KEY_ID=<KEY-ID> && export AWS_SECRET_ACCESS_KEY=<KEY-ID> && export AWS_DEFAULT_REGION=eu-central-1```