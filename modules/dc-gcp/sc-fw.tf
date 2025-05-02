module "sc_fw" {
  count = var.deploy_sc_fw ? 1 : 0
  source = "../prisma-access-ngfw"

  name         = "${var.name}-fw"

  psk          = var.psk
  pa_region    = var.pa_region
  pa_public_ip = var.pa_vpn_public_ip
  fw_public_ip = google_compute_address.ngfw_public[0].address
  folder       = var.scm_ngfw_folder
  fw_asn       = var.fw_asn
}

locals {
  fw_vars = {
    asn                      = { value = var.fw_asn, type = "as-number" }
    eth1-1-ipm               = { value = format("%s/27", local.private_ips.ngfw.public), type = "ip-netmask" }
    eth1-2-gw                = { value = cidrhost(local.subnets.private.cidr, 1), type = "ip-netmask" }
    fw-public-ip             = { value = google_compute_address.ngfw_public[0].address, type = "ip-netmask" }
    gcp-asn                  = { value = var.gcp_asn, type = "as-number" }
    gcp-ncc-peering-ip-1     = { value = local.private_ips.gcp_cr.primary, type = "ip-netmask" }
    gcp-ncc-peering-ip-2     = { value = local.private_ips.gcp_cr.redundant, type = "ip-netmask" }
    gp-ip-pool               = { value = try(format("%s-%s", cidrhost(var.gp_ip_pool_subnet, 100), cidrhost(var.gp_ip_pool_subnet, 199)), null), type = "ip-range" }
    tunnel-9-ipm             = { value = try(cidrhost(var.gp_ip_pool_subnet, 1), null), type = "ip-range" }
    prisma-access-public-ip  = { value = var.pa_fw_public_ip, type = "ip-netmask" }
    prisma-access-peering-ip = { value = cidrhost(var.pa_fw_peering_cidr, 2), type = "ip-netmask" }
    router-id                = { value = local.private_ips.ngfw.private, type = "ip-netmask" }
    tunnel-1-ipm             = { value = format("%s/30", cidrhost(var.pa_fw_peering_cidr, 1)), type = "ip-netmask" }
  }
}

resource "scm_variable" "this" {
  for_each = var.scm_ngfw_folder != null ? { for k,v in local.fw_vars: k => v if v.value!=null } : {}
  name    = format("$%s", each.key)
  type    = each.value.type
  value   = each.value.value
  folder  = var.scm_ngfw_folder
}
