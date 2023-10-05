import pulumi
import pulumi_azure_native as azure_native

subscription = azure_native.servicebus.Subscription("subscription",
    enable_batched_operations=True,
    namespace_name=namespaces.namespace,
    resource_group_name=rg.name,
    subscription_name="sdk-Subscriptions-2178",
    topic_name="sdk-Topics-8740")