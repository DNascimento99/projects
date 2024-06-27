## Comandos para execução da stack
```bash
aws s3 mb s3://s3-acm-list

sam build --use-container

sam package --output-template-file packaged.yaml --s3-bucket s3-acm-list --region us-east-1

sam deploy --template-file packaged.yaml --stack-name s3-acm-list --capabilities CAPABILITY_IAM --region us-east-1

sam delete --stack-name s3-acm-list --region us-east-1
```

