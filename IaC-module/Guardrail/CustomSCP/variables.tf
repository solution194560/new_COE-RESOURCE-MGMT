# Input Variables
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "mgmt"
}

# Business Division
variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "ccoe"
}

# vault
variable "login_approle_role_id" {
  description = "login approle role id"
}

variable "login_approle_secret_id" {
  description = "login approle secret id"
}

# vault
variable "vault_namespace" {
    description = "vault namespace"
}

# vault
variable "vault_mount_path" {
    description = "vault mount path"
}

# vault
variable "vault_web" {
    description = "vault web address"
}

# vault
variable "vault_auth_login_path" {
    description = "vault auth login path"
}

# vault
variable "vault_ca_cert_file" {
    description = "vault ca cert file"
}

# vault
variable "vault_aws_backend" {
    description = "vault aws backend"
}

# vault
variable "vault_aws_role" {
    description = "vault aws role"
}

# yaml, json file path
variable "scp_yaml_path" {
  default = "./scp_yamls"
}

variable "scp_json_path" {
  default = "./scp_subs"
}