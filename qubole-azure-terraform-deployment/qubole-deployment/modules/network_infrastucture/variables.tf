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

variable "bastion_vm_size" {
  default = "Standard_DS1_v2"
}

variable "bastion_user_name" {
  default = "bastion_user"
}
variable "bastion_user_password" {
  default = "password!23"
}