init:
	@echo "Initializing... (terraform init)"
	@terraform init

doc:
	@echo "Generating documentation..."
	@terraform-docs markdown table --output-file README.md --output-mode inject .

validate: init
	@echo "Validating... (terraform validate)"
	@terraform validate

plan:
	@echo "Planning... (terraform plan)"
	@terraform plan -var-file='../environments/prod/prod.tfvars'

apply: validate
	@echo "Applying... (terraform apply)"
	@terraform apply -var-file='../environments/prod/prod.tfvars'

destroy:
	@echo "Destroying... (terraform destroy)"
	@terraform destroy -var-file='../environments/prod/prod.tfvars'