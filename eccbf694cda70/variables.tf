variable "name" {
  default = "prisma-gcp"
}

variable "gcp_region" {
  type    = string
  default = "europe-west1"
}

variable "gcp_zone" {
  type    = string
  default = "europe-west1-b"
}

variable "gcp_project" {
  type = string
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
variable "sc_public_ip" {
  description = "update with proper IP after commit of SC"
  type        = string
  default     = "192.0.2.1"
}

variable "sc_region" {
  description = "service connection region"
  type        = string
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