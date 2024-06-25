variable "users" {
  type = list(object({
    display_name = string
    user_name    = string
    given_name   = string
    family_name  = string
    email        = string
  }))
  default = [
    {
      display_name = "Daniel Nascimento"
      user_name    = "Daniel"
      given_name   = "Daniel"
      family_name  = "Nascimento"
      email        = "@gmail.com"
    },
    {
      display_name = "Augusto Haziro"
      user_name    = "Augusto"
      given_name   = "Augusto"
      family_name  = "Haziro"
      email        = "@gmail.com"
    }
  ]
}
variable "group" {
    type = list(object({
    display_name = string
    description = string
    }))
    default = [
    {
      display_name = "Admin"
      description = "Grupo de administradores"
    }
    ]
}
variable "permissions_set" {
    default = "AdministratorAccess-Permission"
}
variable "policys_managedBy" {
    type = list(object({
    managed_policy_arn = string
    }))
    default = [
    {
      managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
    }
    ]
}
variable "principal_type" {
  default = "GROUP"
}
variable "target_type" {
  default = "AWS_ACCOUNT"
}
variable "id_accounts" {
    type = list(object({
    target_id = string
    }))
    default = [
    {
      target_id = ""
    },
    {
      target_id = ""
    },
    {
      target_id = ""
    }
    ]
}