module "vm_windows" {
  source   = "github.com/rweglarz/c-azure//modules/windows"
  for_each = var.vms_windows

  name                = "${var.name}-${each.key}"
  computer_name       = each.key
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = local.subnets[each.value.subnet].id
  private_ip_address  = try(cidrhost(local.subnets[each.value.subnet].address_prefixes[0], each.value.hostnum), null)
  username            = each.value.auth.username
  password            = each.value.auth.password
  size                = "Standard_DS2_v2"
  image_variant       = "server2022"
  associate_public_ip = try(each.value.associate_public_ip, false)
}
