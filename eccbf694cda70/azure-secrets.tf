data "azurerm_key_vault_secret" "ztna_dc3" {
  for_each = var.azure_dc3_vms.ztna
  name         = each.key
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "ztna_dc4" {
  for_each = var.azure_dc4_vms.ztna
  name         = each.key
  key_vault_id = var.key_vault_id
}


locals {
  azure_dc3_vms = {
    linux   = { for k,v in var.azure_dc3_vms.linux:   k=>merge({ auth = var.auth }, v) }
    windows = { for k,v in var.azure_dc3_vms.windows: k=>merge({ auth = var.auth }, v) }
    ztna    = { for k,v in var.azure_dc3_vms.ztna:    k=>merge({ token = jsondecode(data.azurerm_key_vault_secret.ztna_dc3[k].value)}, v) }
  }
  azure_dc4_vms = {
    linux   = { for k,v in var.azure_dc4_vms.linux:   k=>merge({ auth = var.auth }, v) }
    windows = { for k,v in var.azure_dc4_vms.windows: k=>merge({ auth = var.auth }, v) }
    ztna    = { for k,v in var.azure_dc4_vms.ztna:    k=>merge({ token = jsondecode(data.azurerm_key_vault_secret.ztna_dc4[k].value)}, v) }
  }
}
