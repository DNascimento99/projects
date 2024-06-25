resource "aws_organizations_organization" "org" {
  aws_service_access_principals = var.services_principals
  feature_set = var.feature_set
  enabled_policy_types = var.policys
}

resource "null_resource" "org_accounts1" {
  provisioner "local-exec" {
    command = var.command1
  }
   depends_on = [
    aws_organizations_organization.org
  ]
}
resource "null_resource" "org_accounts2" {
  provisioner "local-exec" {
    command = var.command2
  }
   depends_on = [
    null_resource.org_accounts1
  ]
}
resource "null_resource" "org_accounts3" {
  provisioner "local-exec" {
    command = var.command3
  }
   depends_on = [
    null_resource.org_accounts2
  ]
}
