variable "gcp_project_id" {}
variable "spanner_instance_id" {}
variable "spanner_config" {}
variable "spanner_labels" {}
variable "spanner_processing_units" {}
variable "spanner_dbname" {}
variable "deletion_protection"{
    type    = bool
    default = true
}
variable "poller_sa_email" {}
variable "scaler_sa_email" {}