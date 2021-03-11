# -----------------------------------------------------------------------------
# pokemon module
# -----------------------------------------------------------------------------

# name (mandatory) Name for the pokemon service. Must be unique.
# location (mandatory) The location the CloudRun service is deployed into
# docker_image (mandatory) The Docker image to deploy in the CloudRun service

variable "pokemon_name" {
  description = "Name for the pokemon service. Must be unique."
  type        = string
}

variable "pokemon_location" {
  description = "The location the CloudRun service is deployed into"
  type        = string
  default     = "europe-west1"
}

variable "pokemon_docker_image" {
  description = "The Docker image to deploy in the CloudRun service"
  type        = string
  default     = "eu.gcr.io/modules-terraform-013/hello-balbizarre"
}

resource "google_cloud_run_service" "any_pokemon" {
  name     = var.pokemon_name
  location = var.pokemon_location

  template {
    spec {
      containers {
        image = var.pokemon_docker_image
      }
    }
  } 

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# IAM entry for all users to invoke the Cloud Run service
resource "google_cloud_run_service_iam_member" "invoker" {
  project  = google_cloud_run_service.any_pokemon.project
  location = google_cloud_run_service.any_pokemon.location
  service  = google_cloud_run_service.any_pokemon.name

  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "any_pokemon_endpoint" {
  description = "The URL to access to this Pokemon app"
  value       = google_cloud_run_service.any_pokemon.status[0].url
}
