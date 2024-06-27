# Golden Image

## Objetivo
Esse projeto tem como objetivo a criação de um processo de constante atualização pra uma Golden Image confome fluxo a baixo

![Diagrama](image.png) 

## Processo

O processo inicia-se com um Payload (*uma listra de instruções a serem executadas no processo de criação da Golden Image*) deployado em um repositorio, ao receber esse Payload, será startado uma Pipeline com o objetivo de mover esse payload para um Bucket do S3. após receber Payload no Bucket do S3, um EventBridge irá trigar o EC2 Image Builder com o objetivo de começar a construção da nossa Golden Image.

No EC2 Image Builder, o processo se dará na execução do payload para correções ou instalação de novos pacotes. Após isso, será criado uma AMI com as devidas correções; também será disparado a nova AMI para um Launch Template e após esse disparo um SNS é acionado para trigar um Lambda.

O Lambda por sua vez terá a responsabilidade de iniciar um instance refresh nas instâncias do ASG associada ao Cluster ECS. Esse processo irá substiruir as instâncias com a AMI depressiada e irá iniciar instâncias com a AMI corrigida. O lambda também terá a responsabilidade de fazer uma checagem no Cluster ECS, ele validará se todos os serviços estão UP, caso contrário, inicia-se um processo de Rollback onde será iniciado novas instâncias com o a AMI depressiada.

*Projeto em andamento*