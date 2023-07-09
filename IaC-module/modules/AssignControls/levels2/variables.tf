# Variables
variable "ou_name" {
  type = string
  description = "The name of the OU"
}
variable "parent_ou_name" {
  type = string
  description = "The name of the parent OU"
}
variable "control_prefix" {
  description = "The prefix for the Control Tower control ARNs"
  type        = string
}
variable "ou_controls" {
  description = "OU controls map"
  type        = list(string)
}
