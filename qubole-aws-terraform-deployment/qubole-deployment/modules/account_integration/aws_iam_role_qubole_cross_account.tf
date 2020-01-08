/*
Creates an IAM role, called Cross Account Role
1. Create a cross account accessible role
2. Cross account accessibility is provided using the trust policy in which the Qubole Principal AWS Account ID + Customer specific-generated
   EXTERNAL ID is used to authorize use with confidence

 This is for the following reason:
 1. We need to authorize Qubole to be able to use this Role
 2. This role, with its trust policy allows the Qubole Principal AWS Account + EXTERNAL ID to access this with confidence
*/

data "template_file" "qubole_cross_account_role_trust_template" {
  template = file("${path.module}/policies/qubole_ca_role_trust_doc.json")
  vars = {
    qubole-aws-account-id = var.qubole-aws-account-id
    qubole-external-id = var.qubole-external-id
  }
}

resource "aws_iam_role" "qubole_cross_account_role" {
  name = "qubole_cross_account_role_${var.deployment_suffix}"
  assume_role_policy = data.template_file.qubole_cross_account_role_trust_template.rendered
}

output "qubole_cross_account_role_arn" {
  value = aws_iam_role.qubole_cross_account_role.arn
}