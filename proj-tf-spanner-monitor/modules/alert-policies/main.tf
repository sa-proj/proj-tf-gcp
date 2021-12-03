locals {
  email0_id = var.email0
  email1_id = var.email1
}

resource "google_monitoring_alert_policy" "spanner-cpu-by-priority" {
  display_name = "1 - Performance - Cloud Spanner - CPU Utilization by Priority - [${upper(var.spanner_instance_id)}]"
  combiner = "OR"
  conditions {
    display_name = "Google Cloud Spanner - CPU Utilization by Priority (filtered) [SUM]"
    condition_threshold {
      filter = "metric.type=\"spanner.googleapis.com/instance/cpu/utilization_by_priority\" AND resource.type=\"spanner_instance\" AND resource.labels.instance_id=\"${var.spanner_instance_id}\" AND resource.labels.project_id=\"${var.gcp_project_id}\" AND metric.labels.priority=\"high\"" 
      duration = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = var.cpu_threshold_priority
      trigger {
          percent = 100
      }
      aggregations {
        alignment_period = "60s"
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }
  documentation {
    content = "The CPU Utilization by Priority for Spanner Instance - [${upper(var.spanner_instance_id)}] has breached it's recommended threshold value of ${var.cpu_threshold_priority * 100}%. The metric included in the alert represents CPU % used for high-priority tasks. Includes both user-initiated tasks (e.g., reads/writes) and system-initiated tasks (e.g., index verification). Check https://cloud.google.com/spanner/docs/cpu-utilization?_ga=2.153331896.-128396860.1638532517#metrics for tips on reducing CPU Utilization."
  }
  notification_channels = [
      "${local.email0_id}",
      "${local.email1_id}",
  ]
}

resource "google_monitoring_alert_policy" "spanner-cpu-smoothed" {
  display_name = "2 - Performance - Cloud Spanner - Smoothed CPU utilization - [${upper(var.spanner_instance_id)}]"
  combiner = "OR"
  conditions {
    display_name = "Google Cloud Spanner - Smoothed CPU utilization (filtered) (grouped) [SUM]"
    condition_threshold {
      filter = "metric.type=\"spanner.googleapis.com/instance/cpu/smoothed_utilization\" AND resource.type=\"spanner_instance\" AND resource.labels.instance_id=\"${var.spanner_instance_id}\" AND resource.labels.project_id=\"${var.gcp_project_id}\"" 
      duration = "600s"
      comparison = "COMPARISON_GT"
      threshold_value = var.cpu_threshold
      trigger {
          percent = 100
      }
      aggregations {
        alignment_period = "60s"
        group_by_fields = ["metric.database"]
        per_series_aligner = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }
  documentation {
    content = "The Smoothed CPU utilization for Spanner Instance - [${upper(var.spanner_instance_id)}] has breached it's recommended threshold value of ${var.cpu_threshold * 100}%. The metric represents a rolling average of total CPU utilization, as a percentage of the instance's CPU resources, for each database. Each data point is an average for the previous 24 hours. Check https://cloud.google.com/spanner/docs/cpu-utilization?_ga=2.153331896.-128396860.1638532517#metrics for tips on reducing CPU Utilization."
  }
  notification_channels = [
      "${local.email0_id}",
      "${local.email1_id}",
  ]
}

resource "google_monitoring_alert_policy" "storage-used" {
  display_name = "3 - Reliability - Cloud Spanner - Storage Used - [${upper(var.spanner_instance_id)}]"
  combiner = "OR"
  conditions {
    display_name = "Google Cloud Spanner - Storage Used (filtered) (grouped) [SUM]"
    condition_threshold {
      filter = "metric.type=\"spanner.googleapis.com/instance/storage/used_bytes\" AND resource.type=\"spanner_instance\" AND resource.labels.instance_id=\"${var.spanner_instance_id}\" AND resource.labels.project_id=\"${var.gcp_project_id}\"" 
      duration = "600s"
      comparison = "COMPARISON_GT"
      threshold_value = var.storage_threshold * 1024 * 1024 * 1024
      aggregations {
        alignment_period = "600s"
        group_by_fields = ["resource.instance_id"]
        per_series_aligner = "ALIGN_MAX"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }
  documentation {
    content = "The Storage Used for Spanner Instance - [${upper(var.spanner_instance_id)}] has breached it's recommended threshold value of ${var.storage_threshold} GB. Check https://cloud.google.com/spanner/docs/storage-utilization#reduce for tips on reducing Storage Utilization or Check https://cloud.google.com/spanner/docs/storage-utilization#recommended-max for tips on managing Storage Utilization."
  }
  notification_channels = [
      "${local.email0_id}",
      "${local.email1_id}",
  ]
}

resource "google_monitoring_alert_policy" "errors" {
  display_name = "4 - Reliability - Cloud Spanner - Custom Error Count - [${upper(var.spanner_instance_id)}]"
  combiner     = "OR"
  conditions {
    display_name = "Cloud Spanner - Custom Error Count - [COUNT]"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/spanner_error_count\" AND resource.type=\"spanner_instance\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 1
      aggregations {
        alignment_period = "60s"
        per_series_aligner = "ALIGN_COUNT"
        cross_series_reducer = "REDUCE_COUNT"
      }
    }    
  }
  documentation {
    content = "The Count of Errors on Spanner Instance - [${upper(var.spanner_instance_id)}] has breached it's threshold value of 1 Error(s). Navigate to https://console.cloud.google.com/logs/query;query=resource.type%3D%22spanner_instance%22%20resource.labels.instance_id%3D%22${var.spanner_instance_id}%22%0Aseverity%3D%2528EMERGENCY%20OR%20ALERT%20OR%20CRITICAL%20OR%20ERROR%20OR%20WARNING%2529;project=${var.gcp_project_id}&query=%0A for exact errors logged in the logs explorer."
  }
  notification_channels = [
      "${local.email0_id}",
      "${local.email1_id}",
  ]
}

resource "google_monitoring_alert_policy" "ops-errors" {
  display_name = "5 - Reliability - Cloud Spanner - API Request Errors - [${upper(var.spanner_instance_id)}]"
  combiner     = "OR"
  conditions {
    display_name = "Cloud Spanner - API Request Errors - [RATE]"
    condition_threshold {
      filter     = "metric.type=\"spanner.googleapis.com/api/api_request_count\" AND resource.type=\"spanner_instance\" AND metric.labels.status!=\"OK\" AND resource.labels.instance_id=\"${var.spanner_instance_id}\" AND resource.labels.project_id=\"${var.gcp_project_id}\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 0.01
      aggregations {
        alignment_period = "60s"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }    
  }
  documentation {
    content = "The errors receieved for operations per second on Spanner Instance - [${upper(var.spanner_instance_id)}] has breached it's threshold."
  }
  notification_channels = [
      "${local.email0_id}",
      "${local.email1_id}",
  ]
}