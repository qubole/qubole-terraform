/*
Creates a Cloud SQL Instance to host the Hive Metastore. It
 1. Creates a 2nd Gen, MySQL 5.7 instance in the specified region and zone
 2. Creates a database/schema called hive which will act as the Hive Metastore
 3. Updates the password for the root user
 4. Creates a user called hive_user which will be used by Qubole to access the Hive Metastore
 5. Initializes the hive database with the required tables for it to be a functional Hive Metastore

 This is for the following reason:
 1. Qubole requires a Hive Metastore configured for the account so that the engines can be seamlessly integrated with the metastore
 2. Qubole provides a hosted metastore, but more often than not, for security and scalability reasons, customers will want to host their own metastore

 Caveats:
 1. Given the networking architecture of Cloud SQL, there are two possibilities of connecting.
       i. Public IP networking
            - this requires that we whitelist an external IP to be able to access the Cloud SQL instance
            - this creates a problem for Qubole as we need to whitelist an entire subnetwork(private subnetwork) to the CloudSQL instance.
            - in this case, the solution is to setup Google's Cloud SQL proxy infront of the Cloud SQL instance. Since the proxy is hosted on either GCE or GKS, we can now whitelist the subnets to the proxy
       ii. Private IP networking
            - with Private IP networking, we are limited to setting up the private IP networking with one and only one VPC.
            - the standard pattern hence would be setting up a VPC with a Cloud SQL proxy and setting up private IP networking between them
            - this opens the possibility of peering Qubole's VPC with the VPC of the proxy and transitively getting access to the Cloud SQL instance
            - the private IP method is faster and more secure
 2. Terraform DOES NOT SUPPORT running an initialization script, hence running the HIVE Metastore DDL will have to be a manual step
*/

resource "google_sql_database_instance" "cloud_sql_for_hive_metastore" {
  provider = "google-beta"

  name = "hive-metastore-instance-${var.deployment_suffix}"
  region = var.data_lake_project_region
  project = var.data_lake_project
  database_version = "MYSQL_5_7"
  depends_on = [
    "google_service_networking_connection.cloud_sql_proxy_svc_networking_connection"
  ]
  settings {
    tier = var.cloud_sql_for_hive_metastore_tier
    activation_policy = "ALWAYS"
    ip_configuration {
      ipv4_enabled = false
      private_network = google_compute_network.cloud_sql_proxy_vpc.self_link
    }
    location_preference {
      //No preference
    }
  }
}

resource "google_sql_database" "hive_metastore_db" {
  name = var.hive_db_name
  project = var.data_lake_project
  instance = google_sql_database_instance.cloud_sql_for_hive_metastore.name
  depends_on = [
    "google_sql_database_instance.cloud_sql_for_hive_metastore"
  ]
}

resource "google_sql_user" "hive_metastore_db_user" {
  name = var.hive_user_name
  project = var.data_lake_project
  instance = google_sql_database_instance.cloud_sql_for_hive_metastore.name
  host = "%"
  password = var.hive_user_password
  depends_on = [
    "google_sql_database.hive_metastore_db"
  ]
}

output "hive_metastore_instance_ip" {
  value = google_sql_database_instance.cloud_sql_for_hive_metastore.private_ip_address
}

output "hive_metastore_schema" {
  value = var.hive_db_name
}

output "hive_metastore_user" {
  value = var.hive_user_name
}

output "hive_metastore_user_password" {
  value = var.hive_user_password
}
