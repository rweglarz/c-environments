module "vm_ztna" {
  source   = "github.com/rweglarz/c-azure//modules/ztnaconnector"
  for_each = var.vms_ztna

  name                = "${var.name}-${each.key}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = local.subnets[each.value.subnet].id
  private_ip_address  = try(cidrhost(local.subnets[each.value.subnet].address_prefixes[0], each.value.hostnum), null)
  token = {
    key    = each.value.token.key
    secret = each.value.token.secret
  }
}
