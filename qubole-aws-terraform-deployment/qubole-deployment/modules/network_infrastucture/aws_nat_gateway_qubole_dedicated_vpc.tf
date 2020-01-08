/*
Creates a NAT gateway
 1. Attached to the public subnet in the qubole dedicated VPC

This is for the reason:
 1. Private Subnets disallow VMs from having a public IPv4 address and hence no internet accessibility
 2. NAT allows outbound access while keeping away inbound access
*/

resource "aws_nat_gateway" "qubole_dedicated_vpc_nat_gw" {
  allocation_id = aws_eip.qubole_dedicated_vpc_nat_gw_eip.id
  subnet_id = aws_subnet.qubole_vpc_public_subnetwork.id

  tags = {
    Name = "qubole_dedicated_vpc_nat_gw_${var.deployment_suffix}"
  }

}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.qubole_dedicated_vpc.id
  service_name = "com.amazonaws.${var.data_lake_project_region}.s3"
}

