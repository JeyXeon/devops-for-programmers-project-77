### Hexlet tests and linter status:
[![Actions Status](https://github.com/JeyXeon/devops-for-programmers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/JeyXeon/devops-for-programmers-project-77/actions)

**Application URL**: [https://mitynedima.ru/](https://mitynedima.ru/)  

# Terraform module

Use it to generate infrastructure.
Install terraform with this manual: https://developer.hashicorp.com/terraform/install

## Make Commands  

| Command               | Description                                                                 | Prerequisites                              |  
|-----------------------|-----------------------------------------------------------------------------|--------------------------------------------|  
| `make terraform-generate-backend-config` | Generates terraform backend template.                  | Make sure that you have terraform backend credentials to fill in. |  
| `make terraform-generate-variables`  | Generates terraform variables template.                    | Make sure that you have Yandex Cloud credentials to fill in.    | 
| `make terraform-init-project` | Initialize terraform project with filled yearlier config.         | Make sure that you have have generateed and filled both templates. |

Other terraform actions can be done directly by using terraform cli tool.

# Ansible module

Use it to deploy app to created servers.
Install ansible with this manual: https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html

## Make Commands  

| Command               | Description                                                                 | Prerequisites                              |  
|-----------------------|-----------------------------------------------------------------------------|--------------------------------------------|  
| `make ansible-setup-requirements` | Installs required Ansible roles on the local machine.                  | `ansible-galaxy` available                |  
| `make ansible-setup-servers`  | Installs necessary tools for deployment on the target virtual machine.     | Ansible installed on the local machine.    | 
| `make ansible-deploy-redmine` | Deploys the Redmine application.                                           | Create `.vault_pass.txt` in ansible directory with the `ansible-vault` password. |   
| `make ansible-deploy-datadog` | Deploys the Datadog application.                                           | Create `.vault_pass.txt` in ansible directory with the `ansible-vault` password. |
| `make ansible-deploy-all` | Deploys both Datadog and Redmine application.                                  | Create `.vault_pass.txt` in ansible directory with the `ansible-vault` password. |

### Notes  
- The `.vault_pass.txt` file **must not be committed** to version control (add it to `.gitignore`).  
- Ensure the target server is accessible via SSH for `deploy-redmine` and `setup-servers`.
