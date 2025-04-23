output "rendered" {
  value = try(
    data.cloudinit_config.cifs[0].rendered,
    data.cloudinit_config.jumphost[0].rendered,
    data.cloudinit_config.webserver[0].rendered,
    null
  )
}
