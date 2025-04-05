variable "name" {
  default = "eccbf"
}

variable "gcp_project" {
  type = string
}

variable "gcp_dc1_region" {
  type    = string
  default = "europe-west4"  # netherlands
}

variable "gcp_dc1_zone" {
  type    = string
  default = "europe-west4-b"
}

variable "gcp_dc2_region" {
  type    = string
  default = "europe-central2"  # poland
}

variable "gcp_dc2_zone" {
  type    = string
  default = "europe-central2-b"
}



variable "azure_cidr" {
  default = "172.16.196.0/22"
}
variable "gcp_cidr" {
  default = "172.16.200.0/22"
}

variable "scm_auth_file" {
  default = null
}

variable "gcp_asn" {
  type    = string
  default = 64521
}
variable "gcp_peer_enable" {
  description = "disable bgp peer on google side"
  type = list(bool)
  default = [ 
    true,
    true,
  ]
}

variable "prisma_asn" {
  type    = string
  default = 65534
}

variable "psk" {
  type = string
}

variable "gcp_sc_peering_cidr" {
  default = [
    "169.254.250.248/30",
    "169.254.250.252/30",
  ]
}
variable "mgmt_ips" {
  default = []
}

variable "sc_public_ips" {
  default = null
}
