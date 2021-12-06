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
  project = var.gcp_project_id
  name = var.pubsub_topic
}

resource "google_pubsub_topic_iam_member" "backup_sa_pubsub_sub_iam" {
  project = var.gcp_project_id
  topic   = google_pubsub_topic.backup_topic.name
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.backup_sa.email}"
}

//Scheduler

resource "google_cloud_scheduler_job" "backup_job" {
  region      = var.region
  project     = var.gcp_project_id
  name        = "backup-spanner-instance-schedule"
  description = "Backup job for main-instance"
  schedule    = var.schedule
  time_zone   = var.time_zone

  pubsub_target {
    topic_name = google_pubsub_topic.backup_topic.id
    data       = var.pubsub_data
  }
  depends_on = [google_pubsub_topic.backup_topic]
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
  name = "SpannerCreateBackup"
  project = var.gcp_project_id
  region = var.region
  available_memory_mb = "256"
  entry_point = "SpannerCreateBackup"
  runtime = "go113"
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.backup_topic.id
  }
  source_archive_bucket = google_storage_bucket.bucket_gcf_source.name
  source_archive_object = google_storage_bucket_object.gcs_functions_backup_source.name
  service_account_email = google_service_account.backup_sa.email
  depends_on = [google_pubsub_topic.backup_topic]
}

