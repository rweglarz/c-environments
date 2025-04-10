output "gcp_dc1" {
  value = {
    linux = module.gcp_dc1.vms_linux
  }
}

output "gcp_dc2" {
  value = {
    linux = module.gcp_dc2.vms_linux
  }
}

