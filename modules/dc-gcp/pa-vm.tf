resource "google_compute_address" "fw_public" {
  name         = "${var.name}-fw-public"
  address_type = "EXTERNAL"
}
