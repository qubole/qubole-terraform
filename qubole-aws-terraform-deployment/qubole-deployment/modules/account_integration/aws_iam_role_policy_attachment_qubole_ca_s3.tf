/*
Attaches the S3 Policy to the Cross Account Role

 This is for the following reason:
 1. We need to authorize Qubole to be able to use this Policy
 2. This role, with its trust policy allows the Qubole Principal AWS Account + EXTERNAL ID to access this with confidence
*/

resource "aws_iam_role_policy_attachment" "qubole-cross-account-s3-attach" {
  role = aws_iam_role.qubole_cross_account_role.name
  policy_arn = aws_iam_policy.qubole_ca_s3_policy.arn
}