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
