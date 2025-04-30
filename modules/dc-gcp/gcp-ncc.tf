resource "google_network_connectivity_hub" "this" {
  count = var.deploy_sc_fw ? 1 : 0

  name = var.name
}

resource "google_network_connectivity_spoke" "this" {
  count = (var.deploy_sc_fw && var.deploy_ngfw) ? 1 : 0

  name     = "${var.name}-private"
  hub      = google_network_connectivity_hub.this[0].id
  location = var.gcp_region

  linked_router_appliance_instances {
    instances {
      virtual_machine = google_compute_instance.ngfw[0].self_link
      ip_address      = google_compute_instance.ngfw[0].network_interface[2].network_ip
    }
    site_to_site_data_transfer = false
    # include_import_ranges = ["ALL_IPV4_RANGES"]
  }
}

resource "google_compute_router_interface" "private_primary" {
  count = var.deploy_sc_fw ? 1 : 0
  name                = "private-primary"
  router              = google_compute_router.this["private"].name
  subnetwork          = google_compute_subnetwork.this["private"].self_link
  private_ip_address  = local.private_ips.gcp_cr.primary
  redundant_interface = google_compute_router_interface.private_redundant[0].name
}

resource "google_compute_router_interface" "private_redundant" {
  count = var.deploy_sc_fw ? 1 : 0
  name                = "private-redundant"
  router              = google_compute_router.this["private"].name
  subnetwork          = google_compute_subnetwork.this["private"].self_link
  private_ip_address  = local.private_ips.gcp_cr.redundant
}

resource "google_compute_router_peer" "ngfw" {
  for_each = (var.deploy_sc_fw && var.deploy_ngfw) ? {
    primary = {
      interface = google_compute_router_interface.private_primary[0].name
    }
    redundant = {
      interface = google_compute_router_interface.private_redundant[0].name
    }
  } : {}
  name                      = "${var.name}-ngfw-${each.key}"
  router                    = google_compute_router.this["private"].name
  interface                 = each.value.interface
  peer_asn                  = var.fw_asn
  router_appliance_instance = google_compute_instance.ngfw[0].self_link
  peer_ip_address           = local.private_ips.ngfw.private
  enable                    = var.bgp_peer_enable[2]
  depends_on = [
    google_network_connectivity_spoke.this
  ]
}
