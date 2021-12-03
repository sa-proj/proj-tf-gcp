terraform {
  required_providers {
    google = {
      version = ">3.5.0"
    }
  }
}

provider "google" {
    credentials = file("${var.creds_file}")
    project = var.gcp_project_id
}