# level3/main.tf
# Main
data "aws_organizations_organization" "main" {}

data "aws_organizations_organizational_units" "grandparent" {
  parent_id = data.aws_organizations_organization.main.roots[0].id
}

locals {
  grandparent_children_count = length([for x in data.aws_organizations_organizational_units.grandparent.children : x.id if x.name == var.grandparent_ou_name])
}

data "aws_organizations_organizational_units" "parent" {
  count = var.grandparent_ou_name != null && local.grandparent_children_count > 0 ? 1 : 0
  parent_id = local.grandparent_children_count > 0 ? element([for x in data.aws_organizations_organizational_units.grandparent.children : x.id if x.name == var.grandparent_ou_name], 0) : null
}

locals {
  parent_children_count = local.grandparent_children_count > 0 ? length([for x in data.aws_organizations_organizational_units.parent[0].children : x.id if x.name == var.parent_ou_name]) : 0
}

data "aws_organizations_organizational_units" "ou" {
  count = local.parent_children_count > 0 ? 1 : 0
  parent_id = local.parent_children_count > 0 ? element([for x in data.aws_organizations_organizational_units.parent[0].children : x.id if x.name == var.parent_ou_name], 0) : null
}

# Check if the OU exists
locals {
  ou_exists = local.parent_children_count > 0 ? contains([for x in data.aws_organizations_organizational_units.ou[0].children : x.name], var.ou_name) : false
}

# Only apply controls if the OU exists
data "aws_controltower_controls" "ou" {
  count             = local.ou_exists ? 1 : 0
  target_identifier = local.ou_exists ? element([for x in data.aws_organizations_organizational_units.ou[0].children : x.arn if x.name == var.ou_name], 0) : null
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
