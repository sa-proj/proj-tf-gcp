//Enter your project ID
gcp_project_id  = "qwiklabs-gcp-01-0c652447f61f"
//Enter Spanner Instance ID where you database is located that you want to backup
spanner_instance_id = "spanner-1"
//Enter Spanner Database name you want to backup
spanner_database_id = "sample"
//Enter the GCP region name
region = "us-central1"
//Enter the schedule on which you want to call the cloud scheudler job. The below is set to run every 1 hour
schedule = "0 * * * *"
