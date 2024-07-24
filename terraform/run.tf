resource "google_cloud_run_v2_service" "slackbot-backend" {
  name     = "slackbot-backend"
  project  = var.project_id
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/slackbot-images/slackbot:latest"
      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
      env {
        name = "GOOGLE_API_KEY"
        value_source {
          secret_key_ref {
            secret  = "google_api_key"
            version = "latest"
          }
        }
      }
      env {
        name = "SLACK_TOKEN"
        value_source {
          secret_key_ref {
            secret  = "slack_token"
            version = "latest"
          }
        }
      }
      env {
        name  = "FLASK_APP"
        value = "main.py"
      }
    }
  }
}

resource "google_cloud_run_service_iam_binding" "default" {
  location = google_cloud_run_v2_service.slackbot-backend.location
  service  = google_cloud_run_v2_service.slackbot-backend.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}