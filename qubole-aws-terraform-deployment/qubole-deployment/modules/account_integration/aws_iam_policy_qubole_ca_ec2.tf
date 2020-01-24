/*
Creates a Custom IAM Policy to provide permissions for the EC2 Service to
 1. Handle Compute resources like instances, disks, addresses etc
 2. Handle Network resources like security groups and list networks

 This is for the following reason:
 1. Qubole uses the a Cross Account Role with the IAM policy to spin up clusters using EC2 services

 Caveats:
 1. The customer should ensure that the listed permissions are not taken away as it might result in loss of functionality
*/

resource "aws_iam_policy" "qubole_ca_ec2_policy" {
  name = "qubole_ca_ec2_policy_${var.deployment_suffix}"
  description = "EC2 policy to authorize Qubole for orchestrating EC2 and other Compute resources in our account"

  policy = file("${path.module}/policies/qubole_ca_ec2_policy_doc.json")
}