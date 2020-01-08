/*
Creates a DB Subnet group for use by the RDS instance for Hive Metastore
 1. Two subnets included for future HA requirements
*/

resource "aws_db_subnet_group" "hive_metastore_subnet_group" {
  name       = "hive_metastore_subnet_group"
  subnet_ids = [aws_subnet.hive_metastore_subnet_primary.id, aws_subnet.hive_metastore_subnet_secondary.id]
}