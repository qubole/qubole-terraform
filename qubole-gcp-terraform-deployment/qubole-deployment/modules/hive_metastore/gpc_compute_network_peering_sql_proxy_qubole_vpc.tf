/*
Creates a two way VPC peering between
 1. The Qubole Dedicated VPC
 2. The Cloud SQL Proxy Dedicated VPC

 This is for the reason:
 1. Qubole can access the cloud SQL instance hosting the Hive Metastore in a secure and scalable fashion
*/


resource "google_compute_network_peering" "peer_cloudsql_proxy_qubole_vpc" {
  name = "peer-cloudsql-proxy-qubole-vpc"
  network = google_compute_network.cloud_sql_proxy_vpc.self_link
  peer_network = var.qubole_dedicated_vpc
}

resource "google_compute_network_peering" "peer_qubole_vpc_cloudsql_proxy" {
  name = "peer-qubole-vpc-cloudsql-proxy"
  network = var.qubole_dedicated_vpc
  peer_network = google_compute_network.cloud_sql_proxy_vpc.self_link
  depends_on = [
    google_compute_network_peering.peer_cloudsql_proxy_qubole_vpc
  ]
}
