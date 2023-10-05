resource "google_compute_network" "vpc-network" {
  count                   = length(var.networks)
  name                    = lookup(var.networks[count.index], "vpc_name")
  project                 = lookup(var.networks[count.index], "project_id")
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  count                    = length(var.networks)
  name                     = lookup(var.networks[count.index], "subnet_name")
  project                  = lookup(var.networks[count.index], "project_id")
  region                   = lookup(var.networks[count.index], "location")
  network                  = element(google_compute_network.vpc-network.*.id, count.index)
  ip_cidr_range            = lookup(var.networks[count.index], "node_cidr")
  private_ip_google_access = true
  secondary_ip_range {
    range_name    = "gke-cluster"
    ip_cidr_range = lookup(var.networks[count.index], "pod_cidr")
  }
  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = lookup(var.networks[count.index], "service_cidr")
  }
}