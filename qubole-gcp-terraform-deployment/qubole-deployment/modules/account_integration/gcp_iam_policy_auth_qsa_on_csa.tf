/*
Authorizes the Qubole Service Account with
 1. Service Account User Role
 2. Service Account Token Creator Role
 on the Compute Service Service Account

 This is for the following reason:
 1. The compute service account is used to initialize the cluster minimum configuration
 2. Qubole creates a service account for every customer Qubole account - this is the Qubole Service Account
 3. Once the Qubole Service Account is authorized to use the compute service account, it uses it to initialize the cluster minimum configuration
 4. Service Account Credentials expire every 1 hour, hence Qubole Service Account requires token creator roles to be able to perform administrative tasks on the cluster
*/

data "google_iam_policy" "auth_qsa_on_csa_policy_data" {
    binding {
        role = "roles/iam.serviceAccountUser"
        members = [
            "serviceAccount:${var.qubole_service_account}"
        ]
    }

    binding {
        role = "roles/iam.serviceAccountTokenCreator"
        members = [
            "serviceAccount:${var.qubole_service_account}"
        ]
    }
}

resource "google_service_account_iam_policy" "auth_qsa_on_csa_policy" {
    service_account_id = google_service_account.qubole_compute_service_acc.name
    policy_data = data.google_iam_policy.auth_qsa_on_csa_policy_data.policy_data
}
