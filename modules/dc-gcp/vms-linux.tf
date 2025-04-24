data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2404-lts-amd64"
  project = "ubuntu-os-cloud"
}


module "linux_bs" {
  source = "../linux-as-server"
  for_each = var.vms_linux

  params = try(each.value.params, {})
  type   = try(each.value.type, null)
  username = try(each.value.auth.username, null)
  password = try(each.value.auth.password, null)
}


resource "google_compute_instance" "vm_linux" {
  for_each = var.vms_linux

  name         = "${var.name}-${each.key}"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
    }
  }
  metadata = {
    user-data = try(module.linux_bs[each.key].rendered, null)
  }
  deletion_protection = try(each.value.params.deletion_protection, false)

  network_interface {
    subnetwork = google_compute_subnetwork.this[each.value.subnet].id
    network_ip = try(cidrhost(google_compute_subnetwork.this[each.value.subnet].ip_cidr_range, each.value.hostnum), null)
  }
  lifecycle {
    ignore_changes = [
      boot_disk[0].initialize_params[0].image,
    ]
  }
}
