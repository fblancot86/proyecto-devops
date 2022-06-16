deployvault: cleanvault backendinitvault planvault applyvault

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
# VAULT CLUSTER VARS
VAULT_PATH=examples/vault-auto-unseal

#----------------------------------------------------------------------------
# DEPLOYMENT VAULT CLUSTER
cleanvault:
	@echo "<-----------------[ CLEANING VAULT DIRECTORY ]----------------->"
	cd $(VAULT_PATH) && rm -rf $(LAUNCH_FILE) $(TF_OUTPUT_FILE)

cleanvaultall:
	@echo "<-----------------[ CLEANING VAULT DIRECTORY ]----------------->"
	cd $(VAULT_PATH) && rm -rf $(DEPLOY_FILES)

backendinitvault:
	@echo "<-----------------[ TERRAFORM VAULT BACKEND INIT ]----------------->"
	cd $(VAULT_PATH) && $(TF_INIT_CMD) | tee -a $(LAUNCH_FILE)

planvault:
	@echo "<-----------------[ TERRAFORM VAULT PLAN ]----------------->"
	cd $(VAULT_PATH) && $(TF_PLAN) | tee -a $(LAUNCH_FILE)

applyvault:
	@echo "<-----------------[ TERRAFORM VAULT APPLY ]----------------->"
	cd $(VAULT_PATH) && $(TF_APPLY_CMD) | tee -a $(LAUNCH_FILE)

destroyvault:
	@echo "<-----------------[ TERRAFORM VAULT DESTROY ]----------------->"
	cd $(VAULT_PATH) && $(TF_DESTROY_CMD) | tee -a $(LAUNCH_FILE)