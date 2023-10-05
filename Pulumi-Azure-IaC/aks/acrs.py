import pulumi_azure_native as pulumi_azure
from public.resource_group import rg

# create acr and assign a role 

acr = pulumi_azure.containerregistry.Registry("acr",
    admin_user_enabled=False,
    resource_group_name=rg.name,
    location=rg.location,
    registry_name="MlpClusterAcr",
    sku=pulumi_azure.containerregistry.SkuArgs(
        name="Basic",
    ),
    tags={
        "key": "mlp_cluster_acr",
    })


# acr_assignment = pulumi_azure.authorization.RoleAssignment(
#     "acrAssignment",
#     scope=acr.id,
#     role_assignment_name="AcrPull",
#     principal_id=managed_cluster.kubelet_identities[0].objectId
# )

# acr_assignment = pulumi_azure.authorization.Assignment(
#     "acrAssignment",
#     scope=acr.id,
#     role_definition_name="AcrPull",
#     principal_id=managed_cluster.kubelet_identities[0].objectId
# )