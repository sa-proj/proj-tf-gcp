//Service Accounts

resource "google_service_account" "backup_sa" {
  account_id   = "backup-sa"
  display_name = "Spanner Backup Function Service Account"
}

resource "google_project_iam_member" "backup_sa_spanner_iam" {
  project = var.gcp_project_id
  role    = "roles/spanner.backupWriter"

  member = "serviceAccount:${google_service_account.backup_sa.email}"
}

// PubSub

resource "google_pubsub_topic" "backup_topic" {
  for_each = var.database_ids
  project = var.gcp_project_id
  name = "${each.value}-${var.pubsub_topic}"
}

resource "google_pubsub_topic_iam_member" "backup_sa_pubsub_sub_iam" {
  for_each = var.database_ids
  project = var.gcp_project_id
  topic   = "${each.value}-${var.pubsub_topic}"
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.backup_sa.email}"
}

//Scheduler

resource "google_app_engine_application" "app" {
  project     = var.gcp_project_id
  location_id = var.location
}

resource "google_cloud_scheduler_job" "backup_job" {
  for_each    = var.database_ids
  region      = var.region
  project     = var.gcp_project_id
  name        = "${each.value}-spanner-backup-job"
  description = "Backup job for database - ${each.value}"
  schedule    = var.schedule
  time_zone   = var.time_zone
  pubsub_target {
    topic_name = google_pubsub_topic.backup_topic[each.value].id
    data       = base64encode("{\"Database\":\"projects/${var.gcp_project_id}/instances/${var.spanner_instance_id}/databases/${each.value}\", \"Expire\": \"6h\"}")
  }
  depends_on = [google_app_engine_application.app]
}


//Cloud Function

resource "google_storage_bucket" "bucket_gcf_source" {
  name          = "${var.gcp_project_id}-gcp-ssb-source"
  storage_class = "REGIONAL"
  location      = var.region
  force_destroy = "true"
  uniform_bucket_level_access = var.uniform_bucket_level_access
}

data "archive_file" "local_backup_source" {
  type        = "zip"
  source_dir  = "${abspath("${path.module}/../../backup")}"
  output_path = "${var.local_output_path}/backup.zip"
}

resource "google_storage_bucket_object" "gcs_functions_backup_source" {
  name   = "backup.${data.archive_file.local_backup_source.output_md5}.zip"
  bucket = google_storage_bucket.bucket_gcf_source.name
  source = data.archive_file.local_backup_source.output_path
}

resource "google_cloudfunctions_function" "spanner_backup_function" {
  for_each    = var.database_ids
  name        = "${each.value}-SpannerCreateBackup"
  project     = var.gcp_project_id
  region      = var.region
  available_memory_mb = "256"
  entry_point = "SpannerCreateBackup"
  runtime     = "go113"
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.backup_topic[each.value].id
  }
  max_instances = 1
  source_archive_bucket = google_storage_bucket.bucket_gcf_source.name
  source_archive_object = google_storage_bucket_object.gcs_functions_backup_source.name
  service_account_email = google_service_account.backup_sa.email
  depends_on = [google_pubsub_topic.backup_topic]
}

