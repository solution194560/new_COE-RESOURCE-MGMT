# Execute the module repeatedly with for_each contents of the yaml file read in the local
module "Account_Group_Assign" {
  source = "../../modules/GroupAssignment"

  for_each = { for pe in local.assign_yaml_contents : md5("${pe.group}-${pe.permissionset}")  => pe }
  group = each.value.group
  permissionset = each.value.permissionset
  account = each.value.account
}