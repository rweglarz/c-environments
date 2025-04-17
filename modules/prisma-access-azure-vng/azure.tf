resource "azurerm_local_network_gateway" "this" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  gateway_address = var.pa_public_ip
  bgp_settings {
    asn                 = var.prisma_asn
    bgp_peering_address = cidrhost(var.peering_cidr, 2)
  }
}

resource "azurerm_virtual_network_gateway_connection" "this" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  type                       = "IPsec"
  virtual_network_gateway_id = var.virtual_network_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.this.id

  enable_bgp = true

  shared_key = var.psk

  ipsec_policy {
    dh_group         = "DHGroup14"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "PFS2"
    sa_lifetime      = "3600"
  }
}
