#roles
jenkins_roles = [
  "roles/container.admin",
  "roles/iam.serviceAccountAdmin"
]

dataworks_sa_roles = [
  "roles/editor",
  "roles/secretmanager.secretAccessor"
]

#projects
projects = [
  "production-resources-543321",
  "nonprod-resources"
]

#networks

networks = [
  {
    project_id   = "production-resources-543321"
    vpc_name     = "production-cluster-prod-a-vpc"
    location     = "us-west1"
    subnet_name  = "gke-cluster-prod-a"
    node_cidr    = "10.91.0.0/20"
    pod_cidr     = "10.98.0.0/15"
    service_cidr = "10.91.16.0/20"
    router_name  = "cluster-prod-a-us-west1-router"
    nat_name     = "cluster-prod-a-us-west1-nat"
  },
  {
    project_id   = "production-resources-543321"
    vpc_name     = "production-cluster-prod-b-vpc"
    location     = "us-central1"
    subnet_name  = "gke-cluster-prod-b"
    node_cidr    = "10.91.32.0/20"
    pod_cidr     = "10.96.0.0/15"
    service_cidr = "10.91.48.0/20"
    router_name  = "cluster-prod-b-us-central1-router"
    nat_name     = "cluster-prod-b-us-central1-nat"
  },

  {
    project_id   = "nonprod-resources"
    vpc_name     = "stg-vpc"
    location     = "us-west1"
    subnet_name  = "gke-cluster-stg"
    node_cidr    = "10.91.0.0/20"
    pod_cidr     = "10.94.0.0/15"
    service_cidr = "10.90.0.0/20"
    router_name  = "cluster-stg-us-west1-router"
    nat_name     = "cluster-stg-us-west1-nat"
  },
  {
    project_id   = "nonprod-resources"
    vpc_name     = "dev-vpc"
    location     = "us-central1"
    subnet_name  = "gke-cluster-dev"
    node_cidr    = "10.89.0.0/20"
    pod_cidr     = "10.92.0.0/15"
    service_cidr = "10.88.0.0/20"
    router_name  = "cluster-dev-us-central1-router"
    nat_name     = "cluster-dev-us-central1-nat"
  },
]