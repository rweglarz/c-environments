module "azure_dc1" {
  source = "../modules/dc-azure"

  name      = "${var.name}-azure-dc1"
  region    = var.azure_dc1_region

  azure_asn   = var.asns.azure_dc1
  deploy_rn   = true
  pa_region   = "netherlands-central"
  spn_name    = "europe-west-mombin"
  psk         = var.psk
  pa_vpn_public_ip = try(var.rn_public_ips.azure_dc1, null)

  cidr        = local.cidrs.azure-dc1
  mgmt_ips    = var.mgmt_ips

  ssh_public_key = azurerm_ssh_public_key.this.public_key

  vms_linux   = var.azure_dc1_vms.linux
  vms_windows = var.azure_dc1_vms.windows
  vms_ztna    = local.azure_dc1_vms_ztna
}

module "azure_dc2" {
  source = "../modules/dc-azure"

  name      = "${var.name}-azure-dc2"
  region    = var.azure_dc2_region

  azure_asn   = var.asns.azure_dc2
  deploy_rn   = true
  pa_region   = "poland"
  spn_name    = "europe-central-warsaw-acerola"
  psk         = var.psk
  pa_vpn_public_ip = try(var.rn_public_ips.azure_dc2, null)

  cidr        = local.cidrs.azure-dc2
  mgmt_ips    = var.mgmt_ips

  ssh_public_key = azurerm_ssh_public_key.this.public_key

  vms_linux = var.azure_dc2_vms.linux
  vms_ztna  = local.azure_dc2_vms_ztna
}
