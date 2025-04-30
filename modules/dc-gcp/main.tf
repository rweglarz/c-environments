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
  private_ips = {
    ngfw = {
      mgmt    = cidrhost(local.subnets.mgmt.cidr, 4)
      public  = cidrhost(local.subnets.public.cidr, 4)
      private = cidrhost(local.subnets.private.cidr, 4)
    }
    gcp_cr = {
      primary   = cidrhost(local.subnets.private.cidr, 5)
      redundant = cidrhost(local.subnets.private.cidr, 6)
    }
  }
}
