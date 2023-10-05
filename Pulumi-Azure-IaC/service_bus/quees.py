import pulumi
import pulumi_azure_native as azure_native

queue = azure_native.servicebus.Queue("queue",
    enable_partitioning=True,
    namespace_name=namespaces.namespace,
    queue_name="sdk-Queues-5647",
    resource_group_name=rg.name,)