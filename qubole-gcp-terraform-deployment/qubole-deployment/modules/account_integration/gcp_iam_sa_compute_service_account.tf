/*
 Creates a Custom Service Account that will be used by Qubole to
 1. Get access to the custom compute role for creating the cluster minimum configuration
 2. Provide the VMs with the Instance Service Account for further autoscaling and cluster life cycle management

 This is for the following reason:
 1. Qubole uses the custom Compute Role to list networks, create vms, create addresses, tag instances and pass IAM service accounts to other instances
 2. The Custom Compute Role is bound to the Compute Service Account and hence made available to Qubole

 Caveats
 1. Ensure that this service account does not have IAM permissions to sensitive resources like GCS data buckets or Big Query Read permissions.
*/

resource "google_service_account" "qubole_compute_service_acc" {
  project = var.data_lake_project
  account_id = var.qubole_compute_service_acc_id
  display_name = var.qubole_compute_service_acc_name
}

output "qubole_compute_service_account" {
  value = google_service_account.qubole_compute_service_acc.email
}
