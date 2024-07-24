resource "google_project_service" "project" {
  for_each = toset(var.api_list)

  project = var.project_id
  service = each.key
}

resource "time_sleep" "wait_60_seconds" {
  destroy_duration = "60s"
}

data "google_compute_default_service_account" "default" {
  project = var.project_id
}