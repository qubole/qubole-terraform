variable "deployment_suffix" {
}

variable "data_lake_project_region" {
  default = "ap-southeast-1"
}

variable "db_primary_zone" {
  default = "ap-southeast-1a"
}

variable "db_secondary_zone" {
  default = "ap-southeast-1b"
}

variable "db_instance_class" {
  default = "db.t2.micro"
}

variable "hive_user_name" {
  default = "hive_user"
}

variable "hive_user_password" {
  default = "hive_user_password!23"
}

variable "hive_db_name" {
  default = "hive"
}

variable "qubole_dedicated_vpc" {
  default = "/projects/qubole-on-gcp/networks/qubole-dedicated-vpc"
}

variable "qubole_bastion_private_ip" {
}

variable "qubole_bastion_public_ip" {
}

variable "qubole_bastion_user" {
  default = "ec2-user"
}

variable "qubole_bastion_security_group" {
}

variable "qubole_dedicated_vpc_priv_subnet_cidr" {
  default = "10.2.0.0/24"
}

variable "qubole_dedicated_vpc_pub_subnet_cidr" {
}

variable "qubole_dedicated_vpc_priv_subnet_route_table" {
}

variable "qubole_dedicated_vpc_pub_subnet_route_table" {
}