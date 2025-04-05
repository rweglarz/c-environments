output "workload_ips" {
  value = {
    gcp_dc1_jumphost   = {
      private = google_compute_instance.vm_gcp_dc1_jumphost.network_interface[0].network_ip
      public  = google_compute_instance.vm_gcp_dc1_jumphost.network_interface[0].access_config[0].nat_ip
    }
  }
}
