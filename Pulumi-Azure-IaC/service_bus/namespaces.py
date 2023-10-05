import pulumi
import pulumi_azure_native as azure_native
from public.resource_group import rg
from service_bus import var
def create_ns():
    for ns in var.ns_list:
        namespace = azure_native.servicebus.Namespace(ns_list["ns_name"],
            location=rg.location,
            namespace_name=ns_list["ns_name"],
            resource_group_name=rg.name,
            sku=azure_native.servicebus.SBSkuArgs(
                name=ns_list["sku_name"],
                tier=ns_list["sku_name"],
            ),
            tags={
                "tag1": "test",
            })