import pulumi
import pulumi_azure_native as azure_native
from public.resource_group import rg

secret = azure_native.keyvault.Secret("secret",
    properties=azure_native.keyvault.SecretPropertiesArgs(
        value="secret-value",
    ),
    resource_group_name=rg.name,
    secret_name="stub-test",
    vault_name="sample-vault")