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

variable "gcp_office1_region" {
  type    = string
  default = "europe-west4"  # netherlands
}

variable "gcp_office1_zone" {
  type    = string
  default = "europe-west4-b"
}


variable "azure_dc3_region" {
  type    = string
  default = "West Europe"
}

variable "azure_dc4_region" {
  type    = string
  default = "Poland Central"
}

variable "azure_subscription_id" {
  type = string
}


variable "scm_auth_file" {
  default = null
}

variable "prisma_asn" {
  type    = string
  default = 65534
}

variable "asns" {
  default = {
    prisma    = 65534
    dc1_vpn   = 65010
    dc1_fw    = 65012
    dc2_vpn   = 65020
    dc2_fw    = 65022
    azure_dc3 = 65030
    azure_dc4 = 65040
    office1   = 65101
  }
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
  default = {}
}

variable "rn_public_ips" {
  default = {}
}

variable "dc1_vms" {
  default = {}
}

variable "dc2_vms" {
  default = {}
}

variable "azure_dc3_vms" {
  default = {}
}

variable "azure_dc4_vms" {
  default = {}
}

variable "office1_vms" {
  default = {
    linux = {
      jumphost = {
        subnet  = "mgmt"
        hostnum = 5
      }
    }
  }
}

variable "key_vault_id" {
  default = null
}
