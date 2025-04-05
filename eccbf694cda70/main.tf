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

provider "scm" {
  host       = "api.strata.paloaltonetworks.com"
  auth_file  = var.scm_auth_file
}

terraform {
  required_providers {
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
