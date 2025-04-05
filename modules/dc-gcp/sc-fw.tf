resource "scm_ike_gateway" "fw" {
  name = "${var.name}-fw-ike"
  authentication = {
    pre_shared_key = {
      key = var.psk
    }
  }
  protocol = {
    version = "ikev2"
    ikev2 = {
      ike_crypto_profile = "Suite-B-GCM-256"
      dpd                = { enable = true }
    }
    # ikev1 = {
    #   dpd                = { enable = true }
    # }
  }
  protocol_common = {
    nat_traversal = { enable = true }
    fragmentation = { enable = false }
  }
  peer_address = {
    ip = google_compute_address.fw_public.address
  }

  folder = local.sc_folder
}

resource "scm_ipsec_tunnel" "fw" {
  name = "${var.name}-fw-tunnel"
  auto_key = {
    ipsec_crypto_profile = "Suite-B-GCM-256"
    ike_gateways = [{
      name = scm_ike_gateway.fw.name
    }]
  }
  anti_replay = true

  folder = local.sc_folder
}





resource "scm_service_connection" "fw" {
  name         = "${var.name}-fw"
  ipsec_tunnel = scm_ipsec_tunnel.fw.name
  region       = var.sc_region
  protocol = {
    # bgp peering on primary tunnel
    bgp = {
      enable           = true
      peer_as          = var.gcp_asn
      local_ip_address = cidrhost(var.sc_fw_peering_cidr, 2)
    }
  }
}

