/*
Authorize the Instance Service Account and Compute Service Account (created for Qubole) as
 1. Service Account User
 on the Instance Service Account (created for Qubole)

 This is for the following reason:
 1. The compute service account is used to initialize the cluster minimum configuration
 2. Once the minimum cluster is up, Qubole passes the job of handling the cluster lifecycle to the cluster itself
 3. This means that the cluster needs to use the Instance Service Account role to spin more Vms and access data buckets
 4. This ensures that Qubole can never access the customers Big Query Datasets and Cloud Storage Buckets
*/

data "google_iam_policy" "auth_csa_isa_on_isa_policy_data" {
  binding {
    role = "roles/iam.serviceAccountUser"
    members = [
      "serviceAccount:${google_service_account.qubole_compute_service_acc.email}",
      "serviceAccount:${google_service_account.qubole_instance_service_acc.email}"
    ]
  }
}

resource "google_service_account_iam_policy" "auth_csa_isa_on_isa_policy" {
  service_account_id = google_service_account.qubole_instance_service_acc.id
  policy_data = data.google_iam_policy.auth_csa_isa_on_isa_policy_data.policy_data
}
