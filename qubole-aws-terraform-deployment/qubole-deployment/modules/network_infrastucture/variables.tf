variable "deployment_suffix" {
}

variable "data_lake_project_region" {
  default = "ap-southeast-1"
}

variable "public_ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCeetBUHVCREiirJD/wIWbaQ6li04ywavNuwytCSIHw7O5XPKdx5AsuELQZ/fs86zPLrJahBVz+ACQdKAeV9aVSMLg/+O7BtNKxZDlL+Gaj+FlaOFiCoBSNmiLUFWoVFDa5rT9OD9d6rvxkAs7ldDWYTXbomqeCC1gESmEjKtjbDVxMHZHaLeSPXOHcqhcPE1rbBONN0ykzgtxmsSxeAhYGPSjPvarG8BFOzyI9RFqVm5tspdi3ShEs93uhFqfdFUizyAZwTGTfIB141Lan7wyvuB6MbVKGNF8aIwiSeZnPt63s/1imiCB8cYztdEnsEXPy428O0IsqAeLVW43ZY6Lh"
}

variable "qubole_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyODZaLl2DgacYHgLrRCm1SfvvLGetuTZFZWhrWmbGpdxbYQLX08V8cW/UrLouExksE+Qs6WpfS3Jwkudfr6SSjzbR0m+vlNiwDFd1/tF/LaeJ1+nIWDgjisRcFUEf+XaAGRYpjcK3S539bK1APGdVh/nEVy4mu0MaQIreU+DQuPWUi1FX0qLMqQppdOZpsS2dDpYcPmwvOHnItVUSNSXUZag/7RRhz5R0h3ZDg/ZiW/cPTe08yR1PX15GLT/KYMbwVAzP/FeBZ3mhaWS1Ct2n/vnooyt9HAjJoe4Fw9CQLNx86WcxY6U4zzxltNL2EN6A2ISSYdcrj9V2Wu7iepxT qubole"
}

variable "qubole_tunnel_nat" {
  type    = list(string)
  default = ["52.44.223.209/32", "100.25.6.193/32"]
}

variable "bastion_ami" {
  default = "ami-0c3326e0cad1779ba"
}

variable "bastion_instance_type" {
  default = "t2.micro"
}

variable "terraform_deployer_key_name" {}