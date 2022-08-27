variable "gcp_project_id" {}
variable "spanner_instance_id" {}
variable "spanner_config" {}
variable "spanner_labels" {}
variable "spanner_dbname" {}
variable "spanner_num_nodes" {}
# variable "spanner_processing_units" {}
variable "creds_file" {
  type = string
}
variable "spanner_db_deletion_protection"{
    type    = bool
    default = true
}