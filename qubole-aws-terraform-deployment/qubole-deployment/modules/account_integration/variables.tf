variable "deployment_suffix" {
}

variable "qubole-aws-account-id" {
  default = 805246085872
}

variable "qubole-external-id" {

}

variable "data_lake_project_region" {

}

variable "qubole-defloc-name" {

}

variable "aws-spot-fleet-tagging-role-arn" {
  default = "arn:aws:iam::aws:policy/service-role/AmazonEC2SpotFleetTaggingRole"
}

variable "qubole-heterogeneous-role-name" {
  default = "qubole-ec2-spot-fleet-role"
}
