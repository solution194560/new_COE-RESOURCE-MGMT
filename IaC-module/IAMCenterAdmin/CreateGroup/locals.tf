# It receives the yaml file path declared in Terraform Cloud and reads the contents of the yaml file.
locals {
  okta_group_yaml_contents = flatten([
    for filename in fileset("${var.oktagroup_yaml_path}", "*.yaml") : yamldecode(file("${var.oktagroup_yaml_path}/${filename}")).groups if fileexists("${var.oktagroup_yaml_path}/${filename}")
  ])
}

# Check Terraform Current Time
locals {
  current_time = timestamp()
}

# current time output
output "current_time" {
  value = formatdate("YYYY-MM-DD HH:mm:ss", local.current_time)
}

# Reads a KV-V2 secret from a given path in Vault.
data "vault_kv_secret_v2" "okta" {
  namespace = var.vault_namespace
  mount    = var.vault_mount_path
  name     = var.vault_key_location
}