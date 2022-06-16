deployatlantis: cleanatlantis backendinitatlantis planatlantis applyatlantis

#----------------------------------------------------------------------------
# ENVIRONMENT GLOBAL VARS
ENV=nonprod
AWS_CONF_PATH=$(HOME)/.aws
#----------------------------------------------------------------------------
# TERRAFORM GLOBAL VARS
LAUNCH_FILE=launch.log
TF_INIT_CMD=terraform init -backend-config="access_key=$$(cat $(HOME)/.aws/$(ENV).credentials | grep aws_access | awk {'print $$3'})" -backend-config="secret_key=$$(cat $(HOME)/.aws/$(ENV).credentials | grep aws_secret | awk {'print $$3'})"
TF_OUTPUT_FILE=tfplan
TF_PLAN=terraform plan -out=$(TF_OUTPUT_FILE)
TF_APPLY_CMD=terraform apply --auto-approve $(TF_OUTPUT_FILE)
TF_DESTROY_CMD=terraform destroy --auto-approve
DEPLOY_FILES=$(LAUNCH_FILE) $(TF_OUTPUT_FILE) .terraform*
#----------------------------------------------------------------------------
# ATLANTIS CLUSTER VARS
ATLANTIS_PATH=deploy-aws-atlantis-cluster-with-elb

#----------------------------------------------------------------------------
# DEPLOYMENT ATLANTIS CLUSTER
cleanatlantis:
	@echo "º----------------------------------------------------------------º"
	@echo "|               [ CLEANING ATLANTIS DIRECTORY ]                  |"
	@echo "º----------------------------------------------------------------º"
	rm -rf $(LAUNCH_FILE) $(TF_OUTPUT_FILE)

cleanatlantisall:
	@echo "º----------------------------------------------------------------º"
	@echo "|               [ CLEANING ATLANTIS DIRECTORY ]                  |"
	@echo "º----------------------------------------------------------------º"
	rm -rf $(DEPLOY_FILES)

backendinitatlantis:
	@echo "º----------------------------------------------------------------º"
	@echo "|               [ TERRAFORM ATLANTIS BACKEND INIT ]              |"
	@echo "º----------------------------------------------------------------º"
	$(TF_INIT_CMD) | tee -a $(LAUNCH_FILE)

planatlantis:
	@echo "º----------------------------------------------------------------º"
	@echo "|               [ TERRAFORM ATLANTIS PLAN ]                      |"
	@echo "º----------------------------------------------------------------º"
	$(TF_PLAN) | tee -a $(LAUNCH_FILE)

applyatlantis:
	@echo "º----------------------------------------------------------------º"
	@echo "|               [ TERRAFORM ATLANTIS APPLY ]                     |"
	@echo "º----------------------------------------------------------------º"
	$(TF_APPLY_CMD) | tee -a $(LAUNCH_FILE)
	@echo "º----------------------------------------------------------------º"
	@echo "|  ATLANTIS deployment is READY! please wait approximately (3)   |"
	@echo "|  minutes for the service to be READY!                          |"
	@echo "|  OK no click here --> http://atlantis.nonprod.aws.oami.eu      |"
	@echo "º----------------------------------------------------------------º"

destroyatlantis:
	@echo "º----------------------------------------------------------------º"
	@echo "|               [ TERRAFORM ATLANTIS DESTROY ]                   |"
	@echo "º----------------------------------------------------------------º"
	$(TF_DESTROY_CMD) | tee -a $(LAUNCH_FILE)
	@echo "º----------------------------------------------------------------º"
	@echo "|  ATLANTIS deployment is DELETED!                               |"
	@echo "º----------------------------------------------------------------º"