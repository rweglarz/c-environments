locals {
  smb_user = {
    name        = "smb"
    lock_passwd = false
    passwd      = "$6$v2iEHve0$oFYQ5YaTRDd5D57kgp0EW3BIqpwXxRcdCXjU5Ktk7OrfDle7qS5yNDWS4rB/mpZhDLx7p27CSeVF0A3QT0gn51"  # smb
    shell       = "/bin/bash"
    homedir     = "/data/data"
    chpasswd    = { expire = false }
  }
}


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
          path        = "/var/lib/cloud/scripts/per-once/cifs-setup.sh"
          content     = templatefile("${path.module}/init/cifs-setup.sh", local.params)
          permissions = "0744"
        },
        {
          path        = "/var/lib/cloud/scripts/per-once/common-setup.sh"
          content     = templatefile("${path.module}/init/common-setup.sh", local.params)
          permissions = "0744"
        },
        {
          path        = "/etc/samba/smb.conf"
          content     = templatefile("${path.module}/init/smb.conf", local.params)
          permissions = "0644"
        },
        {
          path        = "/etc/vsftpd.conf"
          content     = file("${path.module}/init/vsftpd.conf")
          permissions = "0644"
        },
      ]
      users = [
        local.smb_user,
        local.common_user,
      ]
      packages = [
        "fping",
        "net-tools",
        "samba",
        "smbclient",
        "vsftpd",
      ]
    })
  }
}
