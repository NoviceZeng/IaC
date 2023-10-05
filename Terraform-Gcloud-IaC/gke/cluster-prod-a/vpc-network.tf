locals {
  vpc_name     = "prod-a-vpc"
  subnet_name  = "gke-cluster-prod-a"
  node_cidr    = "10.91.0.0/20"
  pod_cidr     = "10.90.0.0/16"
  service_cidr = "10.92.0.0/20"
  router_name  = "cluster-prod-a-us-west1-router"
  nat_name     = "cluster-prod-a-us-west1-nat"
}

resource "google_compute_network" "vpc-network" {
  name                    = local.vpc_name
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = local.subnet_name
  project                  = var.project_id
  region                   = var.location
  network                  = google_compute_network.vpc-network.id
  ip_cidr_range            = local.node_cidr
  private_ip_google_access = true
  secondary_ip_range {
    range_name    = "gke-cluster"
    ip_cidr_range = local.pod_cidr
  }
  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = local.service_cidr
  }
}
resource "google_compute_address" "cloud_nat_ip" {
  count   = 6
  name    = "cloud-nat-ip-${count.index}"
  project = var.project_id
  region  = var.location
}

resource "google_compute_router" "cloud-router" {
  project = var.project_id
  name    = local.router_name
  region  = var.location
  network = google_compute_network.vpc-network.id
}

resource "google_compute_router_nat" "cloud-nat" {
  project                = var.project_id
  name                   = local.nat_name
  router                 = local.router_name
  region                 = var.location
  nat_ip_allocate_option = "MANUAL_ONLY"

  nat_ips = [
    element(google_compute_address.cloud_nat_ip.*.self_link, 0),
    element(google_compute_address.cloud_nat_ip.*.self_link, 1),
    element(google_compute_address.cloud_nat_ip.*.self_link, 2),
    element(google_compute_address.cloud_nat_ip.*.self_link, 3),
    element(google_compute_address.cloud_nat_ip.*.self_link, 4),
    element(google_compute_address.cloud_nat_ip.*.self_link, 5),
  ]

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  min_ports_per_vm = 1600
}