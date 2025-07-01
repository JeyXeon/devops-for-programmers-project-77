ansible-deploy-all:
	make -C ./ansible deploy-all

ansible-deploy-datadog:
	make -C ./ansible deploy-datadog

ansible-deploy-redmine:
	make -C ./ansible deploy-redmine

ansible-setup-servers:
	make -C ./ansible setup-servers

ansible-setup-requirements:
	make -C ./ansible setup-requirements

terraform-apply-project:
	make -C ./terraform apply-terraform-project

terraform-destroy-project:
	make -C ./terraform destroy-terraform-project

terraform-init-project:
	make -C ./terraform init-terraform-project

terraform-generate-backend-config:
	make -C ./terraform generate-terraform-backend-config

terraform-generate-variables:
	make -C ./terraform generate-terraform-variables
