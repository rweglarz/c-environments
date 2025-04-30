module "sc" {
  source = "../prisma-access-gcp-vpn"
  count = var.deploy_sc_vpn ? 1 : 0

  name                = var.name

  compute_router_name = google_compute_router.this["private"].name
  vpc_name            = google_compute_network.this["private"].name
  ha_vpn_gateway_name = google_compute_ha_vpn_gateway.this.name
  psk                 = var.psk
  deploy_sc           = true
  pa_region           = var.pa_region
  pa_public_ip        = var.pa_vpn_public_ip
  bgp_peer_enable     = slice(var.bgp_peer_enable, 0, 2)

  depends_on = [ 
    google_compute_router.this["private"],
    google_compute_ha_vpn_gateway.this,
  ]
}

module "rn" {
  source = "../prisma-access-gcp-vpn"
  count = var.deploy_rn ? 1 : 0

  name                = var.name

  compute_router_name = google_compute_router.this["private"].name
  vpc_name            = google_compute_network.this["private"].name
  ha_vpn_gateway_name = google_compute_ha_vpn_gateway.this.name
  psk                 = var.psk
  deploy_rn           = true
  pa_region           = var.pa_region
  pa_public_ip        = var.pa_vpn_public_ip
  spn_name            = var.spn_name
  bgp_peer_enable     = slice(var.bgp_peer_enable, 0, 2)

  depends_on = [ 
    google_compute_router.this["private"],
    google_compute_ha_vpn_gateway.this,
  ]
}
