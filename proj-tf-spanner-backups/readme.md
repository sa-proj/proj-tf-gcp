<br />
<p align="center">
  <h2 align="center">Automated Backups for Cloud Spanner</h2>
  <img alt="Autoscaler" src="proj-tf-spanner-backups/resources/spanner-backup-architecture.jpg">
</p>

## Overview

1. Cloud Scheduler: will trigger tasks with a cron-based schedule. The schedule can be customised in tfvars file.
2. Cloud Pub/Sub: a message queue from Cloud Scheduler to Cloud Functions.
3. Cloud Functions: will create a Cloud Spanner backup.
3. Service Account: backup-sa service account will grant cloud function permissions to run the spanner backup.