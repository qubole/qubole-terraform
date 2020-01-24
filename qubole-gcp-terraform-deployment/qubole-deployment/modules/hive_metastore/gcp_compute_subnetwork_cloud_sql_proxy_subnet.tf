/*
Creates a SubNetwork in the VPC designated to host the Cloud SQL Proxy Process

 This is for the following reason:
 1. This VPC will be Private IP peered with the Cloud SQL instance for security reasons
*/

resource "google_compute_subnetwork" "cloud_sql_proxy_private_subnetwork" {
  name = "cloud-sql-proxy-private-subnetwork"
  project = var.data_lake_project
  ip_cidr_range = "10.174.0.0/20"
  region = var.data_lake_project_region
  network = google_compute_network.cloud_sql_proxy_vpc.self_link
  private_ip_google_access = true
}
