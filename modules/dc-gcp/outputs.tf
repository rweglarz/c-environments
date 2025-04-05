output "subnets" {
  value = {
    mgmt      = google_compute_subnetwork.public
    workloads = google_compute_subnetwork.workloads
  }
}
