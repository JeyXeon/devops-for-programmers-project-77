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
