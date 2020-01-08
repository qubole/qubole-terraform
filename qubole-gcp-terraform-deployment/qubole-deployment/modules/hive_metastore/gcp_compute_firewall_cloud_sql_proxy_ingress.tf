/*
Creates a Firewall Rule that
 1. Allows ingress to the Cloud SQL Proxy Host from the Bastion in the Qubole Dedicated VPC
 2. Allows ingress to the Cloud SQL Proxy Host from the Private Subnet in the Qubole Dedicated VPC

 This is for the following reason:
 1. Qubole Control Plane will talk to the Cloud SQL Proxy via the Bastion Host
 2. Qubole Clusters prefer having direct access to the Metastore instead of going through the Bastion(Latency) and hence need direct access to the proxy
*/

resource "google_compute_firewall" "proxy_ingress_from_bastion" {
    name    = "proxy-ingress-from-bastion"
    project = var.data_lake_project
    network = google_compute_network.cloud_sql_proxy_vpc.self_link

    allow {
            protocol = "tcp"
            ports    = ["3306", "20557"]
    }
    source_ranges = [var.qubole_bastion_internal_ip]
    target_tags = ["cloud-sql-proxy-host"]

}

resource "google_compute_firewall" "proxy_ingress_from_qubole_private_subnet" {
    name    = "proxy-ingress-from-qubole-private-subnet"
    project = var.data_lake_project
    network = google_compute_network.cloud_sql_proxy_vpc.self_link

    allow {
        protocol = "tcp"
        ports    = ["3306"]
    }
    source_ranges = [var.qubole_private_subnet_cidr]
    target_tags = ["cloud-sql-proxy-host"]
}
