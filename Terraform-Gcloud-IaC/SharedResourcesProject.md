# Shared Resources Project

## Creating The Project

The shared resources project will reside in the non prod shared resources folder. This project will any shared resources, I've configured this
to host all shared resources such as GKE clusters and the non production Shared VPC. You can also create these in seperate projects if you want,
though it may increase complexity.

An example `non-prod-shared-resources.tf` has been provided to create this project in the non prod/shared folder. Go ahead and apply that.


## Creating the Shared VPC

An example (`non-prod-vpc.tf`) has been provided to create the non production network and enable the project as a Shared VPC host project.


## Creating the Shared Cluster

The shared cluster example [non-prod-shared-clusters.tf](projects-init/non-prod-shared-clusters.tf) uses a seperate service account for all the nodes and has workload identity, google groups integration and [Dataplane V2](https://cloud.google.com/kubernetes-engine/docs/concepts/dataplane-v2) enabled.

1. Ensure you have a Google Group created, gke-security-groups@yourdomain.com, this helps workload identity
   understand who resides in what groups. Update the example with your group alias, please see [here](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control#groups-setup-gsuite) for creation info.
2. Choose a release channel, I suggest "STABLE" or "REGULAR". Regular is often a good choice because it's stable
   while still providing useful updates more regularly than the stable channel. If you want very little change and slow updates then "STABLE" channel would be a better choice.
3. Please modify the 'master_authorized_networks_config' firewall ranges so your office environments can interact with
   the GKE control plane.

The demonstration cluster will use private GKE nodes and a public controller address for convenience, having both private
controller and private nodes can be troublesome but is more secure. Keep in mind the public controller address is protected by a firewall and client certificate based authentication. 

## Creating Namespaces

To better manage the clusters, an example [namespaces.tf](projects-init/namespaces.tf) has been provided. At the top of the file there is a namespace variable that you can modify to add each domains namespace, the users and groups
provided in each namespace object will be given cluster-admin permissions in their respective namespace. This allows the domain teams the flexibility to create the resources they need but within their domains namespace only. 

```sh
// Namespaces
dan@cloudshell:$ kubectl describe namespace finance-tools
Name:         finance-tools
Labels:       team=finance
Annotations:  name: Finance Tools
Status:       Active

dan@cloudshell:$ kubectl describe namespace monitoring   
Name:         monitoring
Labels:       team=cloud-infra
Annotations:  name: Monitoring
Status:       Active

// Permissions
dan@cloudshell:$ kubectl describe rolebindings admins -n finance-tools
Name:         admins
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  ClusterRole
  Name:  cluster-admin
Subjects:
  Kind   Name                  Namespace
  ----   ----                  ---------
  User   d@dlf.cloud           default
  Group  developers@dlf.cloud  default

dan@cloudshell:$ kubectl describe rolebindings admins -n monitoring   
Name:         admins
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  ClusterRole
  Name:  cluster-admin
Subjects:
  Kind   Name                  Namespace
  ----   ----                  ---------
  Group  developers@dlf.cloud  default
```