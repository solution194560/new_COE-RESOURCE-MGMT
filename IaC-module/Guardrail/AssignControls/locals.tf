locals {
  ou_yaml_contents = flatten([
    for filename in fileset(var.ou_yaml_path, "*.yaml") : yamldecode(file("${var.ou_yaml_path}${filename}")) if fileexists("${var.ou_yaml_path}${filename}")
  ])

  
  # VAULT Locals =================================================================
#  VAULT_ADDR        = "https://vault-poc.site:8200"
#  REGION            = "ap-northeast-2"
#  VAULT_AWS_BACKEND = "aws-c760-ct-mgmt"
#  VAULT_AWS_ROLE    = "orgfullaccess-test"
}


