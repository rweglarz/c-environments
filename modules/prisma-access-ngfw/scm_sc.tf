resource "scm_ike_gateway" "prisma_access" {
  name = "${var.name}-ikeg"

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
    ip = var.fw_public_ip
  }

  folder = local.sc_folder
}


resource "scm_ipsec_tunnel" "prisma_access" {
  name = "${var.name}-ipsect"

  auto_key = {
    ipsec_crypto_profile = "Suite-B-GCM-256"
    ike_gateways = [{
      name = scm_ike_gateway.prisma_access.name
    }]
  }
  anti_replay = true

  folder = local.sc_folder
}



resource "scm_service_connection" "this" {
  name = var.name

  ipsec_tunnel           = scm_ipsec_tunnel.prisma_access.name
  region                 = var.pa_region
  protocol = {
    bgp = {
      enable           = true
      peer_as          = var.fw_asn
      local_ip_address = cidrhost(var.peering_cidr, 2)
      peer_ip_address  = cidrhost(var.peering_cidr, 1)
    }
  }
}
