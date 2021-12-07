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
variable "spanner_database_id" {
  type = string
}
variable "region" {
  type = string
}
variable "backups_topic_name" {
  type = string
  default = "cloud-spanner-scheduled-backups"
}
variable "schedule" {
  type    = string
  default = "0 * * * *"
  //Every Hour
}
