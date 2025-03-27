resource "scm_ike_gateway" "gcp" {
  count = 2
  name  = "${local.env_prefix}-gcp-ike-${count.index}"
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
    ip = google_compute_ha_vpn_gateway.net1.vpn_interfaces[count.index].ip_address
  }

  folder = local.sc_folder
}

resource "scm_ipsec_tunnel" "gcp" {
  count = 2

  name = "${local.env_prefix}-gcp-tunnel-${count.index}"
  auto_key = {
    ipsec_crypto_profile = "Suite-B-GCM-256"
    ike_gateways = [{
      name = scm_ike_gateway.gcp[count.index].name
    }]
  }
  anti_replay = true

  folder = local.sc_folder
}





resource "scm_service_connection" "gcp" {
  name                   = "${local.env_prefix}-gcp"
  ipsec_tunnel           = scm_ipsec_tunnel.gcp[0].name
  secondary_ipsec_tunnel = scm_ipsec_tunnel.gcp[1].name
  region                 = var.sc_region
  protocol = {
    # bgp peering on primary tunnel
    bgp = {
      enable           = true
      peer_as          = var.gcp_asn
      local_ip_address = cidrhost(var.gcp_sc_peering_cidr[0], 2)
      peer_ip_address  = cidrhost(var.gcp_sc_peering_cidr[0], 1)
    }
  }
  # bgp peering on secondary tunnel
  bgp_peer = {
    enable           = true
    peer_as          = var.gcp_asn
    local_ip_address = cidrhost(var.gcp_sc_peering_cidr[1], 2)
    peer_ip_address  = cidrhost(var.gcp_sc_peering_cidr[1], 1)
  }
}
