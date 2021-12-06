module "scheduler" {
  source  = "./modules/backup-scheduler"

  gcp_project_id   = var.gcp_project_id
  region = var.region
  location = var.location
  pubsub_topic = var.backups_topic_name
  pubsub_data  = base64encode("{\"Database\":\"projects/${var.gcp_project_id}/instances/${var.spanner_instance_id}/databases/${var.spanner_database_id}\", \"Expire\": \"6h\"}")
  schedule = var.schedule
}