terraform {
  required_providers {
    google = {
      version = "5.29.1"
    }
  }
}

provider "google" {
  project     = var.project_id
  credentials = "./environments/prod/prod.json"
}

provider "google-beta" {
  project     = var.project_id
  credentials = "./environments/prod/prod.json"
}
