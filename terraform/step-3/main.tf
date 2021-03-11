# A single project metadata, just to test that Terraform and Google Cloud Platform are working together

resource "google_compute_project_metadata" "default" {
  metadata = {
    echo = "hello world"
  }
}

# -----------------------------------------------------------------------------
# our first pokemon
# -----------------------------------------------------------------------------

resource "google_cloud_run_service" "bulbizarre" {
  name     = "bulbizarre"
  location = var.region

  template {
    spec {
      containers {
        image = "eu.gcr.io/modules-terraform-013/hello-bulbizarre"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# IAM entry for all users to invoke the Cloud Run service
resource "google_cloud_run_service_iam_member" "bulbizarre_invoker" {
  project  = google_cloud_run_service.bulbizarre.project
  location = google_cloud_run_service.bulbizarre.location
  service  = google_cloud_run_service.bulbizarre.name

  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "bulbizarre_endpoint" {
  description = "The URL to access to this Pokemon app"
  value       = google_cloud_run_service.bulbizarre.status[0].url
}

# -----------------------------------------------------------------------------
# the best of all pokemons
# -----------------------------------------------------------------------------

resource "google_cloud_run_service" "pikachu" {
  name     = "pikachu"
  location = var.region

  template {
    spec {
      containers {
        image = "eu.gcr.io/modules-terraform-013/hello-pikachu"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# IAM entry for all users to invoke the Cloud Run service
resource "google_cloud_run_service_iam_member" "pikachu_invoker" {
  project  = google_cloud_run_service.pikachu.project
  location = google_cloud_run_service.pikachu.location
  service  = google_cloud_run_service.pikachu.name

  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "pikachu_endpoint" {
  description = "The URL to access to this Pokemon app"
  value       = google_cloud_run_service.pikachu.status[0].url
}

# -----------------------------------------------------------------------------
# pokemon modules
# -----------------------------------------------------------------------------

module "salameche" {
  source = "./pokemon_module"

  pokemon_name         = "salameche"
  pokemon_location     = var.region
  pokemon_docker_image = "eu.gcr.io/modules-terraform-013/hello-salameche"
}

output "salameche_endpoint" {
  description = "The URL to access to this Pokemon app"
  value       = module.salameche.any_pokemon_endpoint
}

module "carapuce" {
  source = "./pokemon_module"

  pokemon_name         = "carapuce"
  pokemon_docker_image = "eu.gcr.io/modules-terraform-013/hello-carapuce"
}

output "carapuce_endpoint" {
  description = "The URL to access to this Pokemon app"
  value       = module.carapuce.any_pokemon_endpoint
}

# -----------------------------------------------------------------------------
# pokemon iterator - invokation v.1
# -----------------------------------------------------------------------------

locals {
  pokemon_herd = {
    "chenipan" = {
      name         = "chenipan",
      location     = var.region,
      docker_image = "eu.gcr.io/modules-terraform-013/hello-chenipan"
    },
    "aspicot" = {
      name         = "aspicot",
      location     = "us-west1",
      docker_image = "eu.gcr.io/modules-terraform-013/hello-aspicot"
    },
    "roucool" = {
      name         = "roucool",
      location     = var.region,
      docker_image = "eu.gcr.io/modules-terraform-013/hello-roucool"
    },
  }
}

module "others" {
  for_each = toset(keys(local.pokemon_herd))
  source = "./pokemon_iterator"

  pokemon_attributes = local.pokemon_herd[each.value]
}

output "all_pokemon_endpoint" {
  description = "The URL list to access to all Pokemon apps"
  value       = values(module.others)
}
