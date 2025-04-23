data "cloudinit_config" "jumphost" {
  count = try(var.type=="jumphost") ? 1 : 0

  gzip          = var.gzip
  base64_encode = var.base64_encode

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content = yamlencode({
      write_files = [
        {
          path        = "/var/lib/cloud/scripts/per-once/common-setup.sh"
          content     = templatefile("${path.module}/init/common-setup.sh", local.params)
          permissions = "0744"
        },
      ]
      users = [
        "default",
        local.common_user,
      ]
      packages = [
        "fping",
        "lftp",
        "net-tools",
        "smbclient",
      ]
    })
  }
}
