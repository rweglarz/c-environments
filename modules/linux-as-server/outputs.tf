output "rendered" {
  value = try(
    data.cloudinit_config.webserver[0].rendered,
    null
  )
}
