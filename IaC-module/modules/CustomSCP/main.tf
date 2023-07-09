# Start - Data from AWS Organizations =================================================================
data "aws_organizations_organization" "ct_orgz" {}

data "aws_organizations_organizational_units" "ou_lv0" {
  # lv0 ou id
  parent_id = data.aws_organizations_organization.ct_orgz.roots[0].id
}

data "aws_organizations_organizational_units" "ou_lv1" {
  for_each = {
    for key in data.aws_organizations_organizational_units.ou_lv0.children :
    key.name => key.id
  }
  # lv1 ou id
  parent_id = each.value
}

data "aws_organizations_organizational_units" "ou_lv2" {
  for_each = {
    for key in tolist([
      for x in data.aws_organizations_organizational_units.ou_lv1 : x.children[0] if length(x.children) > 0
    ]) :
    key.name => key.id
  }
  # lv2 ou id
  parent_id = each.value
}
# END - Data from AWS Organizations =================================================================


# START - Custom SCP for OU Lv1 =================================================================
# Create Random string of Custom SCP for OU Lv1
resource "random_string" "custom_scp_ou_lv1" {
  count   = var.custom_scp_ou_lv1_use ? 1 : 0
  length  = 6
  special = false
}
# Create Custom SCP for OU Lv1
resource "aws_organizations_policy" "custom_scp_ou_lv1" {
  count       = var.custom_scp_ou_lv1_use ? 1 : 0
  name        = "${var.scp_name_prefix}-ou-lv1-${random_string.custom_scp_ou_lv1[0].id}"
  description = "Custom SCP applied to All OU at Level 1"
  content     = var.custom_scp_ou_lv1_json
}
# Attach Custom SCP to all OU Lv1
resource "aws_organizations_policy_attachment" "custom_scp_ou_lv1" {
  for_each = {
    for key in data.aws_organizations_organizational_units.ou_lv0.children :
    key.name => key.id if !contains(var.custom_scp_ou_lv1_exclusion, key.name) && var.custom_scp_ou_lv1_use
  }
  policy_id = aws_organizations_policy.custom_scp_ou_lv1[0].id
  target_id = each.value
}
# END - Custom SCP for OU Lv1 =================================================================

# START - Custom SCP for OU Lv2 =================================================================
# Create Random string of Custom SCP for OU Lv2
resource "random_string" "custom_scp_ou_lv2" {
  count   = var.custom_scp_ou_lv2_use ? 1 : 0
  length  = 6
  special = false
}
# Create Custom SCP for OU Lv2
resource "aws_organizations_policy" "custom_scp_ou_lv2" {
  count       = var.custom_scp_ou_lv2_use ? 1 : 0
  name        = "${var.scp_name_prefix}-ou-lv2-${random_string.custom_scp_ou_lv2[0].id}"
  description = "Custom SCP applied to All OU at Level 2"
  content     = var.custom_scp_ou_lv2_json
}
# Attach Custom SCP to all OU Lv2
resource "aws_organizations_policy_attachment" "custom_scp_ou_lv2" {
  for_each = {
    for key in tolist([
      for x in data.aws_organizations_organizational_units.ou_lv1 : x.children[0]if length(x.children) > 0
    ]) :
    key.name => key.id if !contains(var.custom_scp_ou_lv2_exclusion, key.name) && var.custom_scp_ou_lv2_use
  }
  policy_id = aws_organizations_policy.custom_scp_ou_lv2[0].id
  target_id = each.value
}
# END - Custom SCP for OU Lv2 =================================================================


# START - Custom SCP for OU Lv3 =================================================================
# Create Random string of Custom SCP for OU Lv3
resource "random_string" "custom_scp_ou_lv3" {
  count   = var.custom_scp_ou_lv3_use ? 1 : 0
  length  = 6
  special = false
}
# Create Custom SCP for OU Lv3
resource "aws_organizations_policy" "custom_scp_ou_lv3" {
  count       = var.custom_scp_ou_lv3_use ? 1 : 0
  name        = "${var.scp_name_prefix}-ou-lv3-${random_string.custom_scp_ou_lv3[0].id}"
  description = "Custom SCP applied to All OU at Level 3"
  content     = var.custom_scp_ou_lv3_json
}
# Attach Custom SCP to all OU Lv3
resource "aws_organizations_policy_attachment" "custom_scp_ou_lv3" {
  for_each = {
    for key in tolist([
      for x in data.aws_organizations_organizational_units.ou_lv2 : x.children[0]if length(x.children) > 0
    ]) :
    key.name => key.id if contains(var.custom_scp_ou_lv3_inclusion, key.name) && var.custom_scp_ou_lv3_use
  }
  policy_id = aws_organizations_policy.custom_scp_ou_lv3[0].id
  target_id = each.value
}
# END - Custom SCP for OU Lv3 =================================================================


# START - Custom SCP for OU Specific =================================================================
# Create Random string of Custom SCP for Specific OU
resource "random_string" "custom_scp_ou_specific" {
  count   = var.custom_scp_ou_specific_use ? length(var.custom_scp_ou_specific_map_list) : 0
  length  = 6
  special = false
}
# Create Custom SCP for Specific OU
resource "aws_organizations_policy" "custom_scp_specific_ou" {
  count       = var.custom_scp_ou_specific_use ? length(var.custom_scp_ou_specific_map_list) : 0
  name        = "${var.scp_name_prefix}-ou-specific-${random_string.custom_scp_ou_specific[count.index].id}"
  description = "Custom SCP applied to Specific OU (${var.custom_scp_ou_specific_map_list[count.index].ou_id})"
  content     = var.custom_scp_ou_specific_map_list[count.index].json
}
# Attach Custom SCP to Specific OU
resource "aws_organizations_policy_attachment" "custom_scp_specific_ou" {
  count     = var.custom_scp_ou_specific_use ? length(var.custom_scp_ou_specific_map_list) : 0
  policy_id = aws_organizations_policy.custom_scp_specific_ou[count.index].id
  target_id = var.custom_scp_ou_specific_map_list[count.index].ou_id
}
# END - Custom SCP for OU Specific =================================================================