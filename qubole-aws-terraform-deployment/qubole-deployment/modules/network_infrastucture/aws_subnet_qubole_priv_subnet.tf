/*
Creates a SubNetwork in the Qubole Dedicated VPC.
 1. This will be the notional private subnetwork in which Qubole will launch clusters without External IP

 This is for the following reason:
 1. Not having internet access can be an important security requirment
*/

resource "aws_subnet" "qubole_vpc_private_subnetwork" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.qubole_dedicated_vpc.id
  map_public_ip_on_launch = false

  tags = {
    Name = "qubole_vpc_private_subnetwork_${var.deployment_suffix}"
  }

}

output "qubole_vpc_private_subnet" {
  value = aws_subnet.qubole_vpc_private_subnetwork.arn
}

output "qubole_vpc_private_subnet_cidr" {
  value = aws_subnet.qubole_vpc_private_subnetwork.cidr_block
}

output "qubole_vpc_az" {
  value = aws_subnet.qubole_vpc_private_subnetwork.availability_zone
}

