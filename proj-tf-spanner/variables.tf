variable "gcp_project_id" {}
variable "spanner_instance_id" {}
variable "spanner_config" {}
variable "spanner_labels" {}
variable "spanner_dbname" {}
variable "spanner_num_nodes" {}
variable "creds_file" {
  type = string
  default = "key.json"
}
# variable "spanner_processing_units" {}