output "vms_linux" {
  value = { for k,v in module.vm_linux: k => { private_ip_address = v.private_ip_address, type = try(var.vms_linux[k].type, null) } }
}

output "vms_ztna" {
  value = { for k,v in module.vm_ztna: k => { private_ip_address = v.private_ip_address, type = "ztna" } }
}

output "vnet_ids" {
  value = {
    sec         = module.vnet_sec.vnet.id
    workloads-a = module.vnet_workloads_a.vnet.id
    workloads-b = module.vnet_workloads_b.vnet.id
  }
}
