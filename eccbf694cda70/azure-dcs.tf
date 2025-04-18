module "azure_dc3" {
  source = "../modules/dc-azure"

  name      = "${var.name}-azure-dc3"
  region    = var.azure_dc3_region

  azure_asn   = var.asns.azure_dc3
  deploy_rn   = true
  pa_region   = "netherlands-central"
  spn_name    = "europe-west-mombin"
  psk         = var.psk
  pa_vpn_public_ip = try(var.rn_public_ips.azure-dc3, null)

  cidr        = local.cidrs.azure-dc3
  mgmt_ips    = var.mgmt_ips

  ssh_public_key = azurerm_ssh_public_key.this.public_key

  vms_linux   = local.azure_dc3_vms.linux
  vms_windows = local.azure_dc3_vms.windows
  vms_ztna    = local.azure_dc3_vms.ztna
}

module "azure_dc4" {
  source = "../modules/dc-azure"

  name      = "${var.name}-azure-dc4"
  region    = var.azure_dc4_region

  azure_asn   = var.asns.azure_dc4
  deploy_rn   = true
  pa_region   = "poland"
  spn_name    = "europe-central-warsaw-acerola"
  psk         = var.psk
  pa_vpn_public_ip = try(var.rn_public_ips.azure-dc4, null)

  cidr        = local.cidrs.azure-dc4
  mgmt_ips    = var.mgmt_ips

  ssh_public_key = azurerm_ssh_public_key.this.public_key

  vms_linux   = local.azure_dc4_vms.linux
  vms_windows = local.azure_dc4_vms.windows
  vms_ztna    = local.azure_dc4_vms.ztna
}
