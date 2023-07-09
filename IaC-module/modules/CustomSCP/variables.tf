# Input Variables
variable "scp_name_prefix" {
  description = "Custom SCP Name Starts with"
  type        = string
  default     = "custom-scp"
}

variable "custom_scp_ou_lv1_use" {
  description = "OU Level 1 Custom SCP - Usage Flag (true or false)"
  type        = bool
  default     = false
}

variable "custom_scp_ou_lv1_json" {
  description = "OU Level 1 Custom SCP - JSON Policy"
  type        = string
  default     = ""
}

variable "custom_scp_ou_lv1_exclusion" {
  description = "OU Level 1 Custom SCP - Excluded OU Name List (blacklist)"
  type        = list(string)
  default     = []
}

variable "custom_scp_ou_lv2_use" {
  description = "OU Level 2 Custom SCP - Usage Flag (true or false)"
  type        = bool
  default     = false
}

variable "custom_scp_ou_lv2_json" {
  description = "OU Level 2 Custom SCP - JSON Policy"
  type        = string
  default     = ""
}

variable "custom_scp_ou_lv2_exclusion" {
  description = "OU Level 2 Custom SCP - Excluded OU Name List (blacklist)"
  type        = list(string)
  default     = []
}

variable "custom_scp_ou_lv3_use" {
  description = "OU Level 3 Custom SCP - Usage Flag (true or false)"
  type        = bool
  default     = false
}

variable "custom_scp_ou_lv3_json" {
  description = "OU Level 3 Custom SCP - JSON Policy"
  type        = string
  default     = ""
}

variable "custom_scp_ou_lv3_inclusion" {
  description = "OU Level 3 Custom SCP - Included OU Name List (whitelist)"
  type        = list(string)
  default     = []
}

variable "custom_scp_ou_specific_use" {
  description = "OU Specific Custom SCP - Usage Flag (true or false)"
  type        = bool
  default     = false
}

variable "custom_scp_ou_specific_map_list" {
  description = "OU Specific Custom SCP - map list of OU ID and JSON Policy"
  type        = list(map(string))
  default     = []
}