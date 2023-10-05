/***********************************************
  local vars
***********************************************/ 

locals {
  name           = "cluster-prod-a"
  node_locations = ["us-west1-a", "us-west1-b", "us-west1-c"]
}

/***********************************************
  GKE cluster
***********************************************/ 
resource "google_container_cluster" "container_cluster" {
  provider           = google
  project            = var.project_id
  name               = local.name
  location           = var.location
  initial_node_count = 1
  network            = google_compute_network.vpc-network.id
  subnetwork         = google_compute_subnetwork.subnet.id
  release_channel {
    channel = "REGULAR"
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-cluster"
    services_secondary_range_name = "gke-services"
  }
  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.18.0.32/28"
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
      display_name = "Jenkins Pipeline"
      cidr_block   = "10.192.14.0/24"
    }
    cidr_blocks {
      display_name = "ext-fir-ip"
      cidr_block   = "35.236.53.14/32"    
    }
    cidr_blocks {
      display_name = "ext-sec-ip"
      cidr_block   = "34.102.65.78/32"
    }
    cidr_blocks {
      display_name = "ext-ip-3"
      cidr_block   = "34.94.6.51/32"
    }
    cidr_blocks {
      display_name = "ext-ip-4"
      cidr_block   = "34.94.16.79/32"
    }
    cidr_blocks {
      display_name = "ext-ip-5"
      cidr_block   = "34.102.100.92/32"
    }
    cidr_blocks {
      display_name = "ext-ip-6"
      cidr_block   = "34.102.107.114/32"
    }
  }

  addons_config {
    http_load_balancing {
      disabled = true
    }
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
  resource_labels = {
    mesh_id = "proj-${var.project_number}"
    asmv    = "1-9-8-asm-1"
  }
  remove_default_node_pool = true
}

/***********************************************
  Node Pools
***********************************************/ 
#default prod node pool
resource "google_container_node_pool" "default-node-pool" {
  name           = "default-node-pool"
  project        = var.project_id
  location       = var.location
  node_locations = local.node_locations
  cluster        = local.name

  node_count = 1

  autoscaling {
    max_node_count = 200
    min_node_count = 1
  }

  node_config {
    disk_size_gb = 32
    preemptible  = false
    machine_type = "e2-standard-16"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
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
