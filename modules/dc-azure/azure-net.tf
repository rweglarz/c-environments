module "vnet_sec" {
  source              = "github.com/rweglarz/c-azure//modules/vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name          = "${var.name}-sec"
  address_space = [local.cidrs.sec]

  subnets = {
    mgmt = {
      associate_nsg    = false
      address_prefixes = [local.cidrs.mgmt]
      #   network_security_group_id = module.azure_basic.sg_id.mgmt
    },
    public = {
      address_prefixes = [local.cidrs.public]
    },
    private = {
      address_prefixes = [local.cidrs.private]
    },
    GatewaySubnet = {
      address_prefixes = [local.cidrs.GatewaySubnet]
    }
  }
}


module "vnet_workloads_a" {
  source              = "github.com/rweglarz/c-azure//modules/vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name          = "${var.name}-workloads-a"
  address_space = [local.cidrs.workloads-a]

  subnets = {
    workloads-a = {
      address_prefixes = [local.cidrs.workloads-a]
    },
  }
}


module "vnet_workloads_b" {
  source              = "github.com/rweglarz/c-azure//modules/vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name          = "${var.name}-workloads-b"
  address_space = [local.cidrs.workloads-b]

  subnets = {
    workloads-b = {
      address_prefixes = [local.cidrs.workloads-b]
    },
  }
}



module "vnet_peering_a" {
  source = "github.com/rweglarz/c-azure//modules/vnet_peering"

  on_local = {
    resource_group_name     = azurerm_resource_group.this.name
    virtual_network_name    = module.vnet_workloads_a.vnet.name
    virtual_network_id      = module.vnet_workloads_a.vnet.id
  }
  on_remote = {
    resource_group_name    = azurerm_resource_group.this.name
    virtual_network_name   = module.vnet_sec.vnet.name
    virtual_network_id     = module.vnet_sec.vnet.id
  }
}

module "vnet_peering_b" {
  source = "github.com/rweglarz/c-azure//modules/vnet_peering"

  on_local = {
    resource_group_name     = azurerm_resource_group.this.name
    virtual_network_name    = module.vnet_workloads_b.vnet.name
    virtual_network_id      = module.vnet_workloads_b.vnet.id
  }
  on_remote = {
    resource_group_name    = azurerm_resource_group.this.name
    virtual_network_name   = module.vnet_sec.vnet.name
    virtual_network_id     = module.vnet_sec.vnet.id
  }
}
