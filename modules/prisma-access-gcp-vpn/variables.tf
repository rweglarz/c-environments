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

variable "pa_public_ip" {
  type = string
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
