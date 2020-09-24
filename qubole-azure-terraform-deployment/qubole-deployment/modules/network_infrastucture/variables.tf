variable "deployment_suffix" {
}

variable "qubole_resource_group_name" {
}

variable "qubole_resource_group_location" {
}

variable "public_ssh_key" {
}

variable "qubole_public_key" {
}

variable "qubole_tunnel_nat" {
  type    = list(string)
  default = ["54.164.240.44/32","52.23.20.1/32","40.121.60.130/32","40.114.27.47/32","13.82.198.90/32","52.44.223.209/32","100.25.6.193/32"]
}

variable "bastion_vm_size" {
  default = "Standard_DS1_v2"
}

variable "bastion_user_name" {
  default = "bastion_user"
}
variable "bastion_user_password" {
  default = "password!23"
}