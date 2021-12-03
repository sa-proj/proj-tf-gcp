resource "google_logging_metric" "spanner_log_metrics" {
  project = var.gcp_project_id
  name = "spanner_error_count"
  filter = "resource.type=\"spanner_instance\" AND resource.labels.instance_id=\"${var.spanner_instance_id}\" AND severity=(EMERGENCY OR ALERT OR CRITICAL OR ERROR OR WARNING)"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

