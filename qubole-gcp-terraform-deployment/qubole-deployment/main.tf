variable "data_lake_project" {
  default = "qubole-on-gcp"
}

variable "data_lake_project_number" {
  default = "25786460097"
}

provider "google-beta" {
  credentials = file("${path.module}/google_credentials/terraform_credentials.json")
  project = var.data_lake_project
}

provider "google" {
  credentials = file("${path.module}/google_credentials/terraform_credentials.json")
  project = var.data_lake_project
}

resource "random_id" "deployment_suffix" {
  byte_length = 4
}

module "account_integration" {
  source = "./modules/account_integration"
  deployment_suffix = random_id.deployment_suffix.hex
  data_lake_project = var.data_lake_project
  data_lake_project_number = var.data_lake_project_number
  data_lake_project_region = "<choose your own>"
  qubole_service_account = "<get from your account>"
}

module "network_infrastructure" {
  source = "./modules/network_infrastucture"
  deployment_suffix = random_id.deployment_suffix.hex
  data_lake_project = var.data_lake_project
  data_lake_project_number = var.data_lake_project_number
}

module "hive_metastore" {
  source = "./modules/hive_metastore"
  deployment_suffix = random_id.deployment_suffix.hex
  qubole_dedicated_vpc = module.network_infrastructure.qubole_dedicated_vpc_link
  qubole_bastion_internal_ip = module.network_infrastructure.qubole_bastion_internal_ip
  qubole_private_subnet_cidr = module.network_infrastructure.qubole_vpc_private_subnetwork_cidr
  data_lake_project = var.data_lake_project
  data_lake_project_number = var.data_lake_project_number
}

output "compute_service_account" {
  value =module.account_integration.qubole_compute_service_account
}

output "instance_service_account" {
  value =module.account_integration.qubole_instance_service_account
}

output "qubole_defloc" {
  value =module.account_integration.qubole_defloc_bucket_name
}

output "qubole_dedicated_vpc" {
  value = module.network_infrastructure.qubole_dedicated_vpc_link
}

output "qubole_dedicated_bastion" {
  value = module.network_infrastructure.qubole_bastion_external_ip
}

output "qubole_bastion_user" {
  value = "bastion-user"
}

output "hive_metastore_ip" {
  value = module.hive_metastore.cloud_sql_proxy_networkIP
}

output "hive_metastore_db_schema" {
  value = module.hive_metastore.hive_metastore_schema
}

output "hive_metastore_db_user" {
  value = module.hive_metastore.hive_metastore_user
}

output "hive_metastore_db_user_password" {
  value = module.hive_metastore.hive_metastore_user_password
}
