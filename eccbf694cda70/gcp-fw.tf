resource "google_compute_firewall" "this-i" {
  for_each = merge(
    {
      mgmt = google_compute_network.net1.id
    },
  )
  name      = "${local.env_prefix}-${each.key}-i"
  network   = each.value
  direction = "INGRESS"
  source_ranges = concat(
    [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ],
    [for r in var.mgmt_ips : r.cidr],
  )
  allow {
    protocol = "all"
  }
}