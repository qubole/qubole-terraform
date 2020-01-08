/*
Creates a EC2 instance that will act as a Bastion Host in the Qubole Dedicated VPC
 Features
 1. A network interface allowing for a Public IP address
 2. A custom start up script to create a user configured with accessibility from Qubole
       - the script should also setup the system to accept Qubole's Public Key and Customer's Account Level SSH key

 This is for the following reason:
 1. Create a secure channel (ssh tunnel forwarding) between the Qubole Control Plane and the Customer's Big Data Clusters
    - This secure channel will be used to submit commands, perform admin tasks and retrieving results
 3. Create a secure channel (ssh tunnel forwarding) between the Qubole Control Plane and the Customer's Hive Metastore
    - This secure channel will be used by the Qubole Control Plane to list the schemas and tables available in the Customer's Hive Metastore
    - This is ONLY for metadata. No customer data will flow via this channel

 Caveats:
 1. The Bastion needs to be configured to accept
    - Qubole's Public SSH Key
    - Customer's Account Level Public SSH Key, retrievable via REST or Qubole UI
    - The SSH service should allow Gateway ports
*/

data "template_file" "qubole_bastion_ssh_bootstrap" {
  template = file("${path.module}/scripts/qubole_bastion_startup.sh")
  vars = {
    public_ssh_key = var.public_ssh_key
    qubole_public_key = var.qubole_public_key
  }
}

resource "aws_instance" "qubole_bastion_host" {
  ami = var.bastion_ami
  instance_type = var.bastion_instance_type
  vpc_security_group_ids = [
    aws_security_group.bastion_security_group.id
  ]
  subnet_id = aws_subnet.qubole_vpc_public_subnetwork.id

  user_data_base64 = base64encode(data.template_file.qubole_bastion_ssh_bootstrap.rendered)

  key_name = var.terraform_deployer_key_name

  tags = {
    Name = "qubole_bastion_host_${var.deployment_suffix}"
    Project = "qubole-aws"
  }


}
