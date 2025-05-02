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

variable "deploy_sc_vpn" {
  default = false
}
variable "deploy_sc_fw" {
  default = false
}
variable "deploy_rn" {
  default = false
}

variable "pa_vpn_peering_cidrs" {
  description = "service connection or remote network to ha-vpn bgp peering cidrs"
  default = [
    "169.254.250.244/30",
    "169.254.250.248/30",
  ]
}

variable "pa_fw_peering_cidr" {
  description = "service connection to fw bgp peering cidrs"
  default = "169.254.250.252/30"
}

variable "pa_vpn_public_ip" {
  description = "service connection or remote network public ip, connection to ha-vpn"
  default  = "192.168.1.1"
  nullable = false
}

variable "pa_fw_public_ip" {
  description = "service connection or remote network public ip, connection to fw"
  default  = "192.168.1.2"
  nullable = false
}

variable "pa_region" {
  description = "service connection or remote network region"
  type        = string
}

variable "spn_name" {
  default = null
}

variable "psk" {
  type = string
}

variable "deploy_ngfw" {
  default = false
}

variable "scm_ngfw_folder" {
 default = null 
 validation {
  condition = (var.scm_ngfw_folder!=null) || (var.deploy_ngfw==false)
  error_message = "need folder"
 }
}

variable "vms_linux" {
  default = {
    # jumphost = {
    #   subnet   = "mgmt"
    #   host_num = 5
    # }
  }
}

variable "vms_windows" {
  default = {
  }
}

variable "ngfw_image" {
  default = "vmseries-flex-byol-1125"
}

variable "ngfw_machine_type" {
  default = "n2-standard-4"
}

variable "ngfw_bootstrap" {
  type = map(string)
}

variable "gp_ip_pool_subnet" {
  description = "if provided - make it /24"
  default     = "10.254.254.0/24"
}
