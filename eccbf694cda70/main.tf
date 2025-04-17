provider "azurerm" {
  features {
  }
  subscription_id = var.azure_subscription_id
}

provider "google" {
  region  = var.gcp_dc1_region
  zone    = var.gcp_dc1_zone
  project = var.gcp_project
  alias   = "dc1"
}
provider "google" {
  region  = var.gcp_dc2_region
  zone    = var.gcp_dc2_zone
  project = var.gcp_project
  alias   = "dc2"
}
provider "google" {
  region  = var.gcp_office1_region
  zone    = var.gcp_office1_zone
  project = var.gcp_project
  alias   = "office1"
}

provider "scm" {
  host       = "api.strata.paloaltonetworks.com"
  auth_file  = var.scm_auth_file
}

terraform {
  required_providers {
    azurerm = {
      version = "~>4.18"
    }
    google = {
      source  = "hashicorp/google"
      version = "~>5.38"
    }
    scm = {
      source  = "PaloAltoNetworks/scm"
      version = "~>0.10"
    }
  }
}
