/*
Authorizes the Compute Service Account & Instance Service account (created for Qubole) with
 1. A custom compute role that allows the Service Account to manage VMs for orchestrating clusters

 This is for the following reason:
 1. Qubole uses the Compute and Instance Service Accounts to perform Complete Cluster LifeCycle Management and Autoscaling. This requires Compute Permissions
*/

resource "google_project_iam_binding" "bind_compute_role_to_svc_accounts" {
    project = var.data_lake_project
    role = google_project_iam_custom_role.qubole_custom_compute_role.id

    members = [
        "serviceAccount:${google_service_account.qubole_instance_service_acc.email}",
        "serviceAccount:${google_service_account.qubole_compute_service_acc.email}"
    ]
}
