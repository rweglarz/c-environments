module "gcp_dc1" {
  source = "../modules/dc-gcp"

  providers = { google = google.dc1 }
  name      = "${var.name}-dc1"

  gcp_asn = 65510
  fw_asn  = 65512
  psk = var.psk

  cidr        = local.cidrs.dc1
  mgmt_ips    = var.mgmt_ips

  sc_region        = "netherlands-central"
  sc_vpn_public_ip = try(var.sc_public_ips.dc1_vpn, null)
  sc_fw_public_ip  = try(var.sc_public_ips.dc1_fw, null)

  vms_linux   = var.dc1_vms.linux
  vms_windows = var.dc1_vms.windows
}

module "gcp_dc2" {
  source = "../modules/dc-gcp"

  providers = { google = google.dc2 }
  name      = "${var.name}-dc2"

  gcp_asn = 65520
  fw_asn  = 65522
  psk = var.psk

  cidr        = local.cidrs.dc2
  mgmt_ips    = var.mgmt_ips

  sc_region        = "poland"
  sc_vpn_public_ip = try(var.sc_public_ips.dc2_vpn, null)
  sc_fw_public_ip  = try(var.sc_public_ips.dc2_fw, null)

  vms_linux   = var.dc2_vms.linux
  vms_windows = var.dc2_vms.windows
}
