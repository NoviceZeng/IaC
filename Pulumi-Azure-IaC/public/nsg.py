import os, csv
from pulumi_azure_native import network
from public import var
from public.resource_group import rg

for nsg in var.nsg_list:
    network_security_group = network.NetworkSecurityGroup(nsg["nsg_name"],
        location=rg.location,
        network_security_group_name=nsg["nsg_name"],
        resource_group_name=rg.name,
        tags={
            "environment": "ptest",
        })

with open(os.path.join("vms","security_rules.csv"), "r", encoding = "utf-8") as f:
    reader = csv.DictReader(f)
    for sec_rule in reader:
        network.SecurityRule(sec_rule["rule_name"],
            network_security_group_name=sec_rule["nsg_name"],
            access=sec_rule["access"],
            direction=sec_rule["direction"],
            priority=int(sec_rule["priority"]),
            source_address_prefix=sec_rule["saddr_prefix"],
            source_port_range=sec_rule["sport_range"],
            destination_address_prefix=sec_rule["daddr_prefix"],
            destination_port_range=sec_rule["dport_range"],
            protocol=sec_rule["protocol"],
            security_rule_name=sec_rule["rule_name"],
            resource_group_name=rg.name
        )