# aws organization lookup
data "aws_organizations_organization" "selected" {}

# aws sso instance lookup
data "aws_ssoadmin_instances" "selected" {}

# Group ID lookup
data "aws_identitystore_group" "groups" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.selected.identity_store_ids)[0]
  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = var.group
    }
  }
}

# Permission Set lookup
data "aws_ssoadmin_permission_set" "list" {
  instance_arn = tolist(data.aws_ssoadmin_instances.selected.arns)[0]
  name         = var.permissionset
}

# Permission set and groups, account assign
resource "aws_ssoadmin_account_assignment" "groups" {
  for_each = { for item in var.account : item => item }

  instance_arn       = tolist(data.aws_ssoadmin_instances.selected.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.list.arn
  principal_id       = data.aws_identitystore_group.groups.group_id
  target_id          = each.value
  principal_type     = "GROUP"
  target_type        = "AWS_ACCOUNT"
}