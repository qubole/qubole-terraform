/*
Creates a Service Account that
 1. will be attached to the GCE/GKE hosting the Cloud SQL Proxy
 2. will provide the Cloud SQL Proxy service with credentials to connect to the Cloud SQL instance hosting the Hive Metastore

 This is for the following reason:
 1. The Cloud SQL Proxy service uses the credentials of the service account associated with its host(GCE/GKE) to connect to the Cloud SQL instance
 2. Using the Service Account is a clean and safe way to restrict the credentials to this one process
*/

resource "google_service_account" "cloud_sql_proxy_service_acc" {
  project = var.data_lake_project
  account_id = var.cloud_sql_proxy_service_acc_id
  display_name = var.cloud_sql_proxy_service_acc_name
}
