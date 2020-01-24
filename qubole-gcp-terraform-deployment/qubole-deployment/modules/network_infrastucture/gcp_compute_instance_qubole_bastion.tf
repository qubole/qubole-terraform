/*
Creates a Google Compute Engine VM that will act as a Bastion Host in the Qubole Dedicated VPC
 Features
 1. A network interface allowing for a Public IP address
 2. A custom start up script to create a user configured with accessibility from Qubole
       - the script should also setup the system to accept Qubole's Public Key and Customer's Account Level SSH key

 This is for the following reason:
 1. Create a secure channel (ssh tunnel forwarding) between the Qubole Control Plane and the Customer's Big Data Clusters
    - This secure channel will be used to submit commands, perform admin tasks and retrieving results
 3. Create a secure channel (ssh tunnel forwarding) between the Qubole Control Plane and the Customer's Hive Metastore
    - This secure channel will be used by the Qubole Control Plane to list the schemas and tables available in the Customer's Hive Metastore
    - This is ONLY for metadata. No customer data will flow via this channel

 Caveats:
 1. The Bastion needs to be configured to accept
    - Qubole's Public SSH Key
    - Customer's Account Level Public SSH Key, retrievable via REST or Qubole UI
    - The SSH service should allow Gateway ports
*/

resource "google_compute_instance" "qubole_bastion_host" {
  name = "qubole-bastion-host"
  project = var.data_lake_project
  machine_type = var.qubole_bastion_host_vm_type
  zone = var.qubole_bastion_host_vm_zone

  tags = [
    "qubole-bastion-host"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.qubole_dedicated_vpc.self_link
    subnetwork = google_compute_subnetwork.qubole_vpc_public_subnetwork.self_link
    network_ip = google_compute_address.qubole_bastion_host_internal_ip.address
    access_config {
      #name = "External NAT"
      #type = "ONE_TO_ONE_NAT"
      nat_ip = google_compute_address.qubole_bastion_host_external_ip.address
    }
  }

  metadata = {
    qubole_public_key = var.qubole_public_key
    account_ssh_key = var.account_ssh_key
    startup-script = file("${path.module}/scripts/qubole_bastion_startup.sh")
  }

}
