terraform {
  required_providers {
    okta = {
      source = "okta/okta"
      version = "~> 4.0.0"
    }
    vault = {
      source  = "hashicorp/vault"
      # 3.16.0 버전 버그 이슈 (네임스페이스 override issue)
      version = "3.15.2"
    }
  }
}

# okta provider config
provider "okta" {
  org_name  = "lguplus"
  base_url  = "okta.com"
  api_token = data.vault_kv_secret_v2.okta.data["api_token"]
}

# vault provider config
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
