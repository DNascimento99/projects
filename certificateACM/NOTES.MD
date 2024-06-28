## Comandos para execução da stack template.yml

```bash
aws s3 mb s3://s3-acm-list

sam build --use-container

sam package --output-template-file packaged.yaml --s3-bucket s3-acm-list --region us-east-1

sam deploy --template-file packaged.yaml --stack-name acm-list --capabilities CAPABILITY_NAMED_IAM --region us-east-1

sam delete --stack-name acm-list --region us-east-1
```

## Comandos para execução da stack createRole-Certificate-ACM.yaml

```bash
aws cloudformation create-stack-set --stack-set-name Create-Role-Project-Certificate-ACM --capabilities CAPABILITY_NAMED_IAM \
--template-body file://createRole-Certificate-ACM.yaml --region us-east-1 --permission-model SERVICE_MANAGED --auto-deployment Enabled=true,RetainStacksOnAccountRemoval=false

aws cloudformation create-stack-instances --stack-set-name Create-Role-Project-Certificate-ACM --deployment-targets OrganizationalUnitIds=(informar OrganizationID) --regions us-east-1

aws cloudformation delete-stack-set --stack-set-name Create-Role-Project-Certificate-ACM --region us-east-1
```
