resource "google_logging_project_sink" "spanner-bq-sink" {
  name = "${var.spanner_instance_id}-db-sink-2-bq"
  project = var.gcp_project_id
  destination = "bigquery.googleapis.com/projects/${var.gcp_project_id}/datasets/${var.bq_dataset_name}"
  filter = "resource.type=\"spanner_instance\" resource.labels.instance_id=\"${var.spanner_instance_id}\" severity=(EMERGENCY OR ALERT OR CRITICAL OR ERROR OR WARNING OR NOTICE OR INFO OR DEBUG OR DEFAULT)"
  unique_writer_identity = true
}
resource "google_project_iam_binding" "log-writer-permissions" {
  project = var.gcp_project_id
  role = "roles/bigquery.dataEditor"

  members = [
    google_logging_project_sink.spanner-bq-sink.writer_identity,
  ]
}