resource "google_compute_network" "public" {
  name                    = "${var.name}-public"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public" {
  name          = "${var.name}-public"
  ip_cidr_range = local.cidr.public
  network       = google_compute_network.public.id
}


resource "google_compute_network" "private" {
  name                    = "${var.name}-private"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private" {
  name          = "${var.name}-private"
  ip_cidr_range = local.cidr.private
  network       = google_compute_network.private.id
}


resource "google_compute_network" "workloads" {
  name                    = "${var.name}-workloads"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "workloads" {
  name          = "${var.name}-workloads"
  ip_cidr_range = local.cidr.workloads
  network       = google_compute_network.workloads.id
}


resource "google_compute_network" "mgmt" {
  name                    = "${var.name}-mgmt"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "mgmt" {
  name          = "${var.name}-mgmt"
  ip_cidr_range = local.cidr.mgmt
  network       = google_compute_network.mgmt.id
}




resource "google_compute_ha_vpn_gateway" "private" {
  region  = var.gcp_region
  name    = "${var.name}-private"
  network = google_compute_network.private.id
}

resource "google_compute_router" "private" {
  name    = "${var.name}-private"
  network = google_compute_network.private.name
  bgp {
    asn            = var.gcp_asn
    advertise_mode = "CUSTOM"
    advertised_ip_ranges {
      range = var.cidr
    }
  }
}





resource "google_compute_network_peering" "private_to" {
  for_each = {
    mgmt      = google_compute_network.mgmt.id
    workloads = google_compute_network.workloads.id
  }
  name                 = "${var.name}-private-to-${each.key}"
  network              = google_compute_network.private.id
  peer_network         = each.value
  export_custom_routes = true
}

resource "google_compute_network_peering" "private_from" {
  for_each = {
    mgmt      = google_compute_network.mgmt.id
    workloads = google_compute_network.workloads.id
  }
  name                 = "${var.name}-private-from-${each.key}"
  network              = each.value
  peer_network         = google_compute_network.private.id
  import_custom_routes = true

  depends_on = [
    google_compute_network_peering.private_to
  ]
}
