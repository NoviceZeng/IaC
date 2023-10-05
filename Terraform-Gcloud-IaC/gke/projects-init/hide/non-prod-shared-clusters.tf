// GKE Node Service Account and required permissions
resource "google_service_account" "non-production-cluster-sa" {
  project      = google_project.sh-non-prod-resources-may-2021.project_id
  account_id   = "non-production-cluster"
  display_name = "Non Production Cluster Service Account"
}

resource "google_project_iam_member" "non-production-cluster-sa-log-writer" {
  project = google_project.sh-non-prod-resources-may-2021.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.non-production-cluster-sa.email}"
}

resource "google_project_iam_member" "non-production-cluster-sa-metric-writer" {
  project = google_project.sh-non-prod-resources-may-2021.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.non-production-cluster-sa.email}"
}

resource "google_project_iam_member" "non-production-cluster-sa-monitoring-viewer" {
  project = google_project.sh-non-prod-resources-may-2021.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.non-production-cluster-sa.email}"
}

resource "google_project_iam_member" "non-production-cluster-sa-cluster-viewer" {
  project = google_project.sh-non-prod-resources-may-2021.project_id
  role    = "roles/container.clusterViewer"
  member  = "serviceAccount:${google_service_account.non-production-cluster-sa.email}"
}

resource "google_container_cluster" "cluster-a" {
  provider           = google-beta
  project            = google_project.sh-non-prod-resources-may-2021.project_id
  name               = "cluster-a"
  location           = "asia-east1"
  initial_node_count = 1
  network            = google_compute_network.non-production-network.id
  subnetwork         = google_compute_subnetwork.non-prod-gke-cluster-a-subnet.id
  release_channel {
    channel = "REGULAR"
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-cluster"
    services_secondary_range_name = "gke-services"
  }
  workload_identity_config {
    identity_namespace = "${google_project.sh-non-prod-resources-may-2021.project_id}.svc.id.goog"
  }
  private_cluster_config {
    enable_private_endpoint = false
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
      cidr_block   = "0.0.0.0/0"
      display_name = "all"
    }
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
  resource_labels = {
    mesh_id = "proj-${google_project.sh-non-prod-resources-may-2021.number}"
  }
  remove_default_node_pool = true
}

resource "google_container_node_pool" "cluster-a-default-node-pool" {
  name           = "cluster-a-default-node-pool"
  project        = google_project.sh-non-prod-resources-may-2021.project_id
  location       = google_container_cluster.cluster-a.location
  node_locations = ["asia-east1-a", "asia-east1-b"]
  cluster        = google_container_cluster.cluster-a.name
  #node_count = 1

  autoscaling {
    max_node_count = 100
    min_node_count = 1
  }

  node_config {
    disk_size_gb    = 32
    preemptible     = false
    machine_type    = "e2-standard-8"
    service_account = google_service_account.non-production-cluster-sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_cluster" "cluster-dev" {
  provider           = google-beta
  project            = google_project.sh-non-prod-resources-may-2021.project_id
  name               = "cluster-dev"
  location           = "asia-east1"
  initial_node_count = 1
  network            = google_compute_network.non-production-network.id
  subnetwork         = google_compute_subnetwork.non-prod-gke-cluster-dev-subnet.id
  release_channel {
    channel = "REGULAR"
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-cluster"
    services_secondary_range_name = "gke-services"
  }
  workload_identity_config {
    identity_namespace = "${google_project.sh-non-prod-resources-may-2021.project_id}.svc.id.goog"
  }
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "174.16.0.32/28"
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
      cidr_block   = "0.0.0.0/0"
      display_name = "all"
    }
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
  resource_labels = {
    mesh_id = "proj-${google_project.sh-non-prod-resources-may-2021.number}"
  }
  remove_default_node_pool = true
}

resource "google_container_node_pool" "cluster-dev-default-node-pool" {
  name           = "cluster-dev-default-node-pool"
  project        = google_project.sh-non-prod-resources-may-2021.project_id
  location       = google_container_cluster.cluster-dev.location
  node_locations = ["asia-east1-a", "asia-east1-b"]
  cluster        = google_container_cluster.cluster-dev.name
  #node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 100
  }

  node_config {
    disk_size_gb    = 32
    preemptible     = false
    machine_type    = "e2-standard-8"
    service_account = google_service_account.non-production-cluster-sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "cluster-a-default-node-pool-32g" {
  name           = "cluster-a-default-node-pool-32g"
  project        = google_project.sh-non-prod-resources-may-2021.project_id
  location       = google_container_cluster.cluster-a.location
  node_locations = ["asia-east1-c", "asia-east1-b"]
  cluster        = google_container_cluster.cluster-a.name
  node_count     = 1

  node_config {
    disk_size_gb    = 32
    preemptible     = false
    machine_type    = "e2-standard-8"
    service_account = google_service_account.non-production-cluster-sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# module "asm" {
#   source  = "terraform-google-modules/kubernetes-engine/google//modules/asm"
#   version = "14.2.0"

#   project_id       = google_project.sh-non-prod-resources-may-2021.project_id
#   cluster_name     = google_container_cluster.cluster-a.name
#   location         = google_container_cluster.cluster-a.location
#   cluster_endpoint = google_container_cluster.cluster-a.endpoint
# }

# resource "google_container_cluster" "cluster-na" {
#   provider = google-beta
#   project = google_project.sh-non-prod-resources-may-2021.project_id
#   name               = "cluster-na"
#   location           = "us-west1"
#   initial_node_count = 1
#   network    = google_compute_network.non-production-network.id
#   subnetwork = google_compute_subnetwork.non-prod-gke-cluster-na-subnet.id
#   release_channel {
#       channel = "REGULAR"
#   }
#   ip_allocation_policy {
#     cluster_secondary_range_name  = "gke-cluster"
#     services_secondary_range_name = "gke-services"
#   }
#   workload_identity_config {
#     identity_namespace = "${google_project.sh-non-prod-resources-may-2021.project_id}.svc.id.goog"
#   }
#   private_cluster_config {
#     enable_private_endpoint = false
#     enable_private_nodes = true
#     master_ipv4_cidr_block = "172.16.0.16/28"
#     master_global_access_config {
#       enabled = true
#     }
#   }
#   authenticator_groups_config {
#       security_group = "gke-security-groups@stubmain.cloud"
#   }
#   datapath_provider = "ADVANCED_DATAPATH"
#   master_authorized_networks_config {
#     cidr_blocks {
#        cidr_block = "0.0.0.0/0"
#        display_name = "all"
#     }
#   }
#   timeouts {
#     create = "30m"
#     update = "40m"
#   }
#   resource_labels = {
#       mesh_id = "proj-${google_project.sh-non-prod-resources-may-2021.number}"
#   }
#   remove_default_node_pool = true
# }

# resource "google_container_node_pool" "cluster-na-default-node-pool" {
#   name       = "cluster-na-default-node-pool"
#   project    = google_project.sh-non-prod-resources-may-2021.project_id
#   location   = google_container_cluster.cluster-na.location
#   node_locations = ["us-west1-a", "us-west1-b"]
#   cluster    = google_container_cluster.cluster-na.name
#   #node_count = 1
#   autoscaling {
#     max_node_count = 100
#     min_node_count = 1
#     }
#   node_config {
#     disk_size_gb = 15
#     preemptible  = false
#     machine_type = "e2-standard-4"
#     service_account = google_service_account.non-production-cluster-sa.email
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }
# }

resource "google_container_cluster" "cluster-stg" {
  provider           = google-beta
  project            = google_project.sh-non-prod-resources-may-2021.project_id
  name               = "cluster-stg"
  location           = "us-west1"
  initial_node_count = 1
  network            = google_compute_network.non-production-network.id
  subnetwork         = google_compute_subnetwork.non-prod-gke-cluster-stg-subnet.id
  release_channel {
    channel = "REGULAR"
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-cluster"
    services_secondary_range_name = "gke-services"
  }
  workload_identity_config {
    identity_namespace = "${google_project.sh-non-prod-resources-may-2021.project_id}.svc.id.goog"
  }
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "188.16.0.16/28"
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
      cidr_block   = "0.0.0.0/0"
      display_name = "all"
    }
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
  resource_labels = {
    mesh_id = "proj-${google_project.sh-non-prod-resources-may-2021.number}"
  }
  remove_default_node_pool = true
}

# resource "google_container_node_pool" "cluster-stg-default-node-pool" {
#   name           = "cluster-stg-default-node-pool"
#   project        = google_project.sh-non-prod-resources-may-2021.project_id
#   location       = google_container_cluster.cluster-stg.location
#   node_locations = ["us-west1-a", "us-west1-b"]
#   cluster        = google_container_cluster.cluster-stg.name
#   node_count     = 1

#   #autoscaling {
#   #  min_node_count = 1
#   #  max_node_count = 100
#   #  }

#   node_config {
#     disk_size_gb    = 15
#     preemptible     = false
#     machine_type    = "e2-standard-4"
#     service_account = google_service_account.non-production-cluster-sa.email
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/cloud-platform"
#     ]
#   }
# }