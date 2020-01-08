/*
Creates a Security group that
 1. Allows ingress to the Bastion Host from Qubole's Tunneling NAT
 2. Allows ingress to the Bastion Host from the Private Subnet in the Qubole Dedicated VPC

 This is for the following reason:
 1. Qubole Control Plane will talk(e.g. command submissions) to the Qubole Clusters via the Bastion Host
*/

resource "aws_security_group" "bastion_security_group" {
  name = "bastion_security_group"
  vpc_id = aws_vpc.qubole_dedicated_vpc.id

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks =var.qubole_tunnel_nat
  }

  ingress {
    from_port = 7000
    protocol = "tcp"
    to_port = 7000
    cidr_blocks = [aws_subnet.qubole_vpc_private_subnetwork.cidr_block]
  }

  #Allow all outbound
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_security_group_${var.deployment_suffix}"
  }

}

output "qubole_bastion_security_group" {
  value = aws_security_group.bastion_security_group.id
}
