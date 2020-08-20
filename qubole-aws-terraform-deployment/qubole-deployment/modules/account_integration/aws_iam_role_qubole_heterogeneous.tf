/*
Creates an IAM role, called qubole-ec2-spot-fleet-role
1. Creates an IAM role with AWSEC2SpotFleetTaggingRole Policy
2. Creates and attaches an Instance Profile to it

 This is for the following reason:
 1. The Qubole Cross Account and Dual IAM role will use this role to make spot fleet requests
*/

data "template_file" "qubole_heterogeneous_role_trust_template" {
  template = file("${path.module}/policies/qubole_heterogeneous_role_trust_doc.json")
}

resource "aws_iam_role" "qubole_heterogeneous_role" {
  name = var.qubole-heterogeneous-role-name
  assume_role_policy = data.template_file.qubole_heterogeneous_role_trust_template.rendered
}

resource "aws_iam_instance_profile" "qubole_heterogeneous_role_instance_profile" {
  name = "qubole_heterogeneous_role_instance_profile_${var.deployment_suffix}"
  role = aws_iam_role.qubole_heterogeneous_role.name
}

output "qubole_heterogeneous_role_instance_profile" {
  value = aws_iam_instance_profile.qubole_heterogeneous_role_instance_profile.arn
}
