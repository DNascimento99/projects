import botocore
import boto3
from botocore.exceptions import NoCredentialsError
from datetime import datetime, timedelta
from prettytable import PrettyTable
from arnparse import arnparse
import os

def get_acm_client(aws_access_key_id, aws_secret_access_key, aws_session_token, region='sa-east-1'):
    return boto3.client('acm', region_name=region, aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key, aws_session_token=aws_session_token)

def get_role_name_from_arn(role_arn):
    parsed_arn = arnparse(role_arn)
    return parsed_arn.resource.split('/')[-1] if parsed_arn.resource else None
    
def get_account_id():
    sts_client = boto3.client('sts')
    return sts_client.get_caller_identity()['Account']

def get_account_id_from_role_arn(role_arn):
    return role_arn.split(":")[4]

def assume_role(account_id, role_name):
    sts_client = boto3.client('sts')
    role_arn = f'arn:aws:iam::{account_id}:role/{role_name}'
    assumed_role = sts_client.assume_role(
        RoleArn=role_arn,
        RoleSessionName='AssumeRoleSession'
    )
    credentials = assumed_role['Credentials']
    return credentials
    
def get_allowed_roles():
    iam_client = boto3.client('iam')
    policy_name = policy_name = os.environ.get('PolicyACMList')
    roles = []
    try:
        response = iam_client.get_policy(PolicyArn=f'arn:aws:iam::{get_account_id()}:policy/{policy_name}')
        policy_version_id = response['Policy']['DefaultVersionId']
        response = iam_client.get_policy_version(PolicyArn=f'arn:aws:iam::{get_account_id()}:policy/{policy_name}', VersionId=policy_version_id)
        policy_document = response['PolicyVersion']['Document']
        if 'Statement' in policy_document:
            for statement in policy_document['Statement']:
                if 'Action' in statement and 'sts:AssumeRole' in statement['Action']:
                    if 'Resource' in statement:
                        roles.extend(statement['Resource'])
    except botocore.exceptions.ClientError as e:
        error_message = f"Erro ao obter roles permitidas na conta {get_account_id()}: {str(e)}"
        print(error_message)
    except Exception as e:
        error_message = f"Erro inesperado ao obter roles permitidas: {str(e)}"
        print(error_message)
    return roles

def send_notification(account_id, arn, domain_name, expiration_date):
    sns_client = boto3.client('sns', region_name='us-east-1') ## Região onde o SNS está criado
    topic_arn = topic_arn = os.environ.get('SNS_TOPIC_ARN')
    message = f'O certificado {arn} (ID da Conta: {account_id}) para o domínio {domain_name} expirará em {expiration_date}.'
    try:
        sns_client.publish(TopicArn=topic_arn, Message=message, Subject='Aviso de Expiração do Certificado')
        print(f"Notificação enviada para {topic_arn}")
    except NoCredentialsError:
        print("Credenciais AWS não encontradas. Certifique-se de que as credenciais estão configuradas corretamente.")

def list_certificates(event, context):
    allowed_roles = get_allowed_roles()
    expiration_threshold_days = 60
    table = PrettyTable()
    table.field_names = ["ID da Conta", "Região", "ARN", "Nome", "Data de Expiração", "Recursos Atrelados"]
    for role_arn in allowed_roles:
        role_name = get_role_name_from_arn(role_arn)
        assumed_account_id = get_account_id_from_role_arn(role_arn)
        credentials = assume_role(assumed_account_id, role_name)
        account_id = assumed_account_id
        for region in ['sa-east-1', 'us-east-1']: ## Informar regiões onde os certificados serão obtidos
            acm_client = get_acm_client(
                aws_access_key_id=credentials['AccessKeyId'],
                aws_secret_access_key=credentials['SecretAccessKey'],
                aws_session_token=credentials['SessionToken'],
                region=region
            )
            certificates = acm_client.list_certificates()['CertificateSummaryList']
            for cert in certificates:
                arn = cert['CertificateArn']
                cert_details = acm_client.describe_certificate(CertificateArn=arn)['Certificate']
                if 'NotAfter' in cert_details:
                    days_until_expiration = (cert_details['NotAfter'].astimezone() - datetime.now().astimezone()).days
                else:
                    days_until_expiration = None
                recursos_atrelados = cert_details['InUseBy'] if 'InUseBy' in cert_details else ""
                if not recursos_atrelados:
                    table.add_row(["--------------", "----------", "-" * max(2, len(arn)), "-" * max(2, len(cert_details['DomainName'])), "-" * max(26, len(str(cert_details.get('NotAfter', '')))), "-" * max(100, len(recursos_atrelados))])
                    recursos_atrelados = ""
                    table.add_row([account_id, region, arn, cert_details['DomainName'], str(cert_details.get('NotAfter', '')), recursos_atrelados])
                else:
                    table.add_row(["--------------", "----------", "-" * max(2, len(arn)), "-" * max(2, len(cert_details['DomainName'])), "-" * max(2, len(str(cert_details.get('NotAfter', '')))), "-" * max(100, len(recursos_atrelados))])
                    recursos_atrelados = '\n'.join(map(lambda x: f"{x}", recursos_atrelados))
                    table.add_row([account_id, region, arn, cert_details['DomainName'], str(cert_details.get('NotAfter', '')), recursos_atrelados])
                if days_until_expiration is not None and days_until_expiration <= expiration_threshold_days and days_until_expiration > 0:
                    expiration_date = cert_details.get('NotAfter', '').isoformat()
                    send_notification(account_id, arn, cert_details['DomainName'], expiration_date)
                if days_until_expiration is not None and days_until_expiration <= 0:
                    expiration_date = cert_details.get('NotAfter', '').isoformat()
                    send_notification(account_id, arn, cert_details['DomainName'], expiration_date)
    table_string = table.get_string().strip()
    response_data = {'certificates': table_string.split('\n')}
    return response_data
    
def lambda_handler(event, context):
    return list_certificates(event, context)