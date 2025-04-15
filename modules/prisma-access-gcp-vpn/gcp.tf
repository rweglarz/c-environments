resource "google_compute_external_vpn_gateway" "this" {
  name    = var.name

  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  interface {
    id         = 0
    ip_address = var.pa_public_ip
  }
}


data "google_compute_ha_vpn_gateway" "this" {
  name    = var.ha_vpn_gateway_name
}

data "google_compute_router" "this" {
  name    = var.compute_router_name
  network = var.vpc_name
}


resource "google_compute_vpn_tunnel" "this" {
  count = 2

  name = "${var.name}-i${count.index}"

  vpn_gateway           = data.google_compute_ha_vpn_gateway.this.name
  vpn_gateway_interface = count.index
  router                = data.google_compute_router.this.id
  shared_secret         = var.psk

  peer_external_gateway           = google_compute_external_vpn_gateway.this.id
  peer_external_gateway_interface = 0
}


resource "google_compute_router_interface" "this" {
  count = 2

  name = "${var.name}-i${count.index}"

  router     = data.google_compute_router.this.name
  ip_range   = format("%s/30", cidrhost(var.peering_cidrs[count.index], 1))
  vpn_tunnel = google_compute_vpn_tunnel.this[count.index].name
}


resource "google_compute_router_peer" "this" {
  count = 2

  name = "${var.name}-i${count.index}"

  router                    = data.google_compute_router.this.name
  peer_ip_address           = cidrhost(var.peering_cidrs[count.index], 2)
  peer_asn                  = var.prisma_asn
  advertised_route_priority = 100 * (count.index + 1)
  interface                 = google_compute_router_interface.this[count.index].name
  enable                    = var.bgp_peer_enable[count.index]
}
