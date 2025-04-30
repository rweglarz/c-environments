variable "name" {
  type = string
}

variable "pa_asn" {
  default = 65534
}

variable "fw_asn" {
  default = null
}

variable "peering_cidr" {
  default = "169.254.250.252/30"
}

variable "pa_public_ip" {
  type = string
}

variable "fw_public_ip" {
  type = string
}

variable "pa_region" {
  description = "service connection region"
  type        = string
}

variable "psk" {
  type = string
}

variable "folder" {
  description = "firewall configuration folder"
  type = string
}
