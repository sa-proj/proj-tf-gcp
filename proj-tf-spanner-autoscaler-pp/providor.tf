terraform {
  required_providers {
    google = {
      version = ">3.5.0"
    }
  }
}

provider "google" {
    credentials = file("${var.creds_file}")

    project = var.project_id
    region  = var.region
    zone    = var.zone
}
