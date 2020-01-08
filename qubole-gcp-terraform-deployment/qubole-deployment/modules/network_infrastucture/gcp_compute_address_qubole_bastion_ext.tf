/*
Creates a Static External IP address for
 1. The GCE VM being used as the Bastion Host in the Qubole dedicated VPC

 This is for the following reason:
 1. If we use ephemeral IP, everytime the bastion restarts, Qubole configuration - metastore/clusters will have to be updated
*/

resource "google_compute_address" "qubole_bastion_host_external_ip" {
  name = "qubole-bastion-external-ip"
  project = var.data_lake_project
  region = var.data_lake_project_region
}

output "qubole_bastion_external_ip" {
  value = google_compute_address.qubole_bastion_host_external_ip.address
}
