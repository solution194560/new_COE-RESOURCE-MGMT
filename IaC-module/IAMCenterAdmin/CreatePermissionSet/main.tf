# Execute the module repeatedly with for_each contents of the yaml file read in the local
module "PermissionSet_Create" {
  source = "../../modules/CreatePermissionSet"
  for_each = { for pe in local.permission_yaml_contents : pe.name => pe }

  permission_set_name = each.value.name
  policy_document = try(file("${var.permissionset_json_path}/${each.value.inline_policy}"), null)
  managed_policy = try(each.value.managed_policy, [])
  session_duration = try(each.value.session_duration, "PT4H")
  description = try(each.value.description, "Default description") 
}