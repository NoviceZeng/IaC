# depends on vpc-network.tf

resource "google_compute_address" "cloud_nat_ip" {
  count   = length(var.networks) * 6
  name    = "cloud-nat-ip-${count.index}"
  project = lookup(var.networks[floor(count.index / 6)], "project_id")
  region  = lookup(var.networks[floor(count.index / 6)], "location")
}

resource "google_compute_router" "cloud-router" {
  count   = length(var.networks)
  project = lookup(var.networks[count.index], "project_id")
  name    = lookup(var.networks[count.index], "router_name")
  region  = lookup(var.networks[count.index], "location")
  network = element(google_compute_network.vpc-network.*.id, count.index)
}

resource "google_compute_router_nat" "cloud-nat" {
  count                  = length(var.networks)
  project                = lookup(var.networks[count.index], "project_id")
  name                   = lookup(var.networks[count.index], "nat_name")
  router                 = lookup(var.networks[count.index], "router_name")
  region                 = lookup(var.networks[count.index], "location")
  nat_ip_allocate_option = "MANUAL_ONLY"

  nat_ips = [
    element(google_compute_address.cloud_nat_ip.*.self_link, count.index * 6),
    element(google_compute_address.cloud_nat_ip.*.self_link, count.index * 6 + 1),
    element(google_compute_address.cloud_nat_ip.*.self_link, count.index * 6 + 2),
    element(google_compute_address.cloud_nat_ip.*.self_link, count.index * 6 + 3),
    element(google_compute_address.cloud_nat_ip.*.self_link, count.index * 6 + 4),
    element(google_compute_address.cloud_nat_ip.*.self_link, count.index * 6 + 5),
  ]

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = element(google_compute_subnetwork.subnet.*.id, count.index)
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  min_ports_per_vm = 1600
}