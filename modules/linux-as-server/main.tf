locals {
  params = merge(
    {
      hostname = "nohostname"
    },
    var.params,
  )
  smb_user = {
    name = "smb"
    lock_passwd = false
    passwd  = "$6$v2iEHve0$oFYQ5YaTRDd5D57kgp0EW3BIqpwXxRcdCXjU5Ktk7OrfDle7qS5yNDWS4rB/mpZhDLx7p27CSeVF0A3QT0gn51"
    shell = "/bin/bash"
    chpasswd = { expire = false }
  }
  common_user = {
    name = "povuser"
    lock_passwd = false
    passwd  = "$6$7xtlh3+b$XcvW6A3bGvsZugMGD83.2omOHzHKZzBvFg/IUKOSohg1U1lENx8gfZHIRb7lYAsqNrvKigDVoX0PEYMGWhuLE0"
    shell = "/bin/bash"
    chpasswd = { expire = false }
    sudo = "ALL=(ALL) NOPASSWD:ALL"
  }
}
