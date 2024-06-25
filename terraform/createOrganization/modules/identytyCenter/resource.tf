data "aws_ssoadmin_instances" "example" {}

resource "aws_identitystore_user" "example" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
  count = length(var.users)
  display_name = var.users[count.index].display_name
  user_name    = var.users[count.index].user_name
  name {
    given_name  = var.users[count.index].given_name
    family_name = var.users[count.index].family_name
  }
  emails {
    value = var.users[count.index].email
  }
}

resource "aws_identitystore_group" "example" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
  display_name      = var.group[0].display_name
  description       = var.group[0].description
}

resource "aws_identitystore_group_membership" "example" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
  count             = length(var.users)
  group_id          = aws_identitystore_group.example.group_id
  member_id         = aws_identitystore_user.example[count.index].user_id
}

resource "aws_ssoadmin_permission_set" "administrator_access_permissionset" {
  name         = var.permissions_set
  instance_arn = tolist(data.aws_ssoadmin_instances.example.arns)[0]
}

resource "aws_ssoadmin_managed_policy_attachment" "administrator_access_managed_policy_attachment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  count              = length(var.policys_managedBy)
  managed_policy_arn = var.policys_managedBy[0].managed_policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator_access_permissionset.arn
}

resource "aws_ssoadmin_account_assignment" "example" {
  count              = length(var.id_accounts)
  instance_arn       = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.administrator_access_permissionset.arn

  principal_id   = aws_identitystore_group.example.group_id
  principal_type = var.principal_type

  target_id   = var.id_accounts[count.index].target_id 
  target_type = var.target_type
}