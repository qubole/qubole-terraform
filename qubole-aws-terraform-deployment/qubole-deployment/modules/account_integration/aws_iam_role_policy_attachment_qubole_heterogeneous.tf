/*
Attaches the AWSEC2SpotFleetTaggingRole Policy to the Heterogeneous Role
*/

resource "aws_iam_role_policy_attachment" "qubole-heterogeneous-attach" {
  role = aws_iam_role.qubole_heterogeneous_role.name
  policy_arn = var.aws-spot-fleet-tagging-role-arn
}
