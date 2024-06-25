# Terraform
Esse readme tem como objetivo orientar sobre o terraform
Esse terraform tem como objetivo criar uma organização, com politicas SPC e fornecer acesso aos contribuintes no projeto.
A organização foi separada por ambientes, sendo ela DEV, HML e PRD.

## Exec Terraform
Para executar o terraform primeiramente, deverá executar os módulos de organization e SCP, posterior a isso deverá ir na console aws no recurso do IAM identity Center e habilitar manualmente a utilização do mesmo. *até o momento não existe forma de habilitá-lo utilizando terraform*
## Modulos
Esse terraform foi separado por modulos, sendo eles:

**Organization**
Criado uma organização adicionando contas pré existentes.

**SCP**
Criado apenas uma politica de SCP de testes, fornecendo acesso total ao S3.

**IAM identityCenter**
Criado um permission set de AdministratorAcess, fornecendo acesso ao grupo Admin, adicionando usuarios a esse gruopo e dando permissão nas contas de desenvolvimento, homologação e produção.