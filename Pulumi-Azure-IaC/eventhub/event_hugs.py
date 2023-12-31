import pulumi
import pulumi_azure_native as azure_native
from eventhub import namespaces

event_hub = azure_native.eventhub.EventHub("eventHub",
    # capture_description=azure_native.eventhub.CaptureDescriptionArgs(
    #     destination=azure_native.eventhub.DestinationArgs(
    #         archive_name_format="{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}",
    #         blob_container="container",
    #         name="EventHubArchive.AzureBlockBlob",
    #         storage_account_resource_id="/subscriptions/e2f361f0-3b27-4503-a9cc-21cfba380093/resourceGroups/Default-Storage-SouthCentralUS/providers/Microsoft.ClassicStorage/storageAccounts/arjunteststorage",
    #     ),
    #     enabled=True,
    #     encoding="Avro",
    #     interval_in_seconds=120,
    #     size_limit_in_bytes=10485763,
    # ),
    event_hub_name="sdk-EventHub-6547",
    message_retention_in_days=4,
    namespace_name=namespaces,
    partition_count=4,
    resource_group_name="Default-NotificationHubs-AustraliaEast",
    status="Active")