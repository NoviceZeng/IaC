# from pulumi_azure_native import resources
# ### resource group
# ## vm/disk/image/nic/runbook/Storage account/Solution/work space/logic app resource group
# stub_qa_rg = resources.ResourceGroup("RG-QATU-INFRASTRUCTURE", location = "eastus")

# ## vnet/security group/connection/public ip/gateway/load balance resource group
# stub_vnet_rg = resources.ResourceGroup("RG-Networking", location = "eastus")



import pulumi
import pulumi_azure_native as azure_native

rg = azure_native.resources.ResourceGroup("RG-MachineLearning-DevTest",
    location="eastus2",
    resource_group_name="RG-MachineLearning-DevTest",
    opts=pulumi.ResourceOptions(protect=True))