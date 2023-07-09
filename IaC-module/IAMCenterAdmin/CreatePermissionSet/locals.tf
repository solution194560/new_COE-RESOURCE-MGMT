# Managed Policy arn Declaration
locals {
  managed_policies = {
    "AdministratorAccess" = "arn:aws:iam::aws:policy/AdministratorAccess"
    "AmazonRDSReadOnlyAccess" = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
    "PowerUserAccess" = "arn:aws:iam::aws:policy/PowerUserAccess"
    "ReadOnlyAccess" = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    "SecurityAudit" = "arn:aws:iam::aws:policy/SecurityAudit"
    "ViewOnlyAccess" = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
    "SupportUser" = "arn:aws:iam::aws:policy/job-function/SupportUser"
    "SystemAdministrator" = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
    "DatabaseAdministrator" = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
    "DataScientist" = "arn:aws:iam::aws:policy/job-function/DataScientist"
    "NetworkAdministrator" = "arn:aws:iam::aws:policy/job-function/NetworkAdministrator"
    "Billing" = "arn:aws:iam::aws:policy/job-function/Billing"
    "IAMFullAccess" = "arn:aws:iam::aws:policy/IAMFullAccess"
    "AmazonVPCReadOnlyAccess" = "arn:aws:iam::aws:policy/AmazonVPCReadOnlyAccess"
    "AutoScalingReadOnlyAccess" = "arn:aws:iam::aws:policy/AutoScalingReadOnlyAccess"
    "ElasticLoadBalancingReadOnly" = "arn:aws:iam::aws:policy/ElasticLoadBalancingReadOnly"
    "AWSDirectConnectReadOnlyAccess" = "arn:aws:iam::aws:policy/AWSDirectConnectReadOnlyAccess"
    "AWSNetworkManagerReadOnlyAccess" = "arn:aws:iam::aws:policy/AWSNetworkManagerReadOnlyAccess"
    "AmazonRoute53ReadOnlyAccess" = "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess"
    "CloudWatchFullAccess" = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
    "AWSCloudTrail_FullAccess" = "arn:aws:iam::aws:policy/AWSCloudTrail_FullAccess"
    "AmazonEC2FullAccess" = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
    "AmazonRoute53FullAccess" = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
    "AmazonVPCFullAccess" = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
    "AWSDirectConnectFullAccess" = "arn:aws:iam::aws:policy/AWSDirectConnectFullAccess"
    "AWSResourceAccessManagerFullAccess"  = "arn:aws:iam::aws:policy/AWSResourceAccessManagerFullAccess"
    "AWSSupportAccess" = "arn:aws:iam::aws:policy/AWSSupportAccess"
  }
}

# It receives the yaml file path declared in Terraform Cloud and reads the contents of the yaml file.
locals {
  permission_yaml_contents = flatten([
    for filename in fileset("${var.permissionset_yaml_path}", "*.yaml") : yamldecode(file("${var.permissionset_yaml_path}/${filename}")).permissions if fileexists("${var.permissionset_yaml_path}/${filename}")
  ])
}