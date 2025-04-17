locals {
  folder = var.deploy_sc ? "Service Connections" : "Remote Networks"
}


data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}
