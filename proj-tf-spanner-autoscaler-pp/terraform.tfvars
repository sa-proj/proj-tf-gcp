spanner_instance_id = "sample-instance"
spanner_dbname      = "sample-db"
# You can change the instance configuration here. For list of available instance types, check visit documentation :https://cloud.google.com/spanner/docs/instances 
spanner_config      = "regional-us-central1"
spanner_num_nodes   = 2
# spanner_processing_units = 1000
spanner_labels      = { env = "development", owner = "arora"}
project_id          = "YOUR_PROJECT_ID"
spanner_db_deletion_protection = false