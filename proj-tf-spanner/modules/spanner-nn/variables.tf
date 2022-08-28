variable "gcp_project_id" {}
variable "spanner_instance_id" {}
variable "spanner_config" {}
variable "spanner_labels" {}
variable "spanner_dbname" {}
variable "spanner_num_nodes" {}
variable "deletion_protection"{
    type    = bool
    default = false
}
