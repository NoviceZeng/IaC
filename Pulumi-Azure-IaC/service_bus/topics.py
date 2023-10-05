import pulumi
import pulumi_azure_native as azure_native
from public.resource_group import rg
from service_bus import namespaces
topic = azure_native.servicebus.Topic("topic",
    enable_express=True,
    namespace_name=namespaces.namespace,
    resource_group_name=rg.name,
    topic_name="sdk-Topics-5488")