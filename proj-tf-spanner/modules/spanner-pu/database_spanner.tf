resource "google_spanner_database" "database" {
  instance = google_spanner_instance.main.name
  depends_on = [google_spanner_instance.main]
  name     = var.spanner_dbname
  # you can define DDL as well
  ddl = [
    "CREATE TABLE t1 (t1 INT64 NOT NULL,) PRIMARY KEY(t1)",
    "CREATE TABLE t2 (t2 INT64 NOT NULL,) PRIMARY KEY(t2)",
  ]
  deletion_protection = true
}