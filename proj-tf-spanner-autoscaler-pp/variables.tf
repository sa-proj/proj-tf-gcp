variable "project_id" {
  type = string
}

variable "creds_file" {
  type = string
  default = "key.json"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "spanner_instance_id" {
  type = string
}

variable "spanner_config" {
  type = string
}

variable "spanner_labels" {
  type = map(string)
}

variable "spanner_dbname" {
  type = string
}

variable "spanner_num_nodes" {
  type = number
}

# variable "spanner_processing_units" {}

variable "spanner_db_deletion_protection"{
    type    = bool
    default = true
}