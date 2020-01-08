/*
Creates a two way VPC peering between
 1. The Qubole Dedicated VPC
 2. The Hive Metastore Dedicated VPC
 3. Creates Route Table entries that direct traffic to each other using the VPC Peering Connection end point

 This is for the reason:
 1. Qubole can access the RDS instance hosting the Hive Metastore in a secure and scalable fashion
 2. The Route Table entries are required because AWS VPC peering does not support auto creation of routes

*/

resource "aws_vpc_peering_connection" "qubole_vpc_hive_vpc_peering" {
  peer_vpc_id   = var.qubole_dedicated_vpc
  vpc_id        = aws_vpc.hive_metastore_dedicated_vpc.id

  tags = {
    Name = "qubole-vpc-hive-vpc-peering"
  }

  auto_accept = true

}

resource "aws_route" "route_from_bastion_to_rds" {
  route_table_id            = var.qubole_dedicated_vpc_pub_subnet_route_table
  destination_cidr_block    = aws_vpc.hive_metastore_dedicated_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.qubole_vpc_hive_vpc_peering.id
}

resource "aws_route" "route_from_clusters_to_rds" {
  route_table_id            = var.qubole_dedicated_vpc_priv_subnet_route_table
  destination_cidr_block    = aws_vpc.hive_metastore_dedicated_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.qubole_vpc_hive_vpc_peering.id
}

resource "aws_route" "route_from_rds_to_bastion" {
  route_table_id            = aws_vpc.hive_metastore_dedicated_vpc.default_route_table_id
  destination_cidr_block    = var.qubole_dedicated_vpc_pub_subnet_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.qubole_vpc_hive_vpc_peering.id
}

resource "aws_route" "route_from_rds_to_clusters" {
  route_table_id            = aws_vpc.hive_metastore_dedicated_vpc.default_route_table_id
  destination_cidr_block    = var.qubole_dedicated_vpc_priv_subnet_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.qubole_vpc_hive_vpc_peering.id
}

