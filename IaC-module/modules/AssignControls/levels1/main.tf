# level1/main.tf

# Main
data "aws_organizations_organization" "main" {}

data "aws_organizations_organizational_units" "ou" {
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

# Check if the OU exists
locals {
  ou_exists = contains([for x in data.aws_organizations_organizational_units.ou.children : x.name], var.ou_name)
}

# Only apply controls if the OU exists
data "aws_controltower_controls" "ou" {
  count             = local.ou_exists ? 1 : 0
  target_identifier = element([for x in data.aws_organizations_organizational_units.ou.children : x.arn if x.name == var.ou_name], 0)
}

resource "aws_controltower_control" "ou" {
  #for_each = local.ou_exists ? var.ou_controls : {}
  for_each = { for item in var.ou_controls : item => item }

  control_identifier = "${var.control_prefix}${each.value}"
  target_identifier = data.aws_controltower_controls.ou[0].target_identifier
}


output "control_identifiers" {
  value = local.ou_exists ? data.aws_controltower_controls.ou[0].enabled_controls : []
}
