deploy-all:
	make setup-servers
	ansible-playbook -i inventory.ini deploy_application_playbook.yml --vault-password-file .vault_pass.txt

deploy-datadog:
	make setup-servers
	ansible-playbook -i inventory.ini deploy_application_playbook.yml --tags datadog --vault-password-file .vault_pass.txt

deploy-redmine:
	make setup-servers
	ansible-playbook -i inventory.ini deploy_application_playbook.yml --tags redmine --vault-password-file .vault_pass.txt

setup-servers:
	ansible-playbook -i inventory.ini playbook.yml --vault-password-file .vault_pass.txt

setup-requirements:
	ansible-galaxy install -r requirements.yml
