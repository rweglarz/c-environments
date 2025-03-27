resource "scm_security_rule" "rule1" {
  name         = "${local.env_prefix}-rule1"
  folder       = local.pa_folder
  action       = "deny"
  source_users = ["any"]
  sources = [
    "192.168.66.1"
  ]
  destinations = [
    "192.168.66.255"
  ]
  applications = ["any"]
  categories   = ["any"]
  services     = ["any"]
  froms        = ["any"]
  tos          = ["any"]
}
