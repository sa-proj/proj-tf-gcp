resource "google_spanner_instance_iam_member" "spanner_metadata_get_iam" {
  instance = var.spanner_instance_id
  role     = "roles/spanner.viewer"
  project  = var.gcp_project_id
  member   = "serviceAccount:${var.poller_sa_email}"

  depends_on = [google_spanner_instance.main]
}

resource "google_spanner_instance_iam_member" "spanner_admin_iam" {
  # Allows scaler to change the number of nodes of the Spanner instance
  instance = var.spanner_instance_id
  role     = "roles/spanner.admin"
  project  = var.gcp_project_id
  member   = "serviceAccount:${var.scaler_sa_email}"

  depends_on = [google_spanner_instance.main]
}

resource "google_project_iam_member" "poller_sa_cloud_monitoring" {
  # Allows poller to get Spanner metrics
  role    = "roles/monitoring.viewer"
  project = var.gcp_project_id
  member  = "serviceAccount:${var.poller_sa_email}"
}