locals {
  params = merge(
    {
      hostname = "nohostname"
    },
    var.params,
  )
}
