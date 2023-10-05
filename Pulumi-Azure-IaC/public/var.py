### id
sid = "/subscriptions/67aa02ec-a43c-4b62-808a-12113f131ee8/resourceGroups/RG-PerformanceTesting-DevTest/providers/"
pid_id = sid + "Microsoft.Network/publicIPAddresses/"
subnet_id = sid + "Microsoft.Network/virtualNetworks/EastUS-PT-VNet/subnets/"
asg_id = sid + "Microsoft.Network/applicationSecurityGroups/"
nsg_id = sid + "Microsoft.Network/networkSecurityGroups/"
### public ip
ip_list = [
    {"ip_name":"IP-PT-Bastion", "sku_name":"Standard"}
]

### subnet list
subnet_list = [
    {"subnet_name":"Subnet-Web", "address_prefix":"10.10.1.0/24", "nsg_name":"NSG-Subnet-Public"},
    {"subnet_name":"Subnet-Sql", "address_prefix":"10.10.2.0/24", "nsg_name":"NSG-Subnet-Public"},
    {"subnet_name":"Subnet-Ptest", "address_prefix":"10.10.3.0/24", "nsg_name":"NSG-Subnet-Public"}
]

#{"subnet_name":"AzureBastionSubnet", "address_prefix":"10.10.100.0/24"}
### asg
asg_list = [
    {"asg_name":"ASG-Ptest-Server"}
]

### nsg
nsg_list = [
    {"nsg_name":"NSG-Subnet-Public"}
    ]


