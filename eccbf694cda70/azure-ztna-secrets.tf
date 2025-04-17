data "azurerm_key_vault_secret" "ztna_dc1" {
  for_each = var.azure_dc1_vms.ztna
  name         = each.key
  key_vault_id = var.key_vault_id
}

data "azurerm_key_vault_secret" "ztna_dc2" {
  for_each = var.azure_dc2_vms.ztna
  name         = each.key
  key_vault_id = var.key_vault_id
}


locals {
  azure_dc1_vms_ztna = { for k,v in var.azure_dc1_vms.ztna: k=>merge(v, { token = jsondecode(data.azurerm_key_vault_secret.ztna_dc1[k].value)}) }
  azure_dc2_vms_ztna = { for k,v in var.azure_dc2_vms.ztna: k=>merge(v, { token = jsondecode(data.azurerm_key_vault_secret.ztna_dc2[k].value)}) }
}
