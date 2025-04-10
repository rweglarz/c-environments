locals {
  sc_folder = "Service Connections"
  subnets = {
    mgmt           = {
      cidr = cidrsubnet(var.cidr, 3, 0)
      nat  = true
    }
    public         = {
      cidr = cidrsubnet(var.cidr, 3, 1)
    }
    private        = {
      cidr = cidrsubnet(var.cidr, 3, 2)
    }
    workloads-a    = {
      cidr = cidrsubnet(var.cidr, 3, 4)
      nat  = true
    }
    workloads-b    = {
      cidr = cidrsubnet(var.cidr, 3, 6)
      nat  = true
    }
  }
}
