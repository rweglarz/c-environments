variable "name" {
  type = string
}

variable "prisma_asn" {
  default = 65534
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "virtual_network_gateway" {
}

variable "bgp_peer_enable" {
  default = [
    true, # vpn-pri
    true, # vpn-sec
  ]
}

variable "peering_cidr" {
  description = "only used for prisma side, vng uses vnet address"
  default = "192.168.254.244/30"
  nullable = false
}

variable "pa_public_ip" {
  type = string
  default = "192.168.1.1"
  nullable = false
}

variable "pa_region" {
  description = "service connection region"
  type        = string
}


variable "psk" {
  type = string
}


variable "deploy_rn" {
  default = false
}

variable "deploy_sc" {
  default = false
  validation {
    condition     = var.deploy_rn || var.deploy_sc
    error_message = "need to deploy either rn or sc"
  }
  validation {
    condition     = !(var.deploy_rn && var.deploy_sc)
    error_message = "only one of rn or sc can be deployed"
  }
}

variable "spn_name" {
  default = null
}

variable "license_type" {
  default = "FWAAS-AGGREGATE"
}
