/*
Creates an RDS Instance to host the Hive Metastore. It
 1. Creates a MySQL 5.7 instance in the specified VPC and DB subnet group
 2. Creates a database/schema called hive which will act as the Hive Metastore
 3. Creates a root user and initializes its password.
 4. Initializes the hive database with the required tables for it to be a functional Hive Metastore
 5. RDS will not have a public IP or public accessibility for security

 This is for the following reason:
 1. Qubole requires a Hive Metastore configured for the account so that the engines can be seamlessly integrated with the metastore
 2. Qubole provides a hosted metastore, but more often than not, for security and scalability reasons, customers will want to host their own metastore

 Caveats:
 1. AWS RDS does not allow bootstrap SQL scripts to initialize the DB, so we run the init of the metastore via the Bastion Host
*/

resource "aws_db_instance" "hive_metastore_db_instance" {
  identifier = "hive-metastore-db-${var.deployment_suffix}"
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = var.db_instance_class
  name = "hive"
  username = var.hive_user_name
  password = var.hive_user_password
  parameter_group_name = "default.mysql5.7"
  apply_immediately = true
  db_subnet_group_name = aws_db_subnet_group.hive_metastore_subnet_group.name
  publicly_accessible = false
  vpc_security_group_ids = [
    aws_security_group.hive_metastore_security_group.id]
  skip_final_snapshot = true
  #TODO this hive metastore is more of a PoC metastore hence disabling the final snapshot, enable it if you plan to upgrade the same to production use
}

output "hive-metastore-db-ip" {
  value = aws_db_instance.hive_metastore_db_instance.address
}

output "hive-metastore-db-user" {
  value = aws_db_instance.hive_metastore_db_instance.username
}

output "hive-metastore-db-password" {
  value = aws_db_instance.hive_metastore_db_instance.password
}

output "hive-metastore-db-name" {
  value = aws_db_instance.hive_metastore_db_instance.name
}