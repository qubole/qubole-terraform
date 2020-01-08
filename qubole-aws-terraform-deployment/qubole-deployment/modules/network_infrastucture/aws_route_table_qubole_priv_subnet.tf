/*
Creates a Route Table for
 1. The Qubole Dedicated VPC's private subnet
 2. All traffic is routed to the NAT gateway
 3. A VPC endpoint for S3 is created and routed to avoid massive S3 ingress-egress costs
*/

resource "aws_route_table" "qubole_dedicated_vpc_priv_subnet_route_table" {
  vpc_id = aws_vpc.qubole_dedicated_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.qubole_dedicated_vpc_nat_gw.id
  }

  tags = {
    Name = "qubole_dedicated_vpc_priv_subnet_route_table_${var.deployment_suffix}"
  }

}

resource "aws_vpc_endpoint_route_table_association" "qubole_dedicated_vpc_priv_subnet_s3_route" {
  route_table_id = aws_route_table.qubole_dedicated_vpc_priv_subnet_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
}

resource "aws_route_table_association" "qubole_dedicated_vpc_priv_subnet_route_assoc" {
  route_table_id = aws_route_table.qubole_dedicated_vpc_priv_subnet_route_table.id
  subnet_id = aws_subnet.qubole_vpc_private_subnetwork.id
}

output "qubole_dedicated_vpc_priv_subnet_route_table" {
  value = aws_route_table.qubole_dedicated_vpc_priv_subnet_route_table.id
}
