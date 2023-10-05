import pulumi
import pulumi_azure_native as azure_native
from public.resource_group import rg
from event_hugs import var

def create_ns():
    for ns in var.ns_list:
        namespace = azure_native.eventhub.Namespace("namespace",
            location=rg.location,
            namespace_name="stubhub-test",
            resource_group_name=rg.name,
            sku=azure_native.eventhub.SkuArgs(
                name="Standard",
                tier="Standard",
            ),
            tags={
                "tag1": "test1",    })