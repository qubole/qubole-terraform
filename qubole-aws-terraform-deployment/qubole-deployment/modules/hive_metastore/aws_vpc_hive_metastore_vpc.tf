/*
Creates the Hive Metastore Dedicated VPC.

 This is for the following reason:
 1. Isolating the metastore in a dedicated VPC with no DNS support makes it invisible to the internet
 2. We can selectively control access to it from external applications like Qubole
*/

resource "aws_vpc" "hive_metastore_dedicated_vpc" {
  cidr_block = "11.0.0.0/16"
  enable_dns_support = true

  tags = {
    Name = "hive_metastore_dedicated_vpc_${var.deployment_suffix}"
  }

}
