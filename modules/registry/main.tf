resource "google_artifact_registry_repository" "lusohub-repo" {
  location      = "europe-west1"
  repository_id = "lusohub-repo-mj"
  format        = "DOCKER"
}
