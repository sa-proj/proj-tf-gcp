output "spanner_details" {
    value = "instance_name.database_name --> ${module.spanner.spanner_instance}.${module.spanner.spanner_database}"
}