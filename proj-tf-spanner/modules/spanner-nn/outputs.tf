output "spanner_instance" {
    value = google_spanner_instance.main.name
}
output "spanner_database" {
    value = google_spanner_database.database.name
}