resource "google_secret_manager_secret" "google_api_key" {
  secret_id = "google_api_key"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  depends_on = [time_sleep.wait_60_seconds]
}
resource "google_secret_manager_secret_iam_binding" "google_api_key" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.google_api_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${data.google_compute_default_service_account.default.email}",
  ]
}

resource "google_secret_manager_secret" "slack_token" {
  secret_id = "slack_token"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  depends_on = [time_sleep.wait_60_seconds]
}
resource "google_secret_manager_secret_iam_binding" "slack_token" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.slack_token.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${data.google_compute_default_service_account.default.email}",
  ]
}