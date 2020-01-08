provider "aws" {
  version = "~> 2.0"
  region  = "ap-southeast-1"
}

resource "random_id" "deployment_suffix" {
  byte_length = 4
}

resource "aws_key_pair" "terraform_deployer_key_pair" {
  key_name = "terraform-key-pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

module "account_integration" {
  source = "./modules/account_integration"
  deployment_suffix = random_id.deployment_suffix.hex
}

module "network_infrastructure" {
  source = "./modules/network_infrastucture"
  deployment_suffix = random_id.deployment_suffix.hex
  #Required for the metastore to be able to perform a remote execution of Hive Metastore Initialization
  terraform_deployer_key_name = aws_key_pair.terraform_deployer_key_pair.key_name
}


module "hive_metastore" {
  source = "./modules/hive_metastore"
  deployment_suffix = random_id.deployment_suffix.hex
  qubole_dedicated_vpc = module.network_infrastructure.qubole_dedicated_vpc_id
  qubole_bastion_private_ip = module.network_infrastructure.qubole_bastion_host_private_ip
  qubole_dedicated_vpc_priv_subnet_cidr = module.network_infrastructure.qubole_vpc_private_subnet_cidr
  qubole_bastion_public_ip = module.network_infrastructure.qubole_bastion_host_eip
  qubole_bastion_security_group = module.network_infrastructure.qubole_bastion_security_group
  qubole_dedicated_vpc_pub_subnet_route_table = module.network_infrastructure.qubole_dedicated_vpc_pub_subnet_route_table
  qubole_dedicated_vpc_pub_subnet_cidr = module.network_infrastructure.qubole_vpc_public_subnetwork_cidr
  qubole_dedicated_vpc_priv_subnet_route_table = module.network_infrastructure.qubole_dedicated_vpc_priv_subnet_route_table
}


output "cross_account_iam_role" {
  value = module.account_integration.qubole_cross_account_role_arn
}

output "dual_iam_role" {
  value = module.account_integration.qubole_dual_role_instance_profile
}

output "qubole_defloc" {
  value = module.account_integration.qubole_defloc
}

output "qubole_bastion_host_eip" {
  value = module.network_infrastructure.qubole_bastion_host_eip
}

output "qubole_bastion_user" {
  value = "ec2-user"
}

output "qubole_dedicated_vpc_arn" {
  value = module.network_infrastructure.qubole_dedicated_vpc_arn
}

output "qubole_vpc_az" {
  value = module.network_infrastructure.qubole_vpc_az
}

output "hive_metastore_ip" {
  value = module.hive_metastore.hive-metastore-db-ip
}

output "hive_metastore_user" {
  value = module.hive_metastore.hive-metastore-db-user
}

output "hive_metastore_password" {
  value = module.hive_metastore.hive-metastore-db-password
}

output "hive_metastore_db_name" {
  value = module.hive_metastore.hive-metastore-db-name
}



