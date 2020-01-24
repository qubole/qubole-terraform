variable "deployment_suffix" {
}

variable "data_lake_project" {
}

variable "data_lake_project_number" {
}

variable "data_lake_project_region" {
  default = "asia-southeast1"
}

variable "qubole_bastion_host_vm_type" {
  default = "f1-micro"
}

variable "qubole_bastion_host_vm_zone" {
  default = "asia-southeast1-a"
}

variable "qubole_tunnel_nat" {
  default = "34.73.1.130/32"
}

variable "qubole_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDS6HgK+J0m8Q+Zn6MZVwYNSWI3d8vD1Z0CDt+aHg4oz7CSUH4hZ2U1pJMsmu5+ntz8OWsGW7MBpDjrzMQAG2nnKtKmKNXAAOwUxhP1If5ZZfEGocysu/OkFnXti6F3z61aTioU8CqQ6IojNCudI7cL+TE+jN2G+AJ/MF9BaqUhOzBUbePOgxGMcpIdh3iDrVU4tATMJx7i4CrAXDK4KKWcQzCP0fYQnS/Vg05Zz4MJiE8CBM/WbRNIFPJHYlWzbZv8SfPPhJzi/4k1Y0wwgMBEw03uMZ+iAtgVaDPxOshklBz4IZ3RKq9Gsm1CyWHJwB2Nb4lIV2RQcb8sQUQNCwU1 canopykey"
}

variable "account_ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCew2pM/Kpr6+ELb86tuy/6gA4/1g23Ey//gD356QLgUAHtpwI/BPBJh3TVsZMA+fjZt70BrzTE5Cy/+Buw9o2aBSfuEPe9rG6VijiJiN16dAbzNZYn116JOW9Fe2l1F6Q1sEqS1zPArsyzPoVDRdadbqSrwZoTzUhF8xcU4kj/Kas0kh0nX4Z9wykE/SGUwE6EYh+6eEHVhN9ubsBim843aQi+EZF+kpd61m2cMNpK/NWXQ3xwxyNGf3/sjybInQl2yVXSwllGum9OXTsAmCMlJXN63pqMTlKSmCtiiH7BOWK5QFf8eHNskcQU4BGxwYxulQVvnNl/Xz4qKGzbodmH"
}