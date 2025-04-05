resource "scm_ike_gateway" "this" {
  count = 2

  name = "${var.name}-ikeg-${count.index}"

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
    ip = data.google_compute_ha_vpn_gateway.this.vpn_interfaces[count.index].ip_address
  }

  folder = local.sc_folder
}


resource "scm_ipsec_tunnel" "this" {
  count = 2

  name = "${var.name}-ipsect-${count.index}"

  auto_key = {
    ipsec_crypto_profile = "Suite-B-GCM-256"
    ike_gateways = [{
      name = scm_ike_gateway.this[count.index].name
    }]
  }
  anti_replay = true

  folder = local.sc_folder
}





resource "scm_service_connection" "this" {
  name = var.name

  ipsec_tunnel           = scm_ipsec_tunnel.this[0].name
  secondary_ipsec_tunnel = scm_ipsec_tunnel.this[1].name
  region                 = var.sc_region
  protocol = {
    # bgp peering on primary tunnel
    bgp = {
      enable           = true
      peer_as          = data.google_compute_router.this.bgp[0].asn
      local_ip_address = cidrhost(var.peering_cidrs[0], 2)
      peer_ip_address  = cidrhost(var.peering_cidrs[0], 1)
    }
  }
  # bgp peering on secondary tunnel
  bgp_peer = {
    enable           = true
    peer_as          = data.google_compute_router.this.bgp[0].asn
    local_ip_address = cidrhost(var.peering_cidrs[1], 2)
    peer_ip_address  = cidrhost(var.peering_cidrs[1], 1)
  }
}
