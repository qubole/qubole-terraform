/*
Creates a Google Cloud Storage Bucket that will act as the "default location" for the Qubole account
 Qubole saves
 1. Cluster Start/Scale Logs
 2. Engine Logs
 3. Results
 4. Notebooks
 5. Py/R environments
 in this location

 This is for the following reason:
 1. Qubole performs Cluster Lifecycle Management. Which means it terminates idle clusters, downscales VMs to save cost and recreates clusters in catastrophic failures
 2. Qubole also makes available the logs, results, command histories, command UIs offline (and indefinetly)
 3. Qubole achieves this by storing all the above data in the defloc and loading it when the user requests for it

 Caveats:
 1. Deleting content from this location can have unintended consequences on the platform including loss of work and data
 2. Consult Qubole Support before moving this location
*/

resource "google_storage_bucket" "qubole_defloc_bucket" {
  name = "qubole_default_loc_${var.deployment_suffix}"
  project = var.data_lake_project
  location = var.data_lake_project_region
  force_destroy = true
  bucket_policy_only = true
}

resource "google_storage_bucket_iam_member" "qubole_defloc_bucket_policy_isa" {
  bucket = google_storage_bucket.qubole_defloc_bucket.name
  role = google_project_iam_custom_role.qubole_custom_storage_role.id
  member = "serviceAccount:${google_service_account.qubole_instance_service_acc.email}"
}

resource "google_storage_bucket_iam_member" "qubole_defloc_bucket_policy_csa" {
  bucket = google_storage_bucket.qubole_defloc_bucket.name
  role = google_project_iam_custom_role.qubole_custom_storage_role.id
  member = "serviceAccount:${google_service_account.qubole_compute_service_acc.email}"
}

/*resource "google_storage_bucket_iam_binding" "qubole_defloc_bucket_policy_binding" {
  bucket = google_storage_bucket.qubole_defloc_bucket.name
  role = google_project_iam_custom_role.qubole_custom_storage_role.id

  members = [
    "serviceAccount:${google_service_account.qubole_compute_service_acc.email}",
    "serviceAccount:${google_service_account.qubole_instance_service_acc.email}"
  ]
}*/

output "qubole_defloc_bucket_name" {
  value = google_storage_bucket.qubole_defloc_bucket.name
}
