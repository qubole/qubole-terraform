/*
Creates two subnets in the Hive Metastore Dedicated VPC.

 This is for the following reason:
 1. This is required as an RDS instance requires a DB Subnet group of atleast two subnets in two AZs
*/

resource "aws_subnet" "hive_metastore_subnet_primary" {
  cidr_block = var.hive_metastore_vpc_primary_subnet_cidr
  vpc_id = aws_vpc.hive_metastore_dedicated_vpc.id
  availability_zone = var.db_primary_zone
}

resource "aws_subnet" "hive_metastore_subnet_secondary" {
  cidr_block = var.hive_metastore_vpc_secondary_subnet_cidr
  vpc_id = aws_vpc.hive_metastore_dedicated_vpc.id
  availability_zone = var.db_secondary_zone
}
