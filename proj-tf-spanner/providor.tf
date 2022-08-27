terraform {
  required_providers {
    google = {
      version = ">3.5.0"
    }
  }
}

provider "google" {
    credentials = var.creds
    project = var.gcp_project_id
}