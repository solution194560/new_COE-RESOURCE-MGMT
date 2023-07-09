# Execute the module repeatedly with for_each contents of the yaml file read in the local
module "okta_group" {
  source = "../../modules/CreateGroup"

  for_each = { for pe in local.okta_group_yaml_contents : pe.name => pe }
  groups = try(each.value.name, null)
  description = try(each.value.description, "aws okta group")
  okta_app_name = var.okta_app_name
  }