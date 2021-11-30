resource "google_app_engine_application" "app" {
  project     = var.project_id
  location_id = var.location
}

resource "google_cloud_scheduler_job" "poller_job" {
  name        = "poll-main-instance-metrics"
  description = "Poll metrics for main-instance"
  schedule    = var.schedule
  time_zone   = var.time_zone

  pubsub_target {
    topic_name = var.pubsub_topic
    data       = var.pubsub_data
  }

  depends_on = [google_app_engine_application.app]
}
