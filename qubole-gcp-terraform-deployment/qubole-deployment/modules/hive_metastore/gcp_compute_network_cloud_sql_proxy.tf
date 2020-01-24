/* Creates a VPC designated to host the Cloud SQL Proxy Process

 This is for the following reason:
 1. This VPC will be Private IP peered with the Cloud SQL instance for security reasons
 2. This VPC will be able to use Private IP peering

 Cloud SQL Proxy is required in a scalable architecture. Please see Connecting from External Applications: https://cloud.google.com/sql/docs/mysql/external-connection-methods
*/

resource "google_compute_network" "cloud_sql_proxy_vpc" {
  name = "cloud-sql-proxy-vpc"
  project = var.data_lake_project
  auto_create_subnetworks = false
}
