from pulumi_azure_native import network
from public.resource_group import rg

### load balancer
network.FrontendEndpointArgs
load_balancer = network.LoadBalancer("loadBalancer",
    frontend_ip_configurations=[
        network.FrontendIPConfigurationArgs(
            name="LoadBalancerFrontEnd",
            # private_ip_allocation_method="Dynamic",
            # subnet=network.SubnetArgs(
            #     id=networking.tu_sub.id
            # ),
            public_ip_address=network.PublicIPAddressArgs(
                id="/subscriptions/67aa02ec-a43c-4b62-808a-12113f131ee8/resourceGroups/RG-PulumiTesting-DevTest/providers/Microsoft.Network/publicIPAddresses/lb-external-frontend-tu",
            )
        ),
        # network.FrontendIPConfigurationArgs(
        #     name="lb-external-frontend-api",
        #     public_ip_address=network.PublicIPAddressArgs(
        #         id="/subscriptions/67aa02ec-a43c-4b62-808a-12113f131ee8/resourceGroups/RG-PulumiTesting-DevTest/providers/Microsoft.Network/publicIPAddresses/ip-tuqa-api",
        #     ),
        # )
    ],
    inbound_nat_pools=[],
    inbound_nat_rules=[],
    load_balancer_name="std-external-lb-qatu",
    probes=[network.ProbeArgs(
        interval_in_seconds=5,
        name="probe-lb",
        number_of_probes=2,
        port=443,
        protocol="Https",
        request_path="/alive.txt",
    )],
    # load_balancing_rules=[
    #     network.LoadBalancingRuleArgs(
    #         backend_address_pool=network.SubResourceArgs(
    #             id="/subscriptions/subid/resourceGroups/rg1/providers/Microsoft.Network/loadBalancers/lb/backendAddressPools/be-lb",
    #         ),
    #         backend_port=80,
    #         enable_floating_ip=True,
    #         frontend_ip_configuration=network.SubResourceArgs(
    #             id="/subscriptions/subid/resourceGroups/rg1/providers/Microsoft.Network/loadBalancers/lb/frontendIPConfigurations/fe-lb",
    #         ),
    #         frontend_port=80,
    #         idle_timeout_in_minutes=15,
    #         load_distribution="Default",
    #         name="rulelb",
    #         probe=network.SubResourceArgs(
    #             #id=loadbalancer.probes.id,
    #             id="/subscriptions/subid/resourceGroups/rg1/providers/Microsoft.Network/loadBalancers/lb/probes/probe-lb",
    #         ),
    #         protocol="Tcp",
    #     ),
        
    # ],
    location="eastus",
    outbound_rules=[],
    
    resource_group_name=rg.name,
    sku=network.LoadBalancerSkuArgs(
        name="Standard",
        tier="Regional",
    )
)