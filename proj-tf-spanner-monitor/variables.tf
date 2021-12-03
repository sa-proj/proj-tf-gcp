variable "gcp_project_id" {
  type = string
}
variable "creds_file" {
  type = string
  default = "key.json"
}
variable "notify_email0" {
  type = string
}
variable "notify_email1" {
  type = string
}
variable "spanner_instance_id" {
  type = string
}
variable "spanner_storage_threshold" {
  type = number
  # In GB
}