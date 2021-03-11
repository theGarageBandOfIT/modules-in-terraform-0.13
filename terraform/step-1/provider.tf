// Configure Google Cloud provider

provider "google" {
  version         = "~> 3.0"
  project         = var.project
  region          = var.region
  credentials     = var.credentials
}

// Store tfstate file in a Google Cloud Storage bucket
terraform {
  backend "gcs" {
    prefix  = "terraform/state"
    bucket  = "modules-terraform-013-tfstate"
  }
}
