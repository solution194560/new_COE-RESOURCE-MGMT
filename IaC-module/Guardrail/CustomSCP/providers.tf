# Terraform Block
# TODO: Check version
terraform {
  required_version = ">= 1.4" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.62"
    }
    vault = {
      source  = "hashicorp/vault"
      # 3.16.0 버전 버그 이슈 (네임스페이스 override issue)
      version = "3.15.2"
    }
  }
}

provider "aws" {
  region     = "ap-northeast-2"
  access_key = data.vault_aws_access_credentials.aws_creds.access_key
  secret_key = data.vault_aws_access_credentials.aws_creds.secret_key
  token      = data.vault_aws_access_credentials.aws_creds.security_token
}

# 공통
provider "vault" {
  address = var.vault_web
  auth_login {
    path = var.vault_auth_login_path

    parameters = {
      role_id   = var.login_approle_role_id
      secret_id = var.login_approle_secret_id
    }
    namespace = var.vault_namespace
  }
  ca_cert_file = var.vault_ca_cert_file
  skip_child_token = true
}

#  AWS Credentials engine
data "vault_aws_access_credentials" "aws_creds" {
  namespace = var.vault_namespace
  backend   = var.vault_aws_backend
  role      = var.vault_aws_role
  type      = "sts"
}
