# not used for now as this can't be configured end-end on scm with terraform today

# resource "scm_ike_gateway" "fw" {
#   name = "${var.name}-ikeg"

#   authentication = {
#     pre_shared_key = {
#       key = var.psk
#     }
#   }
#   protocol = {
#     version = "ikev2"
#     ikev2 = {
#       ike_crypto_profile = "Suite-B-GCM-256"
#       dpd                = { enable = true }
#     }
#     # ikev1 = {
#     #   dpd                = { enable = true }
#     # }
#   }
#   protocol_common = {
#     nat_traversal = { enable = true }
#     fragmentation = { enable = false }
#   }
#   peer_address = {
#     ip = var.pa_public_ip
#   }

#   folder = var.folder
# }


# resource "scm_ipsec_tunnel" "fw" {
#   name = "${var.name}-ipsect"

#   auto_key = {
#     ipsec_crypto_profile = "Suite-B-GCM-256"
#     ike_gateways = [{
#       name = scm_ike_gateway.fw.name
#     }]
#   }
#   anti_replay = true

#   folder = var.folder
# }
