/*
Creates a Security Group for RDS Instance to host the Hive Metastore. It
 1. Whitelists the Qubole Bastion Host on port 3306 and 20557
 2. Whitelists the Qubole Dedicated VPCs private subnet on port 3306

 This is for the following reason:
 1. Qubole uses the bastion host to query the metastore for DB-table lists to show on the Analyze page
 2. Qubole clusters create a thrift connection to the hive metastore which are utlized by the engines for Hive Integrations
*/

resource "aws_security_group" "hive_metastore_security_group" {
  name = "hive_metastore_security_group"
  vpc_id = aws_vpc.hive_metastore_dedicated_vpc.id

  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    cidr_blocks = ["${var.qubole_bastion_private_ip}/32"]   #TODO no way to specify only an IP. it has to be a CIDR block
  }

  ingress {
    from_port = 20557
    protocol = "tcp"
    to_port = 20557
    cidr_blocks = ["${var.qubole_bastion_private_ip}/32"]   #TODO no way to specify only an IP. it has to be a CIDR block
  }

  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    cidr_blocks = [var.qubole_dedicated_vpc_priv_subnet_cidr]
  }

}
