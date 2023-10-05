from pulumi_azure_native import  containerservice
from public.resource_group import rg

# create vnet
# vnet = network.VirtualNetwork(
#     "devaks_vnet",
#     virtual_network_name="devaks-vnet",
#     address_space=network.AddressSpaceArgs(
#         address_prefixes=["10.16.0.0/12"],
#     ),
#     resource_group_name=rg.name
# )
# # subnet
# subnet = network.Subnet(
#     "devaks_sn",
#     subnet_name="devaks-sn",
#     virtual_network_name=vnet.name,
#     address_prefix="10.17.0.0/16",
#     resource_group_name=rg.name
# )

# Create cluster
# aks_name = config.get("managedClusterName")
# if aks_name is None:
#     aks_name = "devaks"

managed_cluster = containerservice.ManagedCluster(
    resource_name="mlp_cluster",
    resource_group_name=rg.name,
    agent_pool_profiles=[{
        "count": 1,
        "min_count": 1,
        "max_count": 5,
        #"max_pods": 30,
        "mode": "System",
        "name": "systempool",
        #"vnet_subnet_id": subnet.id,
        "enable_auto_scaling": True,
        "os_disk_size_gb": 30,
        "vm_size": "Standard_DS2_v2",
    }],
    network_profile={
        "networkPlugin": "kubelet",
        #"dns_service_ip": "10.10.1.254",
        #"docker_bridge_cidr": "172.17.0.1/16",
        #"service_cidr": "10.10.1.0/24"
    },
    
    auto_upgrade_profile={
        "upgrade_channel": "rapid",
    },
    enable_rbac=True,
    #kubernetes_version="1.22.2",
    dns_prefix="mlpaks",
    #node_resource_group=f"devaks-node-rg",
    identity={
        "type": "SystemAssigned"
    }
)

# add agent pool
# agent_pool = containerservice.AgentPool(
#     "nodePool1",
#     agent_pool_name="nodepool1",
#     count=1,
#     min_count=1,
#     max_count=5,
#     resource_group_name=rg.name,
#     resource_name_=managed_cluster.name,
#     enable_auto_scaling=True,
#     vm_size="Standard_DS2_v2"
# )

# creds = pulumi.Output.all(rg.name, managed_cluster.name).apply(
#     lambda args:
#     containerservice.list_managed_cluster_user_credentials(
#         resource_group_name=args[0],
#         resource_name=args[1]))

# # Export kubeconfig
# encoded = creds.kubeconfigs[0].value
# kubeconfig = encoded.apply(
#     lambda enc: base64.b64decode(enc).decode())
# pulumi.export("kubeconfig", kubeconfig)
