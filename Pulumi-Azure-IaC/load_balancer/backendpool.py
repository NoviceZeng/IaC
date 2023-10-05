from pulumi_azure_native import network
from public import networking
from public.resource_group import rg

### backend pools for lb std-external-lb-qatu
load_balancer_backend_address_pool = network.LoadBalancerBackendAddressPool("loadBalancerBackendAddressPool",
    backend_address_pool_name="lb-std-backend-Snated",
    load_balancer_backend_addresses=[
        network.LoadBalancerBackendAddressArgs(
            name="vm-az-qa-web12",
            ip_address="10.1.37.4",
        ),
        # network.LoadBalancerBackendAddressArgs(
        #     name="vm-az-qa-web13",
        #     ip_address="10.1.37.5",
        # ),
    ],
    load_balancer_name="std-external-lb-qatu",
    resource_group_name=rg.name
)