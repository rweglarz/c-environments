module "vnet_sec" {
  source              = "github.com/rweglarz/c-azure//modules/vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name          = "${var.name}-sec"
  address_space = [local.cidrs.sec]

  subnets = {
    mgmt = {
      address_prefixes = [local.cidrs.mgmt]
      associate_nsg    = true
      network_security_group_id = module.basic.sg_id.mgmt
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
      associate_nsg    = true
      network_security_group_id = module.basic.sg_id.mgmt
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
      associate_nsg    = true
      network_security_group_id = module.basic.sg_id.mgmt
    },
  }
}



module "vnet_peering_a" {
  source = "github.com/rweglarz/c-azure//modules/vnet_peering"

  on_local = {
    resource_group_name     = azurerm_resource_group.this.name
    virtual_network_name    = module.vnet_workloads_a.vnet.name
    virtual_network_id      = module.vnet_workloads_a.vnet.id
    use_remote_gateways     = true
  }
  on_remote = {
    resource_group_name    = azurerm_resource_group.this.name
    virtual_network_name   = module.vnet_sec.vnet.name
    virtual_network_id     = module.vnet_sec.vnet.id
    allow_gateway_transit  = true
  }
}

module "vnet_peering_b" {
  source = "github.com/rweglarz/c-azure//modules/vnet_peering"

  on_local = {
    resource_group_name     = azurerm_resource_group.this.name
    virtual_network_name    = module.vnet_workloads_b.vnet.name
    virtual_network_id      = module.vnet_workloads_b.vnet.id
    use_remote_gateways     = true
  }
  on_remote = {
    resource_group_name    = azurerm_resource_group.this.name
    virtual_network_name   = module.vnet_sec.vnet.name
    virtual_network_id     = module.vnet_sec.vnet.id
    allow_gateway_transit  = true
  }
}


locals {
  deploy_vng = var.deploy_rn || var.deploy_sc
}

resource "azurerm_public_ip" "vng-a" {
  count = local.deploy_vng ? 1 : 0
  name                = "${var.name}-vng-a"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "vng-b" {
  count = local.deploy_vng ? 1 : 0
  name                = "${var.name}-vng-b"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
}

resource "azurerm_virtual_network_gateway" "this" {
  count = local.deploy_vng ? 1 : 0
  name                = var.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = true
  enable_bgp    = true
  sku           = "VpnGw1"

  bgp_settings {
    asn = var.azure_asn
  }

  ip_configuration {
    name = "i0"
    public_ip_address_id          = azurerm_public_ip.vng-a[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.vnet_sec.subnets.GatewaySubnet.id
  }
  ip_configuration {
    name = "i1"
    public_ip_address_id          = azurerm_public_ip.vng-b[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = module.vnet_sec.subnets.GatewaySubnet.id
  }
}
