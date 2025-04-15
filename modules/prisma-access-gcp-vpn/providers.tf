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
