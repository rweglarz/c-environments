module "gcp_office1" {
  source = "../modules/dc-gcp"

  providers = { google = google.office1 }
  name      = "${var.name}-office1"

  gcp_asn    = var.asns.gcp_office1
  prisma_asn = var.asns.prisma
  psk = var.psk

  cidr        = local.cidrs.office1
  mgmt_ips    = var.mgmt_ips

  deploy_rn = true
  pa_region        = "netherlands-central"
  pa_vpn_public_ip = try(var.rn_public_ips.office1_vpn, null)
  spn_name         = "europe-west-mombin"

  vms_linux   = var.office1_vms.linux
#   vms_windows = var.office1_vms.windows
}
