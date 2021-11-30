variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "local_output_path" {
  type    = string
  default = "build"
}

variable "forwarder_sa_emails" {
  type    = list(string)
  default = []
}

variable "uniform_bucket_level_access" {
  type = bool
  default = false
}