terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.26"
    }
    scm = {
      source  = "PaloAltoNetworks/scm"
      version = "~>0.10"
    }
  }
}
