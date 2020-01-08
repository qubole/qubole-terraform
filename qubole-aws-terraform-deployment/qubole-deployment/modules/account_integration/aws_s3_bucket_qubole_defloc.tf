/*
Creates an S3 Bucket that will act as the "default location" for the Qubole account
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

resource "aws_s3_bucket" "qubole-default_location" {
  bucket = "${var.qubole-defloc-name}-${var.deployment_suffix}"
  region = var.data_lake_project_region
  #careful with this
  force_destroy = true
}

output "qubole_defloc" {
  value = aws_s3_bucket.qubole-default_location.arn
}