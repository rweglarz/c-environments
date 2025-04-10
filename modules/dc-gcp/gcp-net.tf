resource "google_compute_network" "this" {
  for_each = local.subnets

  name                    = "${var.name}-${each.key}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  for_each = local.subnets

  name          = "${var.name}-${each.key}"
  ip_cidr_range = local.subnets[each.key].cidr
  network       = google_compute_network.this[each.key].id
}


resource "google_compute_ha_vpn_gateway" "this" {
  region  = var.gcp_region
  name    = "${var.name}-private"
  network = google_compute_network.this["private"].id
}


resource "google_compute_router" "this" {
  for_each = { for k,v in local.subnets: k=>v if (k=="private" || try(v.nat, false)==true) }

  name    = "${var.name}-${each.key}"
  network = google_compute_network.this[each.key].name
  bgp {
    asn            = var.gcp_asn
    advertise_mode = "CUSTOM"
    advertised_ip_ranges {
      range = var.cidr
    }
  }
}


resource "google_compute_router_nat" "this" {
  for_each = { for k,v in local.subnets: k=>v if try(v.nat, false)==true }

  name   = "${var.name}-${each.key}"
  router = google_compute_router.this[each.key].name

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option = "AUTO_ONLY"
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}



resource "google_compute_network_peering" "private_to" {
  for_each = {
    mgmt        = google_compute_network.this["mgmt"].id
    workloads-a = google_compute_network.this["workloads-a"].id
    workloads-b = google_compute_network.this["workloads-b"].id
  }
  name                 = "${var.name}-private-to-${each.key}"
  network              = google_compute_network.this["private"].id
  peer_network         = each.value
  export_custom_routes = true
}

resource "google_compute_network_peering" "private_from" {
  for_each = {
    mgmt        = google_compute_network.this["mgmt"].id
    workloads-a = google_compute_network.this["workloads-a"].id
    workloads-b = google_compute_network.this["workloads-b"].id
  }
  name                 = "${var.name}-private-from-${each.key}"
  network              = each.value
  peer_network         = google_compute_network.this["private"].id
  import_custom_routes = true

  depends_on = [
    google_compute_network_peering.private_to
  ]
}
