variable "permission_set_name" {
  type = string
}

variable "session_duration" {
  type = string
}

variable "policy_document" {
  type = string
}

variable "managed_policy" {
  type = list(string)
}

variable "description" {}
