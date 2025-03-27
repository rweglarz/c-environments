provider "google" {
  region  = var.gcp_region
  zone    = var.gcp_zone
  project = var.gcp_project
}

provider "scm" {
  host          = "api.strata.paloaltonetworks.com"
  client_id     = var.scm_creds.client_id
  client_secret = var.scm_creds.client_secret
  scope         = "tsg_id:${var.scm_creds.tsg_id}"
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
