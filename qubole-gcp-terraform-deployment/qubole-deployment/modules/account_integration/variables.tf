variable "deployment_suffix" {
}

variable "data_lake_project" {
}

variable "data_lake_project_number" {
}

variable "data_lake_project_region" {
  default = "asia-southeast1"
}

variable "qubole_service_account" {
  default = "qbol-624-gcp@prod-qsa-project-1.iam.gserviceaccount.com"
}

variable "qubole_custom_compute_role_id" {
  default = "qubole_custom_compute_role"
}

variable "qubole_custom_compute_role_title" {
  default = "qubole_custom_compute_role"
}

variable "qubole_custom_storage_role_id" {
  default = "qubole_custom_storage_role"
}

variable "qubole_custom_storage_role_title" {
  default = "qubole_custom_storage_role"
}

variable "qubole_compute_service_acc_id" {
  default = "qubole-compute-sa"
}

variable "qubole_compute_service_acc_name" {
  default = "qubole_compute_sa"
}

variable "qubole_instance_service_acc_id" {
  default = "qubole-instance-sa"
}

variable "qubole_instance_service_acc_name" {
  default = "qubole_instance_sa"
}
