/*
Creates a Custom IAM Policy to provide permissions for the S3 Service to
 1. Write Cluster Logs, Command Logs/Results/Resources, Notebooks to the Qubole Dedicated Bucket

 This is for the following reason:
 1. Qubole stores all information in a bucket designated for itself in the customer's account for offline access and audit

 Caveats:
 1. The customer should ensure that the listed permissions are not taken away as it might result in loss of functionality
*/

data "template_file" "qubole_ca_s3_policy_template" {
  template = file("${path.module}/policies/qubole_ca_s3_policy_doc.json")
  vars = {
    defloc = aws_s3_bucket.qubole-default_location.bucket
  }
}

resource "aws_iam_policy" "qubole_ca_s3_policy" {
  name = "qubole_ca_s3_policy_${var.deployment_suffix}"
  description = "S3 policy to authorize Qubole for writing cluster logs, command logs, command results, notebooks etc to Qubole Dedicated S3 Bucket"

  policy = data.template_file.qubole_ca_s3_policy_template.rendered
}