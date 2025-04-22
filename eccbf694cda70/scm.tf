resource "scm_address_object" "azure" {
  for_each = merge(
    module.azure_dc3.vms_linux,
    module.azure_dc4.vms_linux,
    {
      application-aa: { type = "webserver" }
      application-ap: { type = "webserver" }
    }
  )
  name    = each.key
  fqdn    = format("%s.%s", each.key, var.dns_zone)
  folder  = "All"
  tags    = compact([
    each.value.type=="cifs" ? "Private-SMBServer" : null,
    each.value.type=="webserver" ? "Private-WebApp" : null,
    each.value.type=="webserver" ? "Private-SSHServer" : null,
    each.value.type==null ? "Private-SSHServer" : null,
  ])
}

# resource "scm_security_rule" "rule1" {
#   name         = "${local.env_prefix}-rule1"
#   folder       = local.pa_folder
#   action       = "deny"
#   source_users = ["any"]
#   sources = [
#     "192.168.66.1"
#   ]
#   destinations = [
#     "192.168.66.255"
#   ]
#   applications = ["any"]
#   categories   = ["any"]
#   services     = ["any"]
#   froms        = ["any"]
#   tos          = ["any"]
# }
