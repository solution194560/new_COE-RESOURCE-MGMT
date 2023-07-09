module "levels1" {
  source          = "../../modules/AssignControls/levels1"
  for_each        = { for ou in local.ou_yaml_contents : ou.ou_name => ou if ou.level == 1 }
  ou_name         = each.value.ou_name
  ou_controls     = each.value.ou_controls
  control_prefix  = var.control_prefix
}

module "levels2" {
  source          = "../../modules/AssignControls/levels2"
  for_each        = { for ou in local.ou_yaml_contents : ou.ou_name => ou if ou.level == 2 }
  ou_name         = each.value.ou_name
  parent_ou_name  = each.value.parent_ou_name
  ou_controls     = each.value.ou_controls
  control_prefix  = var.control_prefix
}

module "levels3" {
  source             = "../../modules/AssignControls/levels3"
  for_each           = { for ou in local.ou_yaml_contents : ou.ou_name => ou if ou.level == 3 }
  ou_name            = each.value.ou_name
  parent_ou_name     = each.value.parent_ou_name
  grandparent_ou_name = each.value.grandparent_ou_name
  ou_controls        = each.value.ou_controls
  control_prefix     = var.control_prefix
}

output "ou_yaml_contents" {
  value = local.ou_yaml_contents
}