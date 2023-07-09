locals {
  #   공통
  VAULT_ADDR        = "https://vault-poc.site:8200"
  #   AWS Credentials engine
  REGION            = "ap-northeast-2"
  #   KV store engine
  VAULT_AWS_BACKEND = "aws-c760-ct-mgmt"
  VAULT_AWS_ROLE    = "orgfullaccess-test"
}