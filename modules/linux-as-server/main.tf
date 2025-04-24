locals {
  params = merge(
    {
      hostname = "nohostname"
    },
    var.params,
  )
  common_user = var.username!=null ? {
    name        = var.username
    passwd      = var.password
    lock_passwd = false
    shell       = "/bin/bash"
    chpasswd    = { expire = false }
    sudo        = "ALL=(ALL) NOPASSWD:ALL"
  } : null
}
