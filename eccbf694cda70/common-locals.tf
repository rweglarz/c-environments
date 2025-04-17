locals {
  sc_folder = "Service Connections"
  pa_folder = "Prisma Access"

  env_prefix = "${var.name}"
  cidrs = {
    dc1       = "172.16.1.0/24"
    dc2       = "172.16.2.0/24"
    azure-dc1 = "172.16.3.0/24"
    azure-dc2 = "172.16.4.0/24"
    office1   = "172.16.101.0/24"
  }
}

