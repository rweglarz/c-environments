data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2404-lts-amd64"
  project = "ubuntu-os-cloud"
}


resource "google_compute_instance" "vm_gcp1" {
  name         = "${local.env_prefix}-gcp1"
  machine_type = "f1-micro"
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.net-s1.id
    network_ip = cidrhost(google_compute_subnetwork.net-s1.ip_cidr_range, 5)
    access_config {
      // Ephemeral public IP
    }
  }
  lifecycle {
    ignore_changes = [
      boot_disk[0].initialize_params[0].image,
    ]
  }
}
