output "poller_topic" {
  value       = google_pubsub_topic.poller_topic.id
  description = "PubSub topic used by the poller function"
}

output "poller_sa_email" {
  value       = google_service_account.poller_sa.email
  description = "Email of the poller service account"
}

output "scaler_topic" {
  value       = google_pubsub_topic.scaler_topic.id
  description = "PubSub topic used by the scaler function"
}

output "scaler_sa_email" {
  value       = google_service_account.scaler_sa.email
  description = "Email of the scaler service account"
}