resource "google_compute_network" "net1" {
  name                    = "${local.env_prefix}-network1"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "net-s1" {
  name          = "${local.env_prefix}-network1-s1"
  ip_cidr_range = cidrsubnet(var.gcp_cidr, 2, 0)
  network       = google_compute_network.net1.id
}

resource "google_compute_ha_vpn_gateway" "net1" {
  region  = var.gcp_region
  name    = "${local.env_prefix}-net1"
  network = google_compute_network.net1.id
}


resource "google_compute_router" "net1" {
  name    = "${local.env_prefix}-net1"
  network = google_compute_network.net1.name
  bgp {
    asn            = var.gcp_asn
    advertise_mode = "DEFAULT"
  }
}

resource "google_compute_external_vpn_gateway" "sc" {
  name    = "${local.env_prefix}-sc"
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  interface {
    id         = 0
    ip_address = var.sc_public_ip
  }
}


resource "google_compute_vpn_tunnel" "sc" {
  count                 = 2

  name                  = "${local.env_prefix}-sc-i${count.index}"
  region                = var.gcp_region
  vpn_gateway           = google_compute_ha_vpn_gateway.net1.id
  vpn_gateway_interface = count.index
  shared_secret         = var.psk
  router                = google_compute_router.net1.id

  peer_external_gateway           = google_compute_external_vpn_gateway.sc.id
  peer_external_gateway_interface = 0
}


resource "google_compute_router_interface" "sc" {
  count      = 2

  name       = "sc-i${count.index}"
  region     = var.gcp_region
  router     = google_compute_router.net1.name
  ip_range   = format("%s/30", cidrhost(var.gcp_sc_peering_cidr[count.index], 1))
  vpn_tunnel = google_compute_vpn_tunnel.sc[count.index].name
}

resource "google_compute_router_peer" "net1_sc" {
  count                     = 2

  name                      = "${local.env_prefix}-sc-i${count.index}"
  router                    = google_compute_router.net1.name
  region                    = var.gcp_region
  peer_ip_address           = cidrhost(var.gcp_sc_peering_cidr[count.index], 2)
  peer_asn                  = var.prisma_asn
  advertised_route_priority = 100 * (count.index+1)
  interface                 = google_compute_router_interface.sc[count.index].name
  enable                    = var.gcp_peer_enable[count.index]
}
