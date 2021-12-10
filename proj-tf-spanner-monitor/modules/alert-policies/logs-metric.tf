resource "google_logging_metric" "spanner_log_metrics" {
  project = var.gcp_project_id
  name = "spanner-error-count"
  filter = "resource.type=\"spanner_instance\" AND resource.labels.instance_id=\"${var.spanner_instance_id}\" AND severity=(EMERGENCY OR ALERT OR CRITICAL OR ERROR OR WARNING)"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

//Log Metrics for Backup Scheduler and Cloud function for spanner backups. Only Use this section in case you have a backup automation for spanner created
/*
resource "google_logging_metric" "spanner_backup_scheduler_log_metrics" {
  project = var.gcp_project_id
  name = "backup-cloud-scheduler-errors"
  filter = "resource.type=\"cloud_scheduler_job\" AND severity>=WARNING AND jsonPayload.jobName:\"jobs/spanner-backup-job\""
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_logging_metric" "spanner_backup_function_log_metrics" {
  project = var.gcp_project_id
  name = "backup-cloud-function-errors"
  filter = "resource.type=\"cloud_function\" AND resource.labels.function_name=\"SpannerCreateBackup\" AND \"Function error\""
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}


resource "google_logging_metric" "spanner_backup_log_metrics" {
  project = var.gcp_project_id
  name = "backup-cloud-spanner-errors"
  filter = "resource.type=\"spanner_instance\" AND severity >= ERROR AND protoPayload.methodName=\"google.spanner.admin.database.v1.DatabaseAdmin.CreateBackup\" AND protoPayload.resourceName:\"backups/schedule-\""
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}
*/