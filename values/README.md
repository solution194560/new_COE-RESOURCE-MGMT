# 운영 가이드

## Table of content
* [1. 사용자 통합 인증 및 권한 관리](#1-사용자-통합-인증-및-권한-관리)
    * [1-1. Okta Group Create](#1-1-okta-group-create)
    * [1-2. Pemission Set Create](#1-2-pemission-set-create)
    * [1-3. Permission Set & Group & Account Assign](#1-3-permission-set--group--account-assign)
* [2. 표준 가드레일 관리](#2-표준-가드레일-관리)
    * [2-1. AssignControls](#2-1-how-to-use---assigncontrols)
    * [2-2. AssignCustomSCP](#2-2-how-to-use---assigncustomscp)



## 1. 사용자 통합 인증 및 권한 관리

### 1-1. Okta Group Create
Okta에 그룹을 생성하고 Okta Application에 Assign을 하는 테라폼 코드를 실행합니다.

Clone the project
```bash
  git clone https://github.com/AWS-Control-Tower/COE-RESOURCE-MGMT.git
```

Go to the project directory
```bash
  cd values/CNS760/IAMCenterAdmin/OktaGroup/
```

Write yaml content. (Modify or add yaml files.)
 + name : Okta에 사용할 Group 이름을 기입합니다.
 + description : Okta Group에 대한 설명을 기입합니다.
```bash
  groups :
    - name : test01
      description : "okta test01 group"
    - name : test02
      description : "okta test02 group"
```

### 1-2. Pemission Set Create
Permission Set을 생성하는 테라폼 코드를 실행합니다.

Clone the project
```bash
  git clone https://github.com/AWS-Control-Tower/COE-RESOURCE-MGMT.git
```
Go to the project directory
```bash
  cd values/CNS760/IAMCenterAdmin/PermissionSet/
```

(optional) inline policy를 추가할 경우 inline_policy 폴더에 json 파일을 추가합니다.
+ inline_policy 폴더에 사전에 정의 된 inline policy json 파일이 저장되어 있습니다.
```bash
├── inline_policy
   ├── All-Comm-IAMAdmin-inline.json
   ├── BSS-IP-restrict.json
   ├── DMSAdmin-inline.json
   ├── EC2OnOff-inline.json
   ├── EKSAdmin-inline.json
   ├── IAM-test.json
   ├── Payer1-IP-restrict.json
   └── admin_Payer1-IP-restrict.json
```
```bash
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      "Resource": "*"
    }
  ]
}
```



Write yaml content. (Modify or add yaml files.)
+ name : Permission Set 이름을 기입합니다.
+ inline_policy : 사전에 정의된 inline policy json파일 이름을 기입합니다. (옵션)
+ managed_policy : managed policy arn 주소를 기입합니다. (옵션)
+ description : Permmission Set에 설명을 기입합니다.
```bash
  permissions:
    - name: "test-PrePS"
      inline_policy: "test.json"
      managed_policy: 
        - "arn:aws:iam::aws:policy/AmazonVPCReadOnlyAccess"
        - "arn:aws:iam::aws:policy/AutoScalingReadOnlyAccess"
        - "arn:aws:iam::aws:policy/ElasticLoadBalancingReadOnly"
      description: "test permissions"
```

### 1-3. Permission Set & Group & Account Assign
AWS IAM Identity Center내 생성된 Group에 Permission Set과 Account를 할당합니다.

Clone the project
```bash
  git clone https://github.com/AWS-Control-Tower/COE-RESOURCE-MGMT.git
```

Go to the project directory
```bash
  cd values/CNS760/IAMCenterAdmin/AccountAssign/
```

Write yaml content. (Modify or add yaml files.)
+ group : 권한을 부여할 Group 이름을 기입합니다.
+ permissionset : Group에 부여할 Permission Set 이름을 기입합니다.
+ account : Group 할당하고자하는 AWS Account ID를 기입합니다.
```bash
  assigns:
    - group: test01
      permissionset: test-PrePS
      account: 
        - "123456789012"
        - "987654321098"
```

## 2. 표준 가드레일 관리

### 2-1. AssignControls
AWS Organizations 서비스의 Custom SCP(Service Control Policy)를 생성하고 할당하는 테라폼 코드를 실행합니다.

Clone the project
```bash
  git clone https://github.com/AWS-Control-Tower/COE-RESOURCE-MGMT.git
```

Go to the project directory
```bash
  cd values/CNS760/ControlTowerManagement/AssignControls
```

OU별 Policy 적용 내역은, `AssignControls` 폴더에 정의되어 있습니다. 
* 변경이 필요한 경우, OU Level별로 `*.yml` 파일을 수정합니다. 
 + 컨트롤의 리스트(level 별 OU Naming)
   +  level1 : 최상위OU.yaml 
   +  level2 : 최상위OU-상위OU.yaml
   +  level3 : 최상위OU-상위OU-OU.yaml

(level,OU네임,최상위OU-상위OU-OU)
#AAssignControls 폴더 파일 구분
```
└── AssignControls
    ├── infrastructure.yml
    ├── policystaging.yaml
    ├── suspended.yaml
    ├── sandbox.yaml
    └── Workload-nucube.yaml
```

#Level별 Controls yaml 형식
```
#######level 1 #######
######################
level: 1                               #[필수] OU level 구분
ou_name: Infrastructure                #[필수] 최상위OU
ou_controls:                           #최소 controls 1개이상 작성
  - IHLKDRJWXUHX                       #controls Rule name


#######level 2 #######
######################
level: 2                               #[필수] OU levle 구분
ou_name: nucube                        #[필수] 상위 OU
parent_ou_name: Workload               #[필수] 최상위 OU
ou_controls:                           #최소 controls 1개이상 작성
  - IHLKDRJWXUHX                       #controls Rule name
  - AWS-GR_RESTRICT_ROOT_USER
  - AWS-GR_ROOT_ACCOUNT_MFA_ENABLED


#######level 3 #######
######################
level: 3                                #[필수] OU levle 구분
ou_name: Sandbox3                       #[필수] OU
parent_ou_name: Sandbox2                #[필수] 상위 OU
grandparent_ou_name: Sandbox            #[필수] 최상위 OU
ou_controls:                            #최소 controls 1개이상 작성 
  - AWS-GR_RESTRICTED_SSH               #controls Rule name
  - AWS-GR_RESTRICTED_COMMON_PORTS
```



### 2-2. AssignCustomSCP
AWS Organizations 서비스의 Custom SCP(Service Control Policy)를 생성하고 할당하는 테라폼 코드를 실행합니다.

Clone the project
```bash
  git clone https://github.com/AWS-Control-Tower/COE-RESOURCE-MGMT.git
```

Go to the project directory
```bash
  cd values/CNS760/ControlTowerManagement/AssignCustomSCP
```

(optional) policy 추가가 필요한 경우, `scp_subs` 폴더에 json 파일을 추가합니다.
* `scp_subs` 폴더에 사전 논의된 Deny Policy Statement 가 저장되어있습니다. 
```
├── scp_subs
   ├── DenyLeaveOrgz.json
   ├── DenyRamShareOutsideOrgz.json
   ├── DenyUpdateCloudTrail.json
   └── DenyUserPwPolicyChangeWithException.json
```
* 다른 종류의 Deny Policy가 필요한 경우, Sid와 파일명이 동일하도록 아래 예시와 같이 JSON 파일을 생성합니다. (예, DenyLeaveOrgz.json)
```json
{
  "Sid": "DenyLeaveOrgz",
  "Effect": "Deny",
  "Action": [
    "organizations:LeaveOrganization"
  ],
  "Resource": "*"
}
```

OU별 Policy 적용 내역은, `scp_yamls` 폴더에 정의되어 있습니다. 
* 변경이 필요한 경우, OU Level별로 `*_lv1.yaml`,`*_lv2.yaml`,`*_lv3.yaml` 파일을 수정합니다. 
* OU Level별이 아닌, 개별 OU에 적용이 필요한 경우, `*_specific.yaml` 파일을 수정합니다.
```
└── scp_yamls
    ├── custom_scp_ou_lv1.yaml        # Lv1 OU 일괄 적용
    ├── custom_scp_ou_lv2.yaml        # Lv2 OU 일괄 적용
    ├── custom_scp_ou_lv3.yaml        # Lv3 OU 일괄 적용
    └── custom_scp_ou_specific.yaml   # 개별 OU ID에 적용
```
* lv1, lv2는 **미적용 대상** OU 이름 목록을 `excluded_ou_names` 하위에 ou 이름을 추가하여 예외처리 합니다. (blacklist 방식) 
```
# OU lv1 단위로 Custom SCP 적용
# 제외할 OU 이름을 excluded_ou_names 명시
custom_scp:
  ou_level: lv1         # [필수] 일괄 적용 대상 ou level (lv1 / lv2 / lv3 / specific)
  use: true             # [필수] enable 여부 (true or false)
  excluded_ou_names:    # [선택] 예외 미적용 대상 ou name 목록 (없을 시 값만 주석 처리)
    - Workload
  json_statements:      # [필수] 공통 적용 scp json statement 목록
    - DenyLeaveOrgz
    - DenyRamShareOutsideOrgz
    - DenyUpdateCloudTrail
    - DenyUserPwPolicyChangeWithException
```

* lv3는 **적용 대상 OU 이름 목록**을 `included_ou_names` 하위에 ou 이름을 추가하여 정책을 적용합니다. (whitelist 방식)
```
# OU lv3 단위로 Custom SCP 적용
# "포함"할 OU 이름을 included_ou_names 내에 작성
custom_scp:
  ou_level: lv3         # [필수] 일괄 적용 대상 ou level
  use: true             # [필수] enable 여부 (true or false)
  included_ou_names:    # [선택] 포함할 ou name 목록 (없을 시 값만 주석 처리)
#    - workloooads_3
  json_statements:      # [필수] 공통 적용 scp json statement 목록
    - DenyLeaveOrgz
```

* specific은 **개별 OU ID, 정책**을 `array` 하위에 `ou_id` 및 `json_statements`에 추가합니다.   
```
# 개별 OU에 Custom SCP 적용 (일괄 적용하지 않음)
# 정책을 적용할 "OU의 ID" 및 scp json statement 조합 목록 작성
custom_scp:
  ou_level: specific          # [필수] 일괄 적용 대상 ou level (lv1 / lv2 / lv3 / specific)
  use: true                   # [필수] enable 여부 (true or false)
  array:
    - ou_id: ou-rzme-aaaaaaaa # [필수] 적용 대상 ou id
      json_statements:        # [필수] 개별 적용 scp json statement 목록
        - DenyLeaveOrgz
        - DenyUpdateCloudTrail
    - ou_id: ou-rzme-bbbbbbbb # [필수] 적용 대상 ou id
      json_statements:        # [필수] 개별 적용 scp json statement 목록
        - DenyUserPwPolicyChangeWithException
        - DenyRamShareOutsideOrgz
```
