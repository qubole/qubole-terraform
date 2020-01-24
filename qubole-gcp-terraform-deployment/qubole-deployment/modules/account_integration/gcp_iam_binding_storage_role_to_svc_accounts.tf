/*
Authorizes the Compute Service Account & Instance Service account (created for Qubole) with
 1. A custom storage role that allows working with Google Cloud Storage Buckets

 This is for the following reason:
 1. Qubole uses the Compute Service Account to write logs, results to the Cloud Storage. The Instance Service Account to read data buckets through the engines. This requires Storage Permissions.

 Caveats:
 1. It is the customers responsibility to authorize the custom storage role to the Instance Service Account  on the buckets that need to be accessed via the Qubole Clusters
*/

resource "google_project_iam_binding" "bind_storage_role_to_svc_accounts" {
    project = var.data_lake_project
    role = google_project_iam_custom_role.qubole_custom_storage_role.id

    members = [
        "serviceAccount:${google_service_account.qubole_instance_service_acc.email}",
        "serviceAccount:${google_service_account.qubole_compute_service_acc.email}"
    ]
}
