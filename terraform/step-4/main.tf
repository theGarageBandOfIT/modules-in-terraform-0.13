# A single project metadata, just to test that Terraform and Google Cloud Platform are working together

resource "google_compute_project_metadata" "default" {
  metadata = {
    echo = "hello world"
  }
}

# -----------------------------------------------------------------------------
# pokemon iterator - invokation v.2
# -----------------------------------------------------------------------------

locals {
  pokemon_herd = fileset("${path.module}/pokemon_corral", "*")

  # pokemon_herd = {
  #   "chenipan" = {
  #     name         = "chenipan",
  #     location     = var.region,
  #     docker_image = "eu.gcr.io/modules-terraform-013/hello-chenipan"
  #   },
  #   "aspicot" = {
  #     name         = "aspicot",
  #     location     = "us-west1",
  #     docker_image = "eu.gcr.io/modules-terraform-013/hello-aspicot"
  #   },
  #   "roucool" = {
  #     name         = "roucool",
  #     location     = var.region,
  #     docker_image = "eu.gcr.io/modules-terraform-013/hello-roucool"
  #   },
  # }
}

module "others" {
  # for_each = toset(keys(local.pokemon_herd))
  count = length(tolist(local.pokemon_herd))
  source = "./pokemon_iterator"

  # pokemon_attributes = local.pokemon_herd[each.value]
  pokemon_attributes = tomap(jsondecode(file("${path.module}/pokemon_corral/${tolist(local.pokemon_herd)[count.index]}")))
}

output "all_pokemon_endpoint" {
  description = "The URL list to access to all Pokemon apps"
  value       = module.others
}
