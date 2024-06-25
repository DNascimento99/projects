## Comandos para execução da stack
```bash
aws s3 mb s3://ec2-imagebuilders3-dev

sam build --use-container

sam package \
    --output-template-file packaged.yaml \
    --s3-bucket ec2-imagebuilders3-dev
sam deploy \
    --template-file packaged.yaml \
    --stack-name Ec2-Image-Builder-With-ASG-InstanceRefresh \
    --capabilities CAPABILITY_IAM 

sam delete \
--stack-name Ec2-Image-Builder-With-ASG-InstanceRefresh
```
*Projeto em andamento*