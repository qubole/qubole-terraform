/*
Authorizes a Service Account with
 1. Cloud SQL Client Role

 This is for the following reason:
 1. The Cloud SQL Proxy process uses the service account credentials to connect to the Cloud SQL Instance
 2. This role ensures that the Cloud SQL Proxy process can generate credentials for the connection
*/

resource "google_project_iam_binding" "auth_cloud_sql_client_to_cloud_sql_proxy_sa" {
  project = var.data_lake_project
  role = "roles/cloudsql.client"

  members = [
    "serviceAccount:${google_service_account.cloud_sql_proxy_service_acc.email}",
  ]
}
