init-terraform-project:
	terraform init -backend-config=backend.conf

generate-terraform-backend-config:
	@if [ ! -f .env ]; then \
		cp backend.conf.example backend.conf; \
	fi

generate-terraform-variables:
	@if [ ! -f .env ]; then \
		cp terraform.tfvars.example terraform.tfvars; \
	fi
