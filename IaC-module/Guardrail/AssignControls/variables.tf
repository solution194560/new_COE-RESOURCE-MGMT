variable "control_prefix" {
  type = string
  default = "arn:aws:controltower:ap-northeast-2::control/"
  description = "The prefix for the Control Tower control ARNs"
}

# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "ap-northeast-2"
}

#OU_yaml 위치
variable "ou_yaml_path" {}

# vault
variable "login_approle_role_id" {
  description = "login approle role id"
}

# vault
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