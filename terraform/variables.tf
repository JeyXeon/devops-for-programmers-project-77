variable "yc_sa_key_file" {
  description = "Path to YC Service Account JSON key file"
  type        = string
  sensitive   = true
}

variable "yc_vm_ssh_key" {
  description = "SSH public key content"
  type        = string
  sensitive   = true
}

variable "yc_zone" {
  description = "Cloud zone"
  type        = string
  sensitive   = true
}

variable "yc_domain" {
  description = "Domain name"
  type        = string
  sensitive   = true
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API Key"
  sensitive   = true
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog App Key"
  sensitive   = true
}
