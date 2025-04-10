output "vms_linux" {
  value = { for k,v in google_compute_instance.vm_linux: k => v.network_interface[0].network_ip }
}
