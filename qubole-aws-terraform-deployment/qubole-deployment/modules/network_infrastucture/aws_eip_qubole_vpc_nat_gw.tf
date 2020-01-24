/*
Creates a Elastic IP address for
 1. The NAT Gateway running in the public subnet of the Qubole dedicated VPC
*/
resource "aws_eip" "qubole_dedicated_vpc_nat_gw_eip" {
  vpc      = true
  tags = {
    Name = "qubole_dedicated_vpc_nat_gw_eip_${var.deployment_suffix}"
  }
}
