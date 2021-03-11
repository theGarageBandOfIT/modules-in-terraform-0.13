# A single project metadata, just to test that Terraform and Google Cloud Platform are working together

resource "google_compute_project_metadata" "default" {
  metadata = {
    echo = "hello world"
  }
}
