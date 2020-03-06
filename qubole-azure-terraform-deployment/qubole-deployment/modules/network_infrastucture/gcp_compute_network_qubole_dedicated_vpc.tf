/*
Creates a VPC that will be dedicated to use by Qubole.
*/

resource "google_compute_network" "qubole_dedicated_vpc" {
  name = "qubole-dedicated-vpc"
  project = var.data_lake_project
  auto_create_subnetworks = false
}

output "qubole_dedicated_vpc_link" {
  value = google_compute_network.qubole_dedicated_vpc.self_link
}