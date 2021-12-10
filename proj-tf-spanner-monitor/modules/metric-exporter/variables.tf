variable "gcp_project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "uniform_bucket_level_access" {
  type = bool
  default = false
}

variable "schedule" {
  type    = string
  default = "*/5 * * * *"
  //Every 5 Mins
}

variable "time_zone" {
  type    = string
  default = "Europe/Brussels"
}

variable "pubsub_topic" {
  type    = string
}

variable "local_output_path" {
  type    = string
  default = "build"
}

variable "bq_dataset_name" {
  type = string
}
variable "spanner_instance_id" {
  type = string
}