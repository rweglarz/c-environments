data "cloudinit_config" "cifs" {
  count = try(var.type=="cifs") ? 1 : 0

  gzip          = var.gzip
  base64_encode = var.base64_encode

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content = yamlencode({
      write_files = [
        {
          path        = "/var/lib/cloud/scripts/per-once/setup.sh"
          content     = templatefile("${path.module}/init/cifs-setup.sh", local.params)
          permissions = "0744"
        },
        {
          path        = "/etc/samba/smb.conf"
          content     = templatefile("${path.module}/init/smb.conf", local.params)
          permissions = "0644"
        },
      ]
      users = [
        "default",
        "smb",
      ]
      packages = [
        "fping",
        "net-tools",
        "samba",
        "smbclient",
      ]
    })
  }
}
