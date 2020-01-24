/*
Creates an IAM role, called Dual IAM Role
1. Creates an IAM role with an S3 and EC2 policy
2. Creates and attaches an Instance Profile to it

 This is for the following reason:
 1. The Qubole Cross Account IAM role will pass this role to the created clusters for further CLCM and autoscaling
 2. Qubole applies the instance profile to the clusters
*/

data "template_file" "qubole_dual_role_trust_template" {
  template = file("${path.module}/policies/qubole_dual_role_trust_doc.json")
}

resource "aws_iam_role" "qubole_dual_role" {
  name = "qubole_dual_role_${var.deployment_suffix}"
  assume_role_policy = data.template_file.qubole_dual_role_trust_template.rendered
}

resource "aws_iam_instance_profile" "qubole_dual_role_instance_profile" {
  name = "qubole_dual_role_instance_profile_${var.deployment_suffix}"
  role = aws_iam_role.qubole_dual_role.name
}

output "qubole_dual_role_instance_profile" {
  value = aws_iam_instance_profile.qubole_dual_role_instance_profile.arn
}