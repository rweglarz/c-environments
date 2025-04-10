output "vms_linux" {
  value = { for k,v in module.vm_linux: k => v.private_ip_address }
}

output "vms_ztna" {
  value = { for k,v in module.vm_ztna: k => v.private_ip_address }
}
