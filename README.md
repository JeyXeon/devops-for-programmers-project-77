### Hexlet tests and linter status:
[![Actions Status](https://github.com/JeyXeon/devops-for-programmers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/JeyXeon/devops-for-programmers-project-77/actions)

**Application URL**: [https://mitynedima.ru/](https://mitynedima.ru/)  

# Terraform module

Use it to generate infrastructure.
You should have installed terraform to use it.

## Make Commands  

| Command               | Description                                                                 | Prerequisites                              |  
|-----------------------|-----------------------------------------------------------------------------|--------------------------------------------|  
| `make generate-terraform-backend-config` | Generates terraform backend template.                  | Make sure that you have terraform backend credentials to fill in. |  
| `make generate-terraform-variables`  | Generates terraform variables template.                    | Make sure that you have Yandex Cloud credentials to fill in.    | 
| `make init-terraform-project` | Initialize terraform project with filled yearlier config.         | Make sure that you have have generateed and filled both templates. |

Other terraform actions can be done directly by using terraform cli tool.

# Ansible module

Use it to deploy app to created servers.

## Make Commands  

| Command               | Description                                                                 | Prerequisites                              |  
|-----------------------|-----------------------------------------------------------------------------|--------------------------------------------|  
| `make setup-requirements` | Installs required Ansible roles on the local machine.                  | `ansible-galaxy` available                |  
| `make setup-servers`  | Installs necessary tools for deployment on the target virtual machine.      | Ansible installed on the local machine.    | 
| `make deploy-redmine` | Deploys the Redmine application.                                           | Create `.vault_pass.txt` in root directory with the `ansible-vault` password. |   
| `make deploy-datadog` | Deploys the Datadog application.                                           | Create `.vault_pass.txt` in root directory with the `ansible-vault` password. |
| `make deploy-all` | Deploys both Datadog and Redmine application.                                           | Create `.vault_pass.txt` in root directory with the `ansible-vault` password. |

### Notes  
- The `.vault_pass.txt` file **must not be committed** to version control (add it to `.gitignore`).  
- Ensure the target server is accessible via SSH for `deploy-redmine` and `setup-servers`.
