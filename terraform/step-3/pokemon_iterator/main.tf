# -----------------------------------------------------------------------------
# pokemon iterator
# -----------------------------------------------------------------------------

# name (mandatory) Name for the pokemon service. Must be unique.
# location (mandatory) The location the CloudRun service is deployed into
# docker_image (mandatory) The Docker image to deploy in the CloudRun service
variable "pokemon_attributes" {
  description = "Map of variables used by Pokemon iterator. See code comment for more details"
  type        = map
}

resource "google_cloud_run_service" "all_pokemon" {
  name     = "pokemon-${var.pokemon_attributes["name"]}"
  location = var.pokemon_attributes["location"]

  template {
    spec {
      containers {
        image = var.pokemon_attributes["docker_image"]
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
  project  = google_cloud_run_service.all_pokemon.project
  location = google_cloud_run_service.all_pokemon.location
  service  = google_cloud_run_service.all_pokemon.name

  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "all_pokemon_name" {
  description = "The name of this Pokemon app"
  value       = google_cloud_run_service.all_pokemon.name
}

output "all_pokemon_endpoint" {
  description = "The URL to access to this Pokemon app"
  value       = google_cloud_run_service.all_pokemon.status[0].url
}
