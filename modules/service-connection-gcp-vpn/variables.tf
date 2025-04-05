variable "name" {
  type = string
}

variable "prisma_asn" {
  default = 65534
}

variable "compute_router_name" {
  type = string
}

variable "ha_vpn_gateway_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "bgp_peer_enable" {
  default = [
    true, # vpn-pri
    true, # vpn-sec
  ]
}

variable "peering_cidrs" {
  default = [
    "169.254.250.244/30",
    "169.254.250.248/30",
  ]
}

variable "sc_public_ip" {
  type = string
}

variable "sc_region" {
  description = "service connection region"
  type        = string
}


variable "psk" {
  type = string
}

