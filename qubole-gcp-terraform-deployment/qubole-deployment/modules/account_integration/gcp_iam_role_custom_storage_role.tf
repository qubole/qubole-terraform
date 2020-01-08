/*
Creates a Custom Role to work with Google Cloud Storage to
 1. To save logs, results and command histories for clusters and queries
 2. To save notebooks and virtual environments for when clusters terminate and are brought back online

 This is for the following reason:
 1. Qubole periodically syncs all logs, results and resources to GCS so that in case of service outages or cluster terminations, the resources are still available

 Caveats:
 1. The customer should ensure that the listed permissions are not taken away as it might result in loss of functionality
*/

resource "google_project_iam_custom_role" "qubole_custom_storage_role" {
  project = var.data_lake_project
  role_id = "${var.qubole_custom_storage_role_id}_${var.deployment_suffix}"
  title = "${var.qubole_custom_storage_role_id}_${var.deployment_suffix}"
  description = "Custom storage role for Qubole to read/write VM logs, query results/logs/resources to dedicated bucket"
  permissions = [
    "storage.buckets.get",
    "storage.buckets.getIamPolicy",
    "storage.buckets.list",
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.getIamPolicy",
    "storage.objects.list",
    "storage.objects.setIamPolicy"]
}
