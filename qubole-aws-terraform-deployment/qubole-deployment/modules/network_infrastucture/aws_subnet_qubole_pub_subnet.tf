/*
Creates a SubNetwork in the Qubole Dedicated VPC.
 1. This will be the notional public subnetwork in which a Bastion Host will reside

 This is for the following reason:
 1. The Bastion host is the secure gateway through which Qubole will talk to the clusters running in the customer's project/network
*/

resource "aws_subnet" "qubole_vpc_public_subnetwork" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.qubole_dedicated_vpc.id
  map_public_ip_on_launch = false

  tags = {
    Name = "qubole_vpc_public_subnetwork_${var.deployment_suffix}"
  }

}

output "qubole_vpc_public_subnetwork_cidr" {
  value = aws_subnet.qubole_vpc_public_subnetwork.cidr_block
}
