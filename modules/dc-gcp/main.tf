locals {
  sc_folder = "Service Connections"
  cidr = {
    mgmt      = cidrsubnet(var.cidr, 2, 0)
    public    = cidrsubnet(var.cidr, 2, 1)
    private   = cidrsubnet(var.cidr, 2, 2)
    workloads = cidrsubnet(var.cidr, 2, 3)
  }
}
