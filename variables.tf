variable "project" {
  description = "Project name used for resource naming."
}

variable "do_region" {
  description = "DigitalOcean region"
}

variable "do_image_slug" {
  description = "DigitalOcean image slug or image ID to provision."
  type        = "string"
  default     = "ubuntu-18-04-x64"
}

variable "do_token" {
  description = "Your DigitalOcean API token."
}

variable "do_keys" {
  description = "DigitalOcean API SSH key ID."
}

variable "private_key_path" {
  description = "Path to local private SSH key file."
}

variable "ssh_fingerprint" {
  description = "MD5 fingerprint of your local SSH key."
}

variable "public_key" {
  description = "Contents of your public SSH key."
}

variable "app_node_count" {
  description = "Number of Droplets to provision."
  default     = 1
}

variable "eth_node_count" {
  description = "Number of Droplets to provision."
  default     = 2
}

variable "proxy_node_count" {
  description = "Number of Droplets to provision."
  default     = 1
}

variable "eth_do_size" {
  description = "Selected size for your provisioned Ethereum Droplets."
  type        = "string"
  default     = "s-2vcpu-4gb"
}

variable "app_do_size" {
  description = "Selected size for your provisioned app server Droplets."
  type        = "string"
  default     = "s-2vcpu-4gb"
}

variable "proxy_do_size" {
  description = "Selected size for your provisioned proxy Droplets."
  type        = "string"
  default     = "s-2vcpu-2gb"
}

variable "ansible_user" {
  description = "User name to initiate connection for Ansible"
  type        = "string"
  default     = "ansible"
}

variable "mgmt_ip" {
  description = "IP address of mangement host to allow SSH ingress"
  type = "string"
}
