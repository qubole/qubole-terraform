/*
Creates a GCP Cloud NAT, using a GCP Cloud Router to aggregate/group the NAT configuration options
 It creates
 1. A Cloud Router Resource (only as an aggregator of the various NATs being configured)
 2. A Cloud NAT instance that is associated with the private subnetwork in the Qubole Dedicated VPC
 3. The IP allocation is automatic as Qubole Clusters autoscale very rapidly and manually sizing static IP addresses for NAT is not scalable

 This is for the following reason:
 1. Secure designs will require bringing up Qubole clusters without Public IP addresses
 2. Having a Cloud NAT allows outbound communication from the Qubole Clusters as needed

 Cloud NAT is not a physical device, it is only a configuration that provides NAT configuration to VMs and the VMs do the NAT by themselves
 Hence this is highly scalable. Please see https://cloud.google.com/nat/docs/overview#under_the_hood
*/

resource "google_compute_router" "qubole_dedicated_vpc_router" {
  name = "router-for-qubole-clusters"
  project = var.data_lake_project
  network = google_compute_network.qubole_dedicated_vpc.self_link
  region = var.data_lake_project_region
}

resource "google_compute_router_nat" "qubole_dedicated_vpc_nat" {
  name = "nat-router-for-qubole-clusters"
  project = var.data_lake_project
  router = google_compute_router.qubole_dedicated_vpc_router.name
  region = var.data_lake_project_region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = google_compute_subnetwork.qubole_vpc_private_subnetwork.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
