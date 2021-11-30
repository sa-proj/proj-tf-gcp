resource "google_spanner_instance" "main" {
  name         = var.spanner_instance_id  # << be careful changing this in production
  project      = var.gcp_project_id
  config       = var.spanner_config
  display_name = var.spanner_instance_id
  num_nodes    = var.spanner_num_nodes
  labels = var.spanner_labels
}