variable "project" {}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-b"
}

variable "first_run_in_vpc" {}

variable "db_instance_identifier" {}
variable "db_version" {}
variable "db_instance_type" {}
variable "db_disk_type" { default = "PD_SSD" }
variable "db_disk_size" { default = "10" }
variable "db_name" {}
variable "db_user" {}
variable "db_pwd" {}
variable "db_ranger_user" {}
variable "db_ranger_pwd" {}

variable "ranger_admin_name" {}
variable "machine_type" {}
variable "image" {}

variable "instance_tags" {
	type = "list"
}

variable "vpc_network" {}

variable "subnet" {}

variable "firewall_name" {}
variable "target_tags" {
	type = "list"
}

variable "health_check_name" {}
variable "instance_template_name" {}
variable "managed_group_name" {}
variable "auto_scaler_name" {}
variable "min_replicas" {}
variable "max_replicas" {}

variable "lb_firewall_name" {}
variable "lb_name" {}
variable "lb_backend_name" {}
variable "lb_frontend_name" {}
variable "target_proxy" {}
variable "cookie_duration" {}

variable "ranger_port" {}
variable "solr_port" {}
variable "ssh_port" {}

variable "solr_download_url" {}
variable "ranger_solr_name" {}
variable "solr_machine_type" {}