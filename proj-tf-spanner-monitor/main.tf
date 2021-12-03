module "notification-channels" {
  source = "./modules/notification-channels"
  
  email0 = var.notify_email0
  email1 = var.notify_email1
}

module "alert-policies" {
  source = "./modules/alert-policies"
  
  email0 = module.notification-channels.email0_id
  email1 = module.notification-channels.email1_id
  spanner_instance_id   = var.spanner_instance_id
  gcp_project_id = var.gcp_project_id
  storage_threshold = var.spanner_storage_threshold
} 