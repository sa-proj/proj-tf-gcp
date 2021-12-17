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
  default = "0 * * * *"
  //Every Hour
}

variable "time_zone" {
  type    = string
  default = "America/Los_Angeles"
}

variable "pubsub_topic" {
  type    = string
}

variable "local_output_path" {
  type    = string
  default = "build"
}

variable "database_ids" {
  type = set(string)
}

variable "spanner_instance_id" {
  type = string
}

variable "location" {
  type    = string
}
