/*
Creates a SubNetwork in the Qubole Dedicated VPC.
 1. This will be the notional private subnetwork in which Qubole will launch clusters without External IP

 This is for the following reason:
 1. Not having internet access can be an important security requirment
*/

resource "google_compute_subnetwork" "qubole_vpc_private_subnetwork" {
  name = "qubole-vpc-private-subnetwork"
  project = var.data_lake_project
  ip_cidr_range = "10.3.0.0/24"
  region = var.data_lake_project_region
  network = google_compute_network.qubole_dedicated_vpc.self_link
  private_ip_google_access = true
}

output "qubole_vpc_private_subnetwork_cidr" {
  value = google_compute_subnetwork.qubole_vpc_private_subnetwork.ip_cidr_range
}
