variable "aws_region" {
  default = "us-east-1"
  description = "regiao da organizacao"
}
variable "feature_set" {
  default = "ALL"
}
variable "policys" {
  type = list(string)
  default = [
    "SERVICE_CONTROL_POLICY"
  ]
  description = "policys a serem habilitadas na organização"
}
variable "services_principals" {
  type = list(string)
  default = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "sso.amazonaws.com" 
  ]
  description = "servicos habilitados na criacao da organizacao"
}
variable "command1" {
  default = "aws organizations invite-account-to-organization --target   '{\"Type\": \"EMAIL\", \"Id\": \"@gmail.com\"}' --notes \" Production account\" --profile=\"default\""
  description = "adicao da conta dev a organizacao"
}
variable "command2" {
  default = "aws organizations invite-account-to-organization --target   '{\"Type\": \"EMAIL\", \"Id\": \"@gmail.com\"}' --notes \" Production account\" --profile=\"default\""
  description = "adicao da conta hml a organizacao"
}
variable "command3" {
  default = "aws organizations invite-account-to-organization --target   '{\"Type\": \"EMAIL\", \"Id\": \"@gmail.com\"}' --notes \" Production account\" --profile=\"default\""
  description = "adicao da conta prd a organizacao"
}