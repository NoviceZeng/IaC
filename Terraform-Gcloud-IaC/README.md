* Organization
* ↳ Resource Manager Project
* ↳ 📁 Prod

      ↳ prod Resources Project
* ↳ 📁 Non-Prod

      ↳ non prod Resources Project
      
## Description

The sequences to run the tf code, do not run them at a time:
projects->vpc-network->nat->clusters

### Resource Manager Project
Contains Cloud Build Trigger + Source Repositories. The project will configure atleast all shared (shared folder)
Terraform resources in both prod and non prod.

### Shared Resources Project(s)
There is atleast one shared resources project in each environment, this project will contain:
*  Multi Tenant GKE clusters for use by all the teams. 
*  Environment Single VPC, eg: 'production' VPC. This VPC's subnets will be shared using Shared VPC to other shared projects
   and teams within the same environment. GKE will use Shared VPC subnets aswell.
*  Spanner, Redis etc. Things that all the teams will Share. 


## Permissions
Viewer permissions are generally given at the folder level, but more finegrained permissions per project can also be applied.
See example Terraform files for more information.


## Setup

To setup this environment you can start at the org level or you can create a Folder and prepare inside there. 

1.  Setup the Cloud Build Trigger + Source Repository automation shown in [ResourceManager](ResourceManager.md),
    this automation can be setup manually or with another different parent Terraform state.
2.  Setup the base folder structure and Terraform shown in [ResourceManager#Setting Up TF](ResourceManager.md#SettingUpTF).
2.  Start creating the environment folder structure, projects and Shared VPC in [SharedResourcesProject](SharedResourcesProject.md).
