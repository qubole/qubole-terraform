/*
Creates a VPC that will be dedicated to use by Qubole.
*/

resource "aws_vpc" "qubole_dedicated_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "qubole_dedicated_vpc_${var.deployment_suffix}"
  }

}

output "qubole_dedicated_vpc_arn" {
  value = aws_vpc.qubole_dedicated_vpc.arn
}

output "qubole_dedicated_vpc_id" {
  value = aws_vpc.qubole_dedicated_vpc.id
}

