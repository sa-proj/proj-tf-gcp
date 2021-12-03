resource "google_monitoring_notification_channel" "email0" {
  display_name = "OnCall-Support"
  type = "email"
  labels = {
    email_address = var.email0
  }
}

resource "google_monitoring_notification_channel" "email1" {
  display_name = "Monitoring-DL"
  type = "email"
  labels = {
    email_address = var.email1
  }
}

