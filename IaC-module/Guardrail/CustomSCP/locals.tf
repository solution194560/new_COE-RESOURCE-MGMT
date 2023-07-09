locals {

  # scp의 statement를 구성하는 sub json 파일들을 디렉터리에 저장
  # 디렉터리 내의 sub json 파일들 map으로 변환 (key=파일명, value=파일 내용)
  scp_subs_dir = "${var.scp_json_path}"
  scp_subs     = {
    for scp_sub in fileset(local.scp_subs_dir, "*.json") :
    trimsuffix(scp_sub, ".json") => file(format("%s/%s", local.scp_subs_dir, scp_sub))
  }

  # scp yaml 파일을 디렉터리에 저장
  # 디렉터리 내의 yaml 파일들 map으로 변환 (key=파일명, value=파일 내용)
  scp_yaml_dir = "${var.scp_yaml_path}"
  scp_yamls    = {
    for scp_yaml in fileset(local.scp_yaml_dir, "*.yaml") :
    trimsuffix(scp_yaml, ".yaml") => yamldecode(file(format("%s/%s", local.scp_yaml_dir, scp_yaml)))["custom_scp"]
  }

  # Custom SCP for OU Lv1  (정책 일괄 적용. 일부 OU 예외) =================================================================
  custom_scp_ou_lv1           = [for k, v in local.scp_yamls : v if v["ou_level"] == "lv1" && v["use"] == true]
  custom_scp_ou_lv1_use       = length(local.custom_scp_ou_lv1) > 0 ? local.custom_scp_ou_lv1[0]["use"] : false
  custom_scp_ou_lv1_exclusion = length(local.custom_scp_ou_lv1) > 0 ? (local.custom_scp_ou_lv1[0]["excluded_ou_names"] != null ? local.custom_scp_ou_lv1[0]["excluded_ou_names"] : []) : []
  custom_scp_ou_lv1_json      = length(local.custom_scp_ou_lv1) > 0 ? jsonencode(
    {
      Version   = "2012-10-17"
      Statement = [
        # scp_subs 디렉터리에 JSON 파일 추가 &&  scp_yamls 디렉터리에 yaml 파일 추가해야 함
        for subs in local.custom_scp_ou_lv1[0]["json_statements"] : jsondecode(local.scp_subs[subs])
      ]
    }
  ) : ""

  # Custom SCP for OU Lv2  (정책 일괄 적용. 일부 OU 예외) =================================================================
  # 유의: 상위 OU에서 정책이 상속되므로 상위 OU 내 선언 시 중복 추가 불필요
  custom_scp_ou_lv2           = [for k, v in local.scp_yamls : v if v["ou_level"] == "lv2" && v["use"] == true]
  custom_scp_ou_lv2_use       = length(local.custom_scp_ou_lv2) > 0 ? local.custom_scp_ou_lv2[0]["use"] : false
  custom_scp_ou_lv2_exclusion = length(local.custom_scp_ou_lv2) > 0 ? (local.custom_scp_ou_lv2[0]["excluded_ou_names"] != null ? local.custom_scp_ou_lv2[0]["excluded_ou_names"] : []) : []
  custom_scp_ou_lv2_json      = length(local.custom_scp_ou_lv2) > 0 ? jsonencode(
    {
      Version   = "2012-10-17"
      Statement = [
        # scp_subs 디렉터리에 JSON 파일 추가 &&  scp_yamls 디렉터리에 yaml 파일 추가해야 함
        for subs in local.custom_scp_ou_lv2[0]["json_statements"] : jsondecode(local.scp_subs[subs])
      ]
    }
  ) : ""

  # Custom SCP for OU Lv3  (정책 일괄 적용. 특정 OU만 포함) =================================================================
  # 유의: 상위 OU에서 정책이 상속되므로 상위 OU 내 선언 시 중복 추가 불필요
  custom_scp_ou_lv3           = [for k, v in local.scp_yamls : v if v["ou_level"] == "lv3" && v["use"] == true]
  custom_scp_ou_lv3_use       = length(local.custom_scp_ou_lv3) > 0 ? local.custom_scp_ou_lv3[0]["use"] : false
  custom_scp_ou_lv3_inclusion = length(local.custom_scp_ou_lv3) > 0 ? (local.custom_scp_ou_lv3[0]["included_ou_names"] != null ? local.custom_scp_ou_lv3[0]["included_ou_names"] : []) : []
  custom_scp_ou_lv3_json      = length(local.custom_scp_ou_lv3) > 0 ? jsonencode(
    {
      Version   = "2012-10-17"
      Statement = [
        # scp_subs 디렉터리에 JSON 파일 추가 &&  scp_yamls 디렉터리에 yaml 파일 추가해야 함
        for subs in local.custom_scp_ou_lv3[0]["json_statements"] : jsondecode(local.scp_subs[subs])
      ]
    }
  ) : ""

  # Custom SCP for Specific OU (정책 일괄 적용하지 않고, 특정 OU에 적용) =================================================================
  # 유의: 상위 OU에서 정책이 상속되므로 상위 OU 내 선언 시 중복 추가 불필요
  custom_scp_ou_specific          = [for k, v in local.scp_yamls : v if v["ou_level"] == "specific" && v["use"] == true]
  custom_scp_ou_specific_use      = length(local.custom_scp_ou_specific) > 0 ? local.custom_scp_ou_specific[0]["use"] : false
  custom_scp_ou_specific_map_list = length(local.custom_scp_ou_specific) > 0 ? [
    for key in local.custom_scp_ou_specific[0]["array"] :
    tomap({
      ou_id = key["ou_id"], # OU ID
      json  = jsonencode(   # JSON Policy
        {
          Version   = "2012-10-17"
          Statement = [
            # scp_subs 디렉터리에 JSON 파일 추가 &&  scp_yamls 디렉터리에 yaml 파일 추가해야 함
            for subs in key["json_statements"] : jsondecode(local.scp_subs[subs])
          ]
        }
      )
    })
  ] : []
}
