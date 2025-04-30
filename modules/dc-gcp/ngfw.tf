resource "google_compute_address" "ngfw_public" {
  count = (var.deploy_ngfw || var.deploy_sc_fw) ? 1 : 0
  name         = "${var.name}-ngfw-public"
  address_type = "EXTERNAL"
}


resource "google_compute_instance" "ngfw" {
  count = var.deploy_ngfw ? 1 : 0
  name         = "${var.name}-ngfw"
  machine_type = var.ngfw_machine_type

  metadata = var.ngfw_bootstrap
  
  can_ip_forward = true

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute.readonly",
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
    ]
  }

  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/paloaltonetworksgcp-public/global/images/${var.ngfw_image}"
    }
    auto_delete = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.this["mgmt"].id
    network_ip = local.private_ips.ngfw.mgmt
  }
  network_interface {
    subnetwork = google_compute_subnetwork.this["public"].id
    network_ip = local.private_ips.ngfw.public
    access_config {
      nat_ip = google_compute_address.ngfw_public[0].address
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.this["private"].id
    network_ip = local.private_ips.ngfw.private
  }
}
