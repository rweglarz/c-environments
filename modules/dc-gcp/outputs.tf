output "subnets" {
  value = {
    mgmt      = google_compute_subnetwork.mgmt
    workloads = google_compute_subnetwork.workloads
  }
}
