## OU List
#output "ou_lv0_root_id" {
#  value = module.custom_scp_ou_lv1.ou_lv0_root_id
#}
#output "ou_lv1_list" {
#  value = module.custom_scp_ou_lv1.ou_lv1_list
#}
#output "ou_lv2_list" {
#  value = module.custom_scp_ou_lv1.ou_lv2_list
#}
#output "ou_lv3_list" {
#  value = module.custom_scp_ou_lv1.ou_lv3_list
#}

# OU Lv1 - SCP Policy, Attachment
output "custom_scp_ou_lv1_policy_name" {
  value = local.custom_scp_ou_lv1_use? module.custom_scp_ou_lv1.custom_scp_ou_lv1_policy.*.name[0] : null
}
output "custom_scp_ou_lv1_policy_attachment_ou_list" {
  value = local.custom_scp_ou_lv1_use? [for k, v in module.custom_scp_ou_lv1.custom_scp_ou_lv1_policy_attachment[0]: k] : null
}

# OU Lv2 - SCP Policy, Attachment
output "custom_scp_ou_lv2_policy_name" {
  value = local.custom_scp_ou_lv2_use? module.custom_scp_ou_lv2.custom_scp_ou_lv2_policy.*.name[0] : null
}
output "custom_scp_ou_lv2_policy_attachment_ou_list" {
  value = local.custom_scp_ou_lv2_use? [for k, v in module.custom_scp_ou_lv2.custom_scp_ou_lv2_policy_attachment[0]: k] : null
}

# OU Lv3 - SCP Policy, Attachment
output "custom_scp_ou_lv3_policy_name" {
  value = local.custom_scp_ou_lv3_use?  module.custom_scp_ou_lv3.custom_scp_ou_lv3_policy.*.name[0] : null
}
output "custom_scp_ou_lv3_policy_attachment_ou_list" {
  value = local.custom_scp_ou_lv3_use? [for k, v in module.custom_scp_ou_lv3.custom_scp_ou_lv3_policy_attachment[0]: k] : null
}
