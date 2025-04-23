data "google_compute_image" "windows_server" {
  family  = "windows-2022"
  project = "windows-cloud"
}

data "google_compute_image" "windows_server_core" {
  family  = "windows-2022-core"
  project = "windows-cloud"
}

resource "google_compute_instance" "vm_windows" {
  for_each = var.vms_windows

  name         = "${var.name}-${each.key}"
  machine_type = try(each.value.machine_type, "n2-standard-2")

  boot_disk {
    initialize_params {
      image = data.google_compute_image.windows_server.self_link
    }
  }
  deletion_protection = try(each.value.params.deletion_protection, false)

  network_interface {
    subnetwork = google_compute_subnetwork.this[each.value.subnet].id
    network_ip = try(cidrhost(google_compute_subnetwork.this[each.value.subnet].ip_cidr_range, each.value.hostnum), null)
  }
  lifecycle {
    ignore_changes = [
      boot_disk[0].initialize_params[0].image,
      metadata["windows-keys"],
    ]
  }
}
