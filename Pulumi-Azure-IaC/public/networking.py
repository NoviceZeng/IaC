from pulumi_azure_native import network
from public import var
from public.resource_group import rg

## create vnet    
vnet = network.VirtualNetwork("virtualNetwork",
    virtual_network_name="EastUS-PT-VNet",
    address_space=network.AddressSpaceArgs( 
        address_prefixes=["10.10.0.0/16"],
    ),
    resource_group_name=rg.name,
    location=rg.location
)
## create subnet and associated with network security group
def create_subnet():
    for subneting in var.subnet_list:
        network.Subnet(subneting["subnet_name"],
            subnet_name=subneting["subnet_name"],
            virtual_network_name=vnet.name,
            address_prefix=subneting["address_prefix"],
            resource_group_name=rg.name,
            network_security_group=network.NetworkSecurityGroupArgs(
                id=var.nsg_id + subneting["nsg_name"],
            )
       ) 
## subnet for Bastion
network.Subnet("AzureBastionSubnet",
    subnet_name="AzureBastionSubnet",
    virtual_network_name=vnet.name,
    address_prefix="10.10.100.0/24",
    resource_group_name=rg.name,
)    
## create application security group
def create_asg():
    for asg in var.asg_list:
        network.ApplicationSecurityGroup(asg["asg_name"],
            application_security_group_name=asg["asg_name"],
            location=rg.location,
            resource_group_name=rg.name)   
         
## create public ip
def create_pubip():
    for pubip in var.ip_list:
        network.PublicIPAddress(pubip["ip_name"],
            location=rg.location,
            public_ip_allocation_method="Static",
            public_ip_address_name=pubip["ip_name"],
            resource_group_name=rg.name,
            sku=network.PublicIPAddressSkuArgs(
                name=pubip["sku_name"],
                tier="Regional",
            )
        )

## vm bastion
bastion_host = network.BastionHost("BastionHostPTest",
    bastion_host_name="Bastion-EastUS-QA-PTest",
    ip_configurations=[network.BastionHostIPConfigurationArgs(
        name="PTbastionIpConf",
        public_ip_address=network.SubResourceArgs(
            id=var.pid_id + "IP-PT-Bastion",
        ),
        subnet=network.SubResourceArgs(
            id=var.subnet_id + "AzureBastionSubnet",
        ),
    )],
    resource_group_name=rg.name)