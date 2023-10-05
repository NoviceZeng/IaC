# GKE Node Service Account and required permissions

locals {
  dev_name            = "cluster-dev"
  dev_location        = "us-central1"
  dev_Jenkins_cidr    = "10.192.10.0/24"
  dev_project_id      = "nonprod-resources"
  dev_project_number  = "406420820443"
  dev_node_pool_name  = "cluster-dev-default-node-pool"
  dev_node_locations  = ["us-central1-a", "us-central1-b", "us-central1-c"]
  dev_vpc_name        = "dev-vpc"
  dev_subnet_name     = "gke-cluster-dev"
  dev_sa_id           = "dev-cluster-sa"
  dev_sa_display_name = "DEV Cluster Service Account"
  dev_node_cidr       = "10.89.0.0/20"
  dev_pod_cidr        = "10.92.0.0/15"
  dev_service_cidr    = "10.88.0.0/20"
  dev_router_name     = "cluster-dev-us-central1-router"
  dev_nat_name        = "cluster-dev-us-central1-nat"
}

resource "google_container_cluster" "container_cluster_dev" {
  provider           = google
  project            = local.dev_project_id
  name               = local.dev_name
  location           = local.dev_location
  initial_node_count = 1
  network            = element(google_compute_network.vpc-network.*.id, 3)
  subnetwork         = element(google_compute_subnetwork.subnet.*.id, 3)
  release_channel {
    channel = "REGULAR"
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-cluster"
    services_secondary_range_name = "gke-services"
  }
  workload_identity_config {
    identity_namespace = "${local.dev_project_id}.svc.id.goog"
  }
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.32/28"
    master_global_access_config {
      enabled = true
    }
  }
  authenticator_groups_config {
    security_group = "gke-security-groups@stubmain.cloud"
  }
  datapath_provider = "ADVANCED_DATAPATH"
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = local.dev_Jenkins_cidr
      display_name = "Jenkins Pipeline"
    }
  }
  timeouts {
    create = "200m"
    update = "200m"
  }
  resource_labels = {
    mesh_id = "proj-${local.dev_project_number}"
    asmv    = "1-9-8-asm-1"
  }
  remove_default_node_pool = true
}

resource "google_container_node_pool" "default-node-pool-dev" {
  name           = local.dev_node_pool_name
  project        = local.dev_project_id
  location       = local.dev_location
  node_locations = local.dev_node_locations
  cluster        = local.dev_name

  node_count = 1

  autoscaling {
    max_node_count = 100
    min_node_count = 1
  }

  node_config {
    disk_size_gb = 32
    preemptible  = false
    machine_type = "e2-standard-8"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  timeouts {
    create = "300m"
    update = "300m"
  }
}

# module "asm" {
#   source  = "terraform-google-modules/kubernetes-engine/google//modules/asm"
#   version = "14.2.0"

#   project_id       = google_project.production-resources.project_id
#   cluster_name     = google_container_cluster.cluster-a.name
#   location         = google_container_cluster.cluster-a.location
#   cluster_endpoint = google_container_cluster.cluster-a.endpoint
# }
