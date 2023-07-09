# START - outputs.tf =================================================================

output "ou_lv0_root_id" {
  value = [for x in data.aws_organizations_organization.ct_orgz.roots : x.id if x.name == "Root"][0]
}

output "ou_lv1_list" {
  value = data.aws_organizations_organizational_units.ou_lv0.children
}

output "ou_lv2_list" {
  value = tolist([for x in data.aws_organizations_organizational_units.ou_lv1 : x.children[0] if length(x.children) > 0])
}

output "ou_lv3_list" {
  value = tolist([for x in data.aws_organizations_organizational_units.ou_lv2 : x.children[0] if length(x.children) > 0])
}

output "custom_scp_ou_lv1_policy" {
  value = aws_organizations_policy.custom_scp_ou_lv1.*
}

output "custom_scp_ou_lv1_policy_attachment" {
  value = aws_organizations_policy_attachment.custom_scp_ou_lv1.*
}

output "custom_scp_ou_lv2_policy" {
  value = aws_organizations_policy.custom_scp_ou_lv2.*
}

output "custom_scp_ou_lv2_policy_attachment" {
  value = aws_organizations_policy_attachment.custom_scp_ou_lv2.*
}

output "custom_scp_ou_lv3_policy" {
  value = aws_organizations_policy.custom_scp_ou_lv3.*
}

output "custom_scp_ou_lv3_policy_attachment" {
  value = aws_organizations_policy_attachment.custom_scp_ou_lv3.*
}

# END - outputs.tf =================================================================