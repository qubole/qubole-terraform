variable "deployment_suffix" {
}

variable "data_lake_project_region" {
}

variable "public_ssh_key" {
}

variable "qubole_public_key" {
}

variable "qubole_tunnel_nat" {
  type    = list(string)
  default = ["52.44.223.209/32", "100.25.6.193/32", "34.205.91.155/32"]
}

variable "bastion_ami" {
  default = "ami-0083aebf228b93dad"
}

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "terraform_deployer_key_name" {}
