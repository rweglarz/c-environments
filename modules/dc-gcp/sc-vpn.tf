module "sc" {
  source = "../service-connection-gcp-vpn"

  name                = var.name

  compute_router_name = google_compute_router.this["private"].name
  vpc_name            = google_compute_network.this["private"].name
  ha_vpn_gateway_name = google_compute_ha_vpn_gateway.this.name
  psk                 = var.psk
  sc_region           = var.sc_region
  sc_public_ip        = var.sc_vpn_public_ip

  depends_on = [ 
    google_compute_router.this["private"],
    google_compute_ha_vpn_gateway.this,
  ]
}
