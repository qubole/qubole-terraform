/*
Creates a Static Global IP address range for
 1. The Cloud SQL Instance to use when peering with the Cloud SQL Proxy VPC

 This is for the following reason:
 1. When Service Peering, the service creates a new project, VPC and subnetwork. The IP range for the subnetwork is this Global IP address range
 2. Allocating an address range ensures that there are no IP range conflicts between the service providers network and service consumers network
*/

resource "google_compute_global_address" "cloudsql_int_address_range" {
    name = "cloudsql-int-address-range"
    project = var.data_lake_project
    #region = var.data_lake_project_region
    network = google_compute_network.cloud_sql_proxy_vpc.self_link
    purpose = "VPC_PEERING"
    address_type = "INTERNAL"
    prefix_length = 24
    description = "Dedicated address range for PrivateIP connections to and from Qubole VPC"
}
