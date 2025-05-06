locals {
  cidrs = {
    sec           = cidrsubnet(var.cidr, 1, 0) #vnet
    mgmt          = cidrsubnet(var.cidr, 3, 0)
    public        = cidrsubnet(var.cidr, 3, 1)
    private       = cidrsubnet(var.cidr, 3, 2)
    GatewaySubnet = cidrsubnet(var.cidr, 3, 3)
    vnet-a        = cidrsubnet(var.cidr, 2, 2)
    workloads-a   = cidrsubnet(var.cidr, 3, 4)
    ztna-a        = cidrsubnet(var.cidr, 3, 5)
    vnet-b        = cidrsubnet(var.cidr, 2, 3)
    workloads-b   = cidrsubnet(var.cidr, 3, 6)
    ztna-b        = cidrsubnet(var.cidr, 3, 7)
  }
  subnets = {
    mgmt        = module.vnet_sec.subnets.mgmt
    workloads-a = module.vnet_workloads_a.subnets.workloads-a
    workloads-b = module.vnet_workloads_b.subnets.workloads-b
    ztna-a      = module.vnet_workloads_a.subnets.ztna-a
    ztna-b      = module.vnet_workloads_b.subnets.ztna-b
  }
}
output "subnets" {
  value = local.subnets
}

resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.region
}


module "basic" {
  source = "github.com/rweglarz/c-azure//modules/basic"
  name   = var.name

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  mgmt_cidrs          = [for r in var.mgmt_ips : "${r.cidr}"]
}
