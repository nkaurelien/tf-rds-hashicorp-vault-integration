# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}


variable "vault_token" {
  description = "Vault token"
  type        = string
  sensitive   = true # export your token with "export TF_VAR_vault_token='paste_your_token_here'"
}

variable "vault_address" {
  description = "Vault endpoint"
  type        = string
  default     = "http://localhost:8200"
}

variable "vault_mount_secret" {
  description = "Vault mount path for the secret"
  type        = string
  default     = "kv-v2" # To be created on vault
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}