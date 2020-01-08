/*
Creates an Internet Gateway for
 1. The NAT Gateway running in the public subnet of the Qubole dedicated VPC, and for the Qubole Dedicated VPC
*/

resource "aws_internet_gateway" "qubole_dedicated_vpc_internet_gw" {
  vpc_id = aws_vpc.qubole_dedicated_vpc.id
  tags = {
    Name = "qubole_dedicated_vpc_internet_gw_${var.deployment_suffix}"
  }
}


