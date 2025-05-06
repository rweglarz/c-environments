variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "mgmt_ips" {
  default = []
}

variable "cidr" {
  default = "172.16.0.0/24"
}

variable "vms_linux" {
  default = {
  }
}

variable "vms_windows" {
  default = {
  }
}

variable "vms_ztna" {
  default = {
  }
}

variable "ssh_public_key" {
}

variable "deploy_sc" {
  default = false
}
variable "deploy_rn" {
  default = false
}

variable "prisma_asn" {
  default = 65534
}

variable "azure_asn" {
  default = 64520
}

variable "spn_name" {
  default = null
}

variable "psk" {
  type    = string
  default = null
}

variable "pa_vpn_peering_cidr" {
  description = "service connection or remote network to vng bgp peering cidrs"
  default = null
}

variable "pa_vpn_public_ip" {
  description = "service connection or remote network public ip, connection to vng"
  default = null
}

variable "pa_region" {
  description = "service connection region"
  type        = string
  default     = null
}

variable "vnet_peering_a_b" {
  type    = bool
  default = false
}
