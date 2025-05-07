module "pa_connection" {
  source = "../prisma-access-azure-vng"
  count = local.deploy_vng ? 1 : 0

  name                = var.name

  resource_group_name     = azurerm_resource_group.this.name
  location                = azurerm_resource_group.this.location
  virtual_network_gateway = azurerm_virtual_network_gateway.this[0]

  psk                 = var.psk
  deploy_sc           = var.deploy_sc
  deploy_rn           = var.deploy_rn
  pa_region           = var.pa_region
  pa_public_ip        = var.pa_vpn_public_ip
  spn_name            = var.spn_name
  peering_cidr        = var.pa_vpn_peering_cidr

  depends_on = [ 
    azurerm_virtual_network_gateway.this["private"],
  ]
}
