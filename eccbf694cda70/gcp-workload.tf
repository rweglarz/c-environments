data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2404-lts-amd64"
  project = "ubuntu-os-cloud"
}


resource "google_compute_instance" "vm_gcp_dc1_jumphost" {
  name         = "${local.env_prefix}-gcp-dc1-jumphost"
  machine_type = "f1-micro"
  provider     = google.dc1

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }

  network_interface {
    subnetwork = module.gcp_dc1.subnets.mgmt.id
    network_ip = cidrhost(module.gcp_dc1.subnets.mgmt.ip_cidr_range, 5)
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
