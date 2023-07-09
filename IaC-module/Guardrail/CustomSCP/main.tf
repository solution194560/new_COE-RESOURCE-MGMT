module "custom_scp_ou_lv1" {
  source                      = "../../modules/CustomSCP"
  custom_scp_ou_lv1_use       = local.custom_scp_ou_lv1_use
  custom_scp_ou_lv1_exclusion = local.custom_scp_ou_lv1_exclusion
  custom_scp_ou_lv1_json      = local.custom_scp_ou_lv1_json
}

module "custom_scp_ou_lv2" {
  source                      = "../../modules/CustomSCP"
  custom_scp_ou_lv2_use       = local.custom_scp_ou_lv2_use
  custom_scp_ou_lv2_exclusion = local.custom_scp_ou_lv2_exclusion
  custom_scp_ou_lv2_json      = local.custom_scp_ou_lv2_json
}

module "custom_scp_ou_lv3" {
  source                      = "../../modules/CustomSCP"
  custom_scp_ou_lv3_use       = local.custom_scp_ou_lv3_use
  custom_scp_ou_lv3_inclusion = local.custom_scp_ou_lv3_inclusion
  custom_scp_ou_lv3_json      = local.custom_scp_ou_lv3_json
}

module "custom_scp_ou_specific" {
  source                          = "../../modules/CustomSCP"
  custom_scp_ou_specific_use      = local.custom_scp_ou_specific_use
  custom_scp_ou_specific_map_list = local.custom_scp_ou_specific_map_list
}
