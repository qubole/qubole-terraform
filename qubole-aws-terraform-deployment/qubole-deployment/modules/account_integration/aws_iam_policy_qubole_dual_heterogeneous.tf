/*
Creates a Custom IAM Policy to provide permissions for the EC2 Service to
 1. Make spot fleet requests for multiple worker types to be configured

 This is for the following reason:
 1. Qubole uses the a Cross Account Role with the IAM policy to spin up clusters using EC2 services
 2. This policy can be edited to suit the Compute needs for the Dual IAM role which will applied to the clusters as INSTANCE PROFILE

 Caveats:
 1. The customer should ensure that the listed permissions are not taken away as it might result in loss of functionality
*/

resource "aws_iam_policy" "qubole_dual_heterogeneous_policy" {
  name = "qubole_dual_heterogeneous_policy_${var.deployment_suffix}"
  description = "Heterogeneous policy to authorize Qubole for Spot Fleet requests enabling worker nodes comprising the cluster to be of different instance types."

  policy = file("${path.module}/policies/qubole_heterogeneous_policy_doc.json")
}
