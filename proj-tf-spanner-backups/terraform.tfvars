//Enter your project ID
gcp_project_id  = "qwiklabs-gcp-00-bad7c3fd7bd4"
//Enter Spanner Instance ID where you database is located that you want to backup
spanner_instance_id = "spanner-1"
//Enter Spanner Database name you want to backup
spanner_database_ids = ["sample1","sample2"]
//Enter the GCP region name
region = "us-central1"
//Enter the location for App Engine
location = "us-central"
//Enter the schedule on which you want to call the cloud scheudler job. The below is set to run every 1 hour
schedule = "0 * * * *"
