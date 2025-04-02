provider "google" {
  region  = var.gcp_region
  zone    = var.gcp_zone
  project = var.gcp_project
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
