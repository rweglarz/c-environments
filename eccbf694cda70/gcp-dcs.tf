module "gcp_dc1" {
  source = "github.com/rweglarz/c-environments//modules/dc-gcp"

  providers = { google = google.dc1 }
  name      = "${var.name}-dc1"

  gcp_asn = var.asns.dc1_vpn
  fw_asn  = var.asns.dc1_fw
  psk = var.psk

  cidr        = local.cidrs.dc1
  mgmt_ips    = var.mgmt_ips

  deploy_sc        = true
  pa_region        = "netherlands-central"
  pa_vpn_public_ip = try(var.sc_public_ips.dc1, null)
  pa_fw_public_ip  = try(var.sc_public_ips.dc1-fw, null)

  vms_linux   = var.dc1_vms.linux
  vms_windows = var.dc1_vms.windows
}

module "gcp_dc2" {
  source = "github.com/rweglarz/c-environments//modules/dc-gcp"

  providers = { google = google.dc2 }
  name      = "${var.name}-dc2"

  gcp_asn = var.asns.dc2_vpn
  fw_asn  = var.asns.dc2_fw
  psk = var.psk

  cidr        = local.cidrs.dc2
  mgmt_ips    = var.mgmt_ips

  deploy_sc        = true
  pa_region        = "poland"
  pa_vpn_public_ip = try(var.sc_public_ips.dc2, null)
  pa_fw_public_ip  = try(var.sc_public_ips.dc2-fw, null)

  vms_linux   = var.dc2_vms.linux
  vms_windows = var.dc2_vms.windows
}
