variable "gcp_project_id" {
  type = string
}
variable "creds_file" {
  type = string
  default = "key.json"
}
variable "spanner_instance_id" {
  type = string
}
variable "spanner_database_ids" {
  type = set(string)
}
variable "region" {
  type = string
}
variable "backups_topic_name" {
  type = string
  default = "spanner-scheduled-backup-topic"
}
variable "schedule" {
  type    = string
  default = "0 * * * *"
  //Every Hour
}
variable "location" {
  type    = string
}