# Notas
## Organization
Utilizado bloco
```hcl
resource "null_resource" "org_accounts3" {
  provisioner "local-exec" {
    command = var.command3
  }
   depends_on = [
    null_resource.org_accounts2
  ]
}
```
Com ele foi possível adicionar contas pré existentes na organização, pois somente com ele consegui usando o aws cli para enviar os convites as contas. *não encontrei outra forma*
*em variables.tf deve-se informar o email para o convite.*

## Iam IdentityCenter
Utilizado Bloco
```hcl
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
      email        = 
    },
    {
      display_name = "Augusto Haziro"
      user_name    = "Augusto"
      given_name   = "Augusto"
      family_name  = "Haziro"
      email        = 
    }
  ]
}
```
Com ele conseguimos criar uma lista e consumir somente essa lista ao adicionar novos usuarios seperando-os por blocos. [count.index] itera sobre a lista e faz a contagem na sequencia de cada usuario criado. pode ser consumido por ordem conforme outros exemplos como [0],[1],[2]... conforme sua posição na lista.
*em variables.tf deve-se informar as contas em target_id*