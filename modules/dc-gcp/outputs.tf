output "vms_linux" {
  value = { for k,v in google_compute_instance.vm_linux: k => { private_ip_address = v.network_interface[0].network_ip, type = try(var.vms_linux[k].type, null) } }
}

output "vms_windows" {
  value = { for k,v in google_compute_instance.vm_windows: k => { private_ip_address = v.network_interface[0].network_ip, type = try(var.vms_windows[k].type, null) } }
}
