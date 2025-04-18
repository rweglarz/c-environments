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

output "azure_dc3" {
  value = {
    linux = module.azure_dc3.vms_linux
    ztna  = module.azure_dc3.vms_ztna
  }
}

output "azure_dc4" {
  value = {
    linux = module.azure_dc4.vms_linux
    ztna  = module.azure_dc4.vms_ztna
  }
}
