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

output "azure_dc1" {
  value = {
    linux = module.azure_dc1.vms_linux
    ztna  = module.azure_dc1.vms_ztna
  }
}

output "azure_dc2" {
  value = {
    linux = module.azure_dc2.vms_linux
    ztna  = module.azure_dc2.vms_ztna
  }
}
