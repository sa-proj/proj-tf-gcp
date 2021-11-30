variable "project_id" {
  type   = string
}

variable "location" {
  type    = string
  default = "us-central"
}

variable "schedule" {
  type    = string
  default = "*/2 * * * *"
}

variable "time_zone" {
  type    = string
  default = "America/Los_Angeles"
}

variable "pubsub_topic" {
  type    = string
}

variable "pubsub_data" {
  type    = string
}
