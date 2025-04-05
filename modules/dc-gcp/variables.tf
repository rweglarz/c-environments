variable "name" {
  type = string
}

variable "mgmt_ips" {
  default = []
}

variable "gcp_region" {
  type    = string
  default = null
}

variable "cidr" {
  default = "172.16.0.0/24"
}

variable "prisma_asn" {
  default = 65534
}

variable "gcp_asn" {
  default = 64520
}

variable "fw_asn" {
  default = 64521
}

variable "bgp_peer_enable" {
  default = [
    true, # vpn-pri
    true, # vpn-sec
    true, # fw
  ]
}

variable "sc_vpn_peering_cidrs" {
  default = [
    "169.254.250.244/30",
    "169.254.250.248/30",
  ]
}

variable "sc_fw_peering_cidr" {
  default = "169.254.250.252/30"
}

variable "sc_vpn_public_ip" {
  default  = "192.168.1.1"
  nullable = false
}

variable "sc_fw_public_ip" {
  default  = "192.168.1.2"
  nullable = false
}

variable "sc_region" {
  description = "service connection region"
  type        = string
}


variable "psk" {
  type = string
}

variable "deploy_ngfw" {
  default = false
}
