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
  azure_dc3_vms_ztna = { for k,v in var.azure_dc3_vms.ztna: k=>merge(v, { token = jsondecode(data.azurerm_key_vault_secret.ztna_dc3[k].value)}) }
  azure_dc4_vms_ztna = { for k,v in var.azure_dc4_vms.ztna: k=>merge(v, { token = jsondecode(data.azurerm_key_vault_secret.ztna_dc4[k].value)}) }
}
