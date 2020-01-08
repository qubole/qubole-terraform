/*
Creates a Custom Service Account that will be used by Qubole to
 1. Provide the VMs with the Instance Service Account for further autoscaling and cluster life cycle management
 2. Prove the VMs with credentials to access sensitive resources like GCS Data Buckets and Big Query Datasets without exposing them to Qubole

 This is for the following reason:
 1. Qubole uses the custom Instance Role to give clusters self managing capabilities for autoscaling and lifecycle management
 2. The Custom Compute Role is bound to the Instance Service Account

 Caveats
 1. Ensure that instance service account is IAM authorized to sensitive data buckets and big query datasets if the workloads running on the cluster require access to them
*/

resource "google_service_account" "qubole_instance_service_acc" {
  project = var.data_lake_project
  account_id = var.qubole_instance_service_acc_id
  display_name = var.qubole_instance_service_acc_name
}

output "qubole_instance_service_account" {
  value = google_service_account.qubole_instance_service_acc.email
}