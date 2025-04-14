data "cloudinit_config" "webserver" {
  count = try(var.type=="webserver") ? 1 : 0

  gzip          = var.gzip
  base64_encode = var.base64_encode

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content = yamlencode({
      write_files = [
        {
          path        = "/var/lib/cloud/scripts/per-once/setup.sh"
          content     = templatefile("${path.module}/init/webserver-setup.sh", local.params)
          permissions = "0744"
        },
        {
          path        = "/home/app/webserver.py"
          content     = file("${path.module}/init/webserver.py")
          permissions = "0744"
        },
      ]
      users = [
        "default",
        {
          name = "app"
          shell = "/usr/bin/bash"
        }
      ]
      packages = [
        "authbind",
        "fping",
        "net-tools",
        "python3-pip",
        "python3.12-venv",
      ]
    })
  }
}
