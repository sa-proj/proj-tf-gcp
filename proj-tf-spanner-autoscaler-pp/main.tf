/**
* Per-Project deployment: all the components of the Autoscaler reside in the same project 
* as your Spanner instances. This deployment is ideal for independent teams who want to 
* self manage the configuration and infrastructure of their own Autoscalers.
 */

module "autoscaler" {
  source = "./modules/autoscaler"

  project_id = var.project_id
}

module "spanner" {
  source  = "./modules/spanner-nn"

  gcp_project_id        = var.project_id
  spanner_instance_id   = var.spanner_instance_id
  spanner_config        = var.spanner_config
  spanner_labels        = var.spanner_labels
  spanner_dbname        = var.spanner_dbname
  spanner_num_nodes     = var.spanner_num_nodes
  deletion_protection   = var.spanner_db_deletion_protection
  poller_sa_email   = module.autoscaler.poller_sa_email
  scaler_sa_email   = module.autoscaler.scaler_sa_email
}

module "scheduler" {
  source  = "./modules/scheduler"

  project_id   = var.project_id
  pubsub_topic = module.autoscaler.poller_topic
  pubsub_data  = base64encode(jsonencode([{
    "projectId": "${var.project_id}",
    "instanceId": "${module.spanner.spanner_name}",
    "scalerPubSubTopic": "${module.autoscaler.scaler_topic}",
    "units": "NODES",
    "minSize": 1
    "maxSize": 3,
    "scalingMethod": "LINEAR"
  }]))
}