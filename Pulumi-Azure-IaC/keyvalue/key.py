import pulumi
import pulumi_azure_native as azure_native
from public.resource_group import rg

key = azure_native.keyvault.Key("key",
    key_name="v",
    properties=azure_native.keyvault.KeyPropertiesArgs(
        kty="RSA",
    ),
    resource_group_name=rg.name,
    vault_name="sample-vault-name")