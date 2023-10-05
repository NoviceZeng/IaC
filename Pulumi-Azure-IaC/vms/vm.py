import os, csv, pulumi
from pulumi_azure_native import compute, network
from public.resource_group import rg
from public import var

config = pulumi.Config();
login_user = config.require('user')
login_passwd = config.require('passwd');

#### create windows vm
def create_vm():
    with open(os.path.join("vms","vm_list.csv"), "r", encoding = "utf-8") as f:
        reader = csv.DictReader(f)
        for vm_list in reader:
            ## create interface
            nic = network.NetworkInterface(vm_list["interface_name"],
                enable_accelerated_networking=False,
                ip_configurations=[network.NetworkInterfaceIPConfigurationArgs(
                    name=vm_list["interface_name"],
                    application_security_groups=[network.ApplicationSecurityGroupArgs(
                        id=var.asg_id + vm_list["asg_name"])],
                    subnet=network.SubnetArgs(
                        id=var.subnet_id + vm_list["subnet_name"],),
                )],
                location=rg.location,
                network_interface_name=vm_list["interface_name"],
                resource_group_name=rg.name)
            ## create vm
            compute.VirtualMachine(vm_list["vm_name"],
                hardware_profile=compute.HardwareProfileArgs(
                    vm_size=vm_list["vm_size"],
                ),
                resource_group_name=rg.name,
                location=rg.location,
                network_profile=compute.NetworkProfileArgs(
                    network_interfaces=[compute.NetworkInterfaceReferenceArgs(
                        id=nic.id,
                        delete_option="Delete",
                        primary=True,
                    )],
                ),
                os_profile=compute.OSProfileArgs(
                    admin_username=login_user,
                    admin_password=login_passwd,
                    #admin_password=vm_list["password"],       
                    computer_name=vm_list["vm_name"],
                ),
                storage_profile=compute.StorageProfileArgs(
                    image_reference=compute.ImageReferenceArgs(
                        publisher=vm_list["image_publisher"],
                        offer=vm_list["image_offer"],
                        sku=vm_list["image_sku"],
                        version="latest",
                    ),
                    os_disk=compute.OSDiskArgs(
                        caching="ReadWrite",
                        create_option="FromImage",
                        delete_option="Delete",
                        disk_size_gb=int(vm_list["disk_size_gb"]),
                        managed_disk=compute.ManagedDiskParametersArgs(
                            storage_account_type=vm_list["storage_account_type"],
                        ),
                        name=vm_list["vm_name"]+"_osdisk"
                    ),
                ),
                zones=[vm_list["zone"]],
                vm_name=vm_list["vm_name"])
            
            ## add vm to aad
            # compute.VirtualMachineExtension(
            #     resource_name=vm_list["vm_name"]+"_AADLoginForWindows",
            #     resource_group_name=rg.name,
            #     vm_name=vm_list["vm_name"],
            #     type="AADLoginForWindows",
            #     publisher="Microsoft.Azure.ActiveDirectory",
            #     type_handler_version="1.0",
            # )
            # compute.VirtualMachineExtension(
            #     resource_name=vm_list["vm_name"]+"_ADDomainExtension",
            #     resource_group_name=rg.name,
            #     vm_name=vm_list["vm_name"],
            #     type="JsonADDomainExtension",
            #     publisher="Microsoft.Azure.ActiveDirectory",
            #     type_handler_version="1.3",
            #     # setting={
            #     #     "Restart": True,
            #     #     "Name": "viagogo.corp",
            #     #     "Options": 3,
            #     #     "User": "viagogo\\_ty.faison"
            #     # }
            # )