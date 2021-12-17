module "scheduler" {
  source  = "./modules/backup-scheduler"

  gcp_project_id   = var.gcp_project_id
  spanner_instance_id = var.spanner_instance_id
  database_ids = var.spanner_database_ids
  region = var.region
  pubsub_topic = var.backups_topic_name
  schedule = var.schedule
  location = var.location
}