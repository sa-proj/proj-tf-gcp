//Service Accounts

resource "google_service_account" "metric_exporter_sa" {
  account_id   = "metric-exporter-sa"
  display_name = "Spanner Metrics Exporter Service Account"
}

resource "google_project_iam_member" "metric_exporter_sa_iam_sp_vw" {
  project = var.gcp_project_id
  role    = "roles/spanner.viewer"

  member = "serviceAccount:${google_service_account.metric_exporter_sa.email}"
  depends_on = [google_service_account.metric_exporter_sa]
}

resource "google_project_iam_member" "metric_exporter_sa_iam_bq_ed" {
  project = var.gcp_project_id
  role    = "roles/bigquery.dataEditor"

  member = "serviceAccount:${google_service_account.metric_exporter_sa.email}"
  depends_on = [google_service_account.metric_exporter_sa]
}

resource "google_project_iam_member" "metric_exporter_sa_iam_bq_view" {
  project = var.gcp_project_id
  role    = "roles/monitoring.viewer"

  member = "serviceAccount:${google_service_account.metric_exporter_sa.email}"
  depends_on = [google_service_account.metric_exporter_sa]
}

resource "google_project_iam_member" "metric_exporter_sa_iam_bq_usr" {
  project = var.gcp_project_id
  role    = "roles/bigquery.jobUser"

  member = "serviceAccount:${google_service_account.metric_exporter_sa.email}"
  depends_on = [google_service_account.metric_exporter_sa]
}

// BigQuery Schema

resource "google_bigquery_table" "spanner_mql_metrics_table" {
  dataset_id = var.bq_dataset_name
  table_id   = "spanner_mql_metrics"

  schema = <<EOF
[
  {
    "name": "metricName",
    "mode": "REQUIRED",
    "type": "STRING"
  },
  {
    "name": "timeSeriesDescriptor",
    "type": "RECORD",
    "mode": "REQUIRED",
    "fields": [
      {
        "name": "labels",
        "type": "RECORD",
        "mode": "REPEATED",
        "fields": [
          {
            "name": "key",
            "type": "STRING",
            "mode": "NULLABLE"
          },
          {
            "name": "value",
            "type": "STRING",
            "mode": "NULLABLE"
          }
        ]
      },
      {
        "name": "pointDescriptors",
        "type": "RECORD",
        "mode": "REPEATED",
        "fields": [
          {
            "name": "key",
            "type": "STRING",
            "mode": "NULLABLE"
          },
          {
            "name": "value",
            "type": "STRING",
            "mode": "NULLABLE"
          }
        ]
      }
    ]
  },
  {
    "name": "pointData",
    "type": "RECORD",
    "mode": "REQUIRED",
    "fields": [
      {
        "name": "timeInterval",
        "type": "RECORD",
        "mode": "REQUIRED",
        "fields": [
          {
            "name": "start_time",
            "type": "TIMESTAMP",
            "mode": "NULLABLE"
          },
          {
            "name": "end_time",
            "type": "TIMESTAMP",
            "mode": "REQUIRED"
          }
        ]
      },
      {
        "name": "values",
        "type": "RECORD",
        "mode": "REQUIRED",
        "fields": [
          {
            "name": "boolean_value",
            "type": "BOOLEAN",
            "mode": "NULLABLE"
          },
          {
            "name": "int64_value",
            "type": "INTEGER",
            "mode": "NULLABLE"
          },
          {
            "name": "double_value",
            "type": "FLOAT",
            "mode": "NULLABLE"
          },
          {
            "name": "string_value",
            "type": "STRING",
            "mode": "NULLABLE"
          },
          {
            "name": "distribution_value",
            "type": "RECORD",
            "mode": "NULLABLE",
            "fields": [
              {
                "mode": "NULLABLE",
                "name": "count",
                "type": "INTEGER"
              },
              {
                "mode": "NULLABLE",
                "name": "mean",
                "type": "NUMERIC"
              },
              {
                "mode": "NULLABLE",
                "name": "sumOfSquaredDeviation",
                "type": "NUMERIC"
              },
              {
                "mode": "NULLABLE",
                "name": "range",
                "type": "RECORD",
                "fields": [
                  {
                    "mode": "NULLABLE",
                    "name": "min",
                    "type": "NUMERIC"
                  },
                  {
                    "mode": "NULLABLE",
                    "name": "max",
                    "type": "NUMERIC"
                  }
                ]
              },
              {
                "mode": "NULLABLE",
                "name": "bucketOptions",
                "type": "RECORD",
                "fields": [
                  {
                    "mode": "NULLABLE",
                    "name": "linearBuckets",
                    "type": "RECORD",
                    "fields": [
                      {
                        "mode": "NULLABLE",
                        "name": "numFiniteBuckets",
                        "type": "NUMERIC"
                      },
                      {
                        "mode": "NULLABLE",
                        "name": "width",
                        "type": "NUMERIC"
                      },
                      {
                        "mode": "NULLABLE",
                        "name": "offset",
                        "type": "NUMERIC"
                      }
                    ]
                  },
                  {
                    "mode": "NULLABLE",
                    "name": "exponentialBuckets",
                    "type": "RECORD",
                    "fields": [
                      {
                        "mode": "NULLABLE",
                        "name": "numFiniteBuckets",
                        "type": "NUMERIC"
                      },
                      {
                        "mode": "NULLABLE",
                        "name": "growthFactor",
                        "type": "NUMERIC"
                      },
                      {
                        "mode": "NULLABLE",
                        "name": "scale",
                        "type": "NUMERIC"
                      }
                    ]
                  },
                  {
                    "mode": "NULLABLE",
                    "name": "explicitBuckets",
                    "type": "RECORD",
                    "fields": [
                      {
                        "mode": "NULLABLE",
                        "name": "bounds",
                        "type": "RECORD",
                        "fields": [
                          {
                            "mode": "REPEATED",
                            "name": "value",
                            "type": "NUMERIC"
                          }
                        ]
                      }
                    ]
                  }
                ]
              },
              {
                "mode": "NULLABLE",
                "name": "bucketCounts",
                "type": "RECORD",
                "fields": [
                  {
                    "mode": "REPEATED",
                    "name": "value",
                    "type": "INTEGER"
                  }
                ]
              },
              {
                "mode": "NULLABLE",
                "name": "exemplars",
                "type": "RECORD",
                "fields": [
                  {
                    "mode": "NULLABLE",
                    "name": "value",
                    "type": "NUMERIC"
                  },
                  {
                    "mode": "NULLABLE",
                    "name": "timestamp",
                    "type": "STRING"
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
]
EOF

}

// PubSub

resource "google_pubsub_topic" "metric_export_topic" {
  project = var.gcp_project_id
  name = var.pubsub_topic
}

resource "google_pubsub_topic_iam_member" "metric_export_sa_pubsub_sub_iam" {
  project = var.gcp_project_id
  topic   = google_pubsub_topic.metric_export_topic.name
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.metric_exporter_sa.email}"
  depends_on = [google_service_account.metric_exporter_sa]
}

//Scheduler

resource "google_cloud_scheduler_job" "metric_export_job" {
  region      = var.region
  project     = var.gcp_project_id
  name        = "metric-export-job"
  description = "Export Metrics Scheduler"
  schedule    = var.schedule
  time_zone   = var.time_zone

  pubsub_target {
    topic_name = google_pubsub_topic.metric_export_topic.id
    data       = base64encode("Exporting metric...")
  }
  depends_on = [google_pubsub_topic.metric_export_topic]
}


//Cloud Function

resource "local_file" "config" {
    content     = <<EOF
PROJECT_ID = "${var.gcp_project_id}"
PUBSUB_TOPIC = "${var.pubsub_topic}"
BIGQUERY_DATASET = "${var.bq_dataset_name}"
BIGQUERY_TABLE = "spanner_mql_metrics"


MQL_QUERYS = {
"spanner/instance/cpu/smoothed_utilization":
"""
fetch spanner_instance
| metric 'spanner.googleapis.com/instance/cpu/smoothed_utilization'
| filter
    resource.project_id == '${var.gcp_project_id}'
    && (resource.instance_id == '${var.spanner_instance_id}')
| group_by 1m,
    [value_smoothed_utilization_mean: mean(value.smoothed_utilization)]
| every 5m | within 1h
""",

"spanner/instance/cpu/utilization_by_priority":
"""
fetch spanner_instance
| metric 'spanner.googleapis.com/instance/cpu/utilization_by_priority'
| filter
    resource.project_id == '${var.gcp_project_id}'
    && (resource.instance_id == '${var.spanner_instance_id}') && (metric.priority == 'high')
| group_by 1m,
    [value_utilization_by_priority_mean: mean(value.utilization_by_priority)]
| every 1m
| group_by [resource.instance_id, metric.priority],
    [value_utilization_by_priority_mean_aggregate:
       aggregate(value_utilization_by_priority_mean)]
""",

"spanner/instance/storage/used_bytes":
"""
fetch spanner_instance
| metric 'spanner.googleapis.com/instance/storage/used_bytes'
| filter
    resource.project_id == '${var.gcp_project_id}'
    && (resource.instance_id == '${var.spanner_instance_id}')
| group_by 10m,
    [value_used_bytes_max: max(value.used_bytes)]
| every 5m | within 1h
""",

"spanner/instance/error_count":
"""
fetch spanner_instance
| metric 'spanner.googleapis.com/api/api_request_count'
| filter
    resource.project_id == '${var.gcp_project_id}'
    && (resource.instance_id == '${var.spanner_instance_id}') && (metric.status != 'OK')
| align rate(1m)
| every 1m
| group_by [],
    [value_api_request_count_aggregate: aggregate(value.api_request_count)]
"""
}

BASE_URL = "https://monitoring.googleapis.com/v3/projects"
QUERY_URL = f"{BASE_URL}/{PROJECT_ID}/timeSeries:query"


BQ_VALUE_MAP = {
    "INT64": "int64_value",
    "BOOL": "boolean_value",
    "DOUBLE": "double_value",
    "STRING": "string_value",
    "DISTRIBUTION": "distribution_value"
}

API_VALUE_MAP = {
    "INT64": "int64Value",
    "BOOL": "booleanValue",
    "DOUBLE": "doubleValue",
    "STRING": "stringValue",
    "DISTRIBUTION": "distributionValue"
}
EOF
    filename = "${abspath("${path.module}/../../mql-exporter-function/config.py")}"
}

resource "google_storage_bucket" "bucket_gcf_source" {
  name          = "${var.gcp_project_id}-gcp-me-source"
  storage_class = "REGIONAL"
  location      = var.region
  force_destroy = "true"
  uniform_bucket_level_access = var.uniform_bucket_level_access
}

data "archive_file" "local_source" {
  type        = "zip"
  source_dir  = "${abspath("${path.module}/../../mql-exporter-function")}"
  output_path = "${var.local_output_path}/mql-exporter-function.zip"
  depends_on = [local_file.config]
}

resource "google_storage_bucket_object" "gcs_cloudfunction_source" {
  name   = "backup.${data.archive_file.local_source.output_md5}.zip"
  bucket = google_storage_bucket.bucket_gcf_source.name
  source = data.archive_file.local_source.output_path
}

resource "google_cloudfunctions_function" "mql_export_metrics_function" {
  name = "mql_export_metrics"
  project = var.gcp_project_id
  region = var.region
  available_memory_mb = "256"
  entry_point = "export_metric_data"
  runtime = "python38"
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.metric_export_topic.id
  }
  source_archive_bucket = google_storage_bucket.bucket_gcf_source.name
  source_archive_object = google_storage_bucket_object.gcs_cloudfunction_source.name
  service_account_email = google_service_account.metric_exporter_sa.email
  depends_on = [google_pubsub_topic.metric_export_topic]
}

