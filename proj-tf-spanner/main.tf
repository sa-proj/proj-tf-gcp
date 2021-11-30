module "spanner" {
  source = "./modules/spanner-nn"

gcp_project_id = var.gcp_project_id
spanner_instance_id = var.spanner_instance_id
spanner_num_nodes = var.spanner_num_nodes
spanner_config = var.spanner_config
spanner_labels = var.spanner_labels
spanner_dbname = var.spanner_dbname
deletion_protection = var.spanner_db_deletion_protection
}