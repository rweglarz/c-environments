locals {
  cidrs = {
    sec           = cidrsubnet(var.cidr, 1, 0) #vnet
    mgmt          = cidrsubnet(var.cidr, 3, 0)
    public        = cidrsubnet(var.cidr, 3, 1)
    private       = cidrsubnet(var.cidr, 3, 2)
    GatewaySubnet = cidrsubnet(var.cidr, 3, 3)
    workloads-a   = cidrsubnet(var.cidr, 3, 4)
    workloads-b   = cidrsubnet(var.cidr, 3, 6)
  }
  subnets = {
    mgmt        = module.vnet_sec.subnets.mgmt
    workloads-a = module.vnet_workloads_a.subnets.workloads-a
    workloads-b = module.vnet_workloads_b.subnets.workloads-b
  }
}
output "subnets" {
  value = local.subnets
}

resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.region
}
