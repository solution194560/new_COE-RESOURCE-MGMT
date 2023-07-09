# okta application id lookup
data "okta_app" "app_id_check" {
  label = var.okta_app_name
}

# okta group create
resource "okta_group" "group_create" {
  count = var.groups != null ? 1 : 0
  name        = var.groups
  description = var.description
}

# okta group application assign
resource "okta_app_group_assignment" "group_assign" {
  count = okta_group.group_create != null ? 1 : 0
  app_id             = data.okta_app.app_id_check.id
  group_id           = okta_group.group_create[count.index].id
  retain_assignment  = true
}