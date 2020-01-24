/*
Authorize the Instance Service Account and Compute Service Account (created for Qubole) as
 1. Service Account User
 on the Compute Engine default service account

 This is for the following reason:
 1. The CSA and ISA will need access to the CE default account otherwise they wont be able to sping up instances
*/

data "google_iam_policy" "auth_csa_isa_on_ce_policy_data" {
  binding {
    role = "roles/iam.serviceAccountUser"
    members = [
      "serviceAccount:${google_service_account.qubole_compute_service_acc.email}",
      "serviceAccount:${google_service_account.qubole_instance_service_acc.email}"
    ]
  }
}

resource "google_service_account_iam_policy" "auth_csa_isa_on_ce_policy" {
  service_account_id = "projects/${var.data_lake_project}/serviceAccounts/${var.data_lake_project_number}-compute@developer.gserviceaccount.com"
  policy_data = data.google_iam_policy.auth_csa_isa_on_ce_policy_data.policy_data
}
