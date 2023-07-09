variable "login_approle_role_id" {
    description = "login approle role id"
}

variable "login_approle_secret_id" {
    description = "login approle secret id"
}

variable "vault_namespace" {
    description = "vault namespace"
}

variable "vault_mount_path" {
    description = "vault mount path"
}

variable "vault_key_location" {
    description = "vault key location"
}

variable "vault_web" {
    description = "vault web address"
}

variable "vault_auth_login_path" {
    description = "vault auth login path"
}

variable "vault_ca_cert_file" {
    description = "vault ca cert file"
}

variable "okta_app_name" {
    description = "Okta application name declared in Terraform Cloud"
}

variable "oktagroup_yaml_path" {
    description = "okta group yaml file path declared in Terraform Cloud"
}