/*
Attaches the EC2 Policy to the Dual IAM Role(+Instance Profile)

 This is for the following reason:
 1. We need to authorize Qubole to be able to use this Policy
 2. This role, with its trust policy allows the Qubole Principal AWS Account + EXTERNAL ID to access this with confidence
*/

resource "aws_iam_role_policy_attachment" "qubole-dual-ec2-attach" {
  role = aws_iam_role.qubole_dual_role.name
  policy_arn = aws_iam_policy.qubole_dual_ec2_policy.arn
}