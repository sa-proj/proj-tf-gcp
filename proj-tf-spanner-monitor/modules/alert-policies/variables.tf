variable "email0" {
  type = string
}
variable "email1" {
  type = string
}
variable "spanner_instance_id" {
  type = string
}
variable "gcp_project_id" {
  type = string
}
variable "cpu_threshold_priority" {
  type = number 
  default = 0.65
  #Maximum for single-region instances	- 0.65
  #Maximum per region for multi-region instances - 0.45
}
variable "cpu_threshold" {
  type = number 
  default = 0.9
  #Maximum for single-region instances	- 0.9
  #Maximum per region for multi-region instances - 0.9
}
variable "storage_threshold" {
  type = number
}