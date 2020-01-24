/*
Creates a Custom IAM Policy to provide permissions for the holder of this policy to
 1. Be able to get an instance profile(cross account role, or dual iam role as applicable)
 2. Be able to pass the instance profile to the clusters

 This is for the following reason:
 1. Once Qubole starts a cluster, the autoscaling and CLCM runs on the cluster, For this the EC2 instances require to have the roles which allow handling EC2 services
 2. Using the pass role, Qubole achieves this

 Caveats:
 1. The customer should ensure that the listed permissions are not taken away as it might result in loss of functionality
*/

data "template_file" "qubole_cross_account_policy_template" {
  template = file("${path.module}/policies/qubole_ca_cross_account_policy_doc.json")
  vars = {
    instance-profile = aws_iam_instance_profile.qubole_dual_role_instance_profile.arn
    dual-iam-role = aws_iam_role.qubole_dual_role.arn
  }
}

resource "aws_iam_policy" "qubole_cross_account_policy" {
  name = "qubole_cross_account_policy_${var.deployment_suffix}"
  description = "Policy to authorize Qubole to pass along the Instance Profile for Clusters, and get these Instance Profiles as well"

  policy = data.template_file.qubole_cross_account_policy_template.rendered
}