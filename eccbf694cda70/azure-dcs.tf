module "azure_dc1" {
  source = "../modules/dc-azure"

  name      = "${var.name}-azure-dc1"
  region    = var.azure_dc1_region

  cidr        = local.cidrs.azure-dc1
  mgmt_ips    = var.mgmt_ips

  ssh_public_key = azurerm_ssh_public_key.this.public_key

  vms_linux   = var.azure_dc1_vms.linux
  vms_windows = var.azure_dc1_vms.windows
  vms_ztna    = var.azure_dc1_vms.ztna
}

module "azure_dc2" {
  source = "../modules/dc-azure"

  name      = "${var.name}-azure-dc2"
  region    = var.azure_dc2_region

  cidr        = local.cidrs.azure-dc2
  mgmt_ips    = var.mgmt_ips

  ssh_public_key = azurerm_ssh_public_key.this.public_key

  vms_linux = var.azure_dc2_vms.linux
  vms_ztna  = var.azure_dc2_vms.ztna
}
