resource "google_artifact_registry_repository" "slackbot-images" {
  location      = var.region
  project       = var.project_id
  repository_id = "slackbot-images"
  description   = "Slackbot Images Repository"
  format        = "DOCKER"
}