# It receives the yaml file path declared in Terraform Cloud and reads the contents of the yaml file.
locals {
  assign_yaml_contents = flatten([
    for filename in fileset("${var.assign_yaml_path}", "*.yaml") : yamldecode(file("${var.assign_yaml_path}/${filename}")).assigns if fileexists("${var.assign_yaml_path}/${filename}")
  ])
}