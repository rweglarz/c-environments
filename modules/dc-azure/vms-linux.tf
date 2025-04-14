module "linux_bs" {
  source = "../linux-as-server"
  for_each = var.vms_linux

  gzip          = true
  base64_encode = true

  params = try(each.value.params, {})
  type   = try(each.value.type, null)
}

module "vm_linux" {
  source   = "github.com/rweglarz/c-azure//modules/linux"
  for_each = var.vms_linux

  name                = "${var.name}-${each.key}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = local.subnets[each.value.subnet].id
  private_ip_address  = try(cidrhost(local.subnets[each.value.subnet].address_prefixes[0], each.value.hostnum), null)
  public_key          = var.ssh_public_key
  username            = each.value.auth.username
  password            = each.value.auth.password
  custom_data         = try(module.linux_bs[each.key].rendered, null)
}
