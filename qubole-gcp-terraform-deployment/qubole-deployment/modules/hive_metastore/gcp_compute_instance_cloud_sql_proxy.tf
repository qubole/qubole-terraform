/*
Creates a Google Compute Engine VM that will host a Cloud SQL Proxy process to connect to the Cloud SQL
 Features(Ideal)
 1. A networkIP i.e. a static internal address
 2. No network interfaces i.e. no external IP address
 3. Instead of a single node GCE setup, setup a GKE to make the Cloud SQL Proxy Highly Available
 We will use Private IP Service Networking between the VPC hosting this Cloud SQL Proxy instance
 Any external application desiring to connect to the Cloud SQL instance, will use the Cloud SQL proxy
 With the private IP setup, we can make sure that neither the Cloud SQL Instance, nor the Proxy has an external IP, hence making connections
   very secure and removing latency
*/

resource "google_compute_instance" "cloud_sq_proxy_host" {
  name = "cloud-sql-proxy-host"
  project = var.data_lake_project
  machine_type = var.cloud_sql_proxy_host_vm_type
  zone = var.cloud_sql_proxy_host_vm_zone

  tags = [
    "cloud-sql-proxy-host"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.cloud_sql_proxy_vpc.self_link
    subnetwork = google_compute_subnetwork.cloud_sql_proxy_private_subnetwork.self_link
    network_ip = google_compute_address.cloud_sql_proxy_internal_ip.address
  }

  metadata = {
    project_name = var.data_lake_project
    region = var.data_lake_project_region
    hive_user = var.hive_user_name
    hive_user_password = var.hive_user_password
    hive_db = var.hive_db_name
    cloud_sql_instance = google_sql_database_instance.cloud_sql_for_hive_metastore.name
    credentials_data = file("${path.module}/../../google_credentials/terraform_credentials.json")
    startup-script = file("${path.module}/scripts/cloud_sql_proxy_startup.sh")
  }

}

