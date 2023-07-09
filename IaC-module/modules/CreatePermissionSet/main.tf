# Query SSO Instances
data "aws_ssoadmin_instances" "sso_instance" {}

# Permission Set Create
resource "aws_ssoadmin_permission_set" "permission_set" {
  name         = var.permission_set_name
  instance_arn = tolist(data.aws_ssoadmin_instances.sso_instance.arns)[0]
  session_duration = var.session_duration
  description = var.description
}

# Apply inline policy to permission set
resource "aws_ssoadmin_permission_set_inline_policy" "inline_policy" {
  count              = var.policy_document != null ? 1 : 0
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso_instance.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn
  inline_policy      = var.policy_document
}

# Apply managed policy to permission set
resource "aws_ssoadmin_managed_policy_attachment" "managed_policy" {
  for_each           = { for item in var.managed_policy : item => item }
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso_instance.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn
  managed_policy_arn = each.value
}