resource "google_compute_firewall" "this-i" {
  for_each = merge(
    {
      mgmt        = google_compute_network.this["mgmt"].id
      workloads-a = google_compute_network.this["workloads-a"].id
      workloads-b = google_compute_network.this["workloads-b"].id
    },
  )
  name      = "${var.name}-${each.key}-i"
  network   = each.value
  direction = "INGRESS"
  source_ranges = concat(
    [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "100.92.0.0/16",   # prisma
      "192.168.0.0/16",
      "35.235.240.0/20", # iap
    ],
    [for r in var.mgmt_ips : r.cidr],
  )
  allow {
    protocol = "all"
  }
}
