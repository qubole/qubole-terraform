/*
Creates a SubNetwork in the Qubole Dedicated VPC.
 1. This will be the notional public subnetwork in which a Bastion Host will reside

 This is for the following reason:
 1. The Bastion host is the secure gateway through which Qubole will talk to the clusters running in the customer's project/network
*/

resource "google_compute_subnetwork" "qubole_vpc_public_subnetwork" {
  name = "qubole-vpc-public-subnetwork"
  project = var.data_lake_project
  ip_cidr_range = "10.2.0.0/24"
  region = var.data_lake_project_region
  network = google_compute_network.qubole_dedicated_vpc.self_link
  private_ip_google_access = true
}
