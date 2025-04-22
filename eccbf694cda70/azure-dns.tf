resource "azurerm_private_dns_zone" "this" {
  name                = var.dns_zone
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = merge(
    { for k,v in module.azure_dc3.vnet_ids: "dc1-${k}"=>v },
    { for k,v in module.azure_dc4.vnet_ids: "dc2-${k}"=>v },
  )
  name                  = each.key
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = each.value
}

resource "azurerm_private_dns_a_record" "this" {
  for_each = {
    app9           = [ module.azure_dc3.vms_linux["app9"].private_ip_address ]
    app13          = [ module.azure_dc4.vms_linux["app13"].private_ip_address ]
    app-azure-saml = [ module.azure_dc3.vms_linux["app-azure-saml"].private_ip_address ]
    glb-app-aa  = [
        module.azure_dc3.vms_linux["app9"].private_ip_address,
        module.azure_dc4.vms_linux["app13"].private_ip_address,
    ]
  }
  name                = each.key
  resource_group_name = azurerm_resource_group.rg.name
  zone_name           = azurerm_private_dns_zone.this.name
  ttl                 = 90
  records             = each.value
}

resource "azurerm_private_dns_cname_record" "this" {
  for_each = {
    application-aa    = "glb-app-aa.${var.dns_zone}"
    application-ap    = "glb-app-ap.${var.dns_zone}"
    # glb-app-ap        = "app9.${local.dns_zone}"
    glb-app-ap        = "app13.${var.dns_zone}"
  }
  name                = each.key
  resource_group_name = azurerm_resource_group.rg.name
  zone_name           = azurerm_private_dns_zone.this.name
  ttl                 = 30
  record              = each.value
}
