variable "deployment_suffix" {
}

variable "data_lake_project" {
}

variable "data_lake_project_number" {
}

variable "data_lake_project_region" {
  default = "asia-southeast1"
}

variable "cloud_sql_proxy_host_vm_type" {
  default = "f1-micro"
}

variable "cloud_sql_proxy_host_vm_zone" {
  default = "asia-southeast1-a"
}

variable "qubole_bastion_internal_ip" {
  default = "get from network infrastructure module"
}

variable "qubole_private_subnet_cidr" {
  default = "get from network infrastructure module"
}

variable "cloud_sql_proxy_service_acc_id" {
  default = "cloud-sql-proxy-sa"
}

variable "cloud_sql_proxy_service_acc_name" {
  default = "cloud_sql_proxy_sa"
}

variable "cloud_sql_for_hive_metastore_tier" {
  default = "db-n1-standard-1"
}

variable "hive_user_name" {
  default = "hive_user"
}

variable "hive_user_password" {
  default = "hive_user_password!23"
}

variable "hive_db_name" {
  default = "hive"
}

variable "qubole_dedicated_vpc" {
  default = "/projects/qubole-on-gcp/networks/qubole-dedicated-vpc"
}