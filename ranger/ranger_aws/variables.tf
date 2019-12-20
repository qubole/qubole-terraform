variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {}
variable "public_subnets" {
 type = "list"
}
variable "private_subnets" {
 type = "list"
}
variable "local_ips" {
  type = "list"
}

variable "rds_sg_name" {}
variable "ranger_admin_sg_name" {}
variable "ranger_lb_sg_name" {}

variable "rds_sg_desc" {}
variable "ranger_admin_sg_desc" {}
variable "ranger_lb_sg_desc" {}

variable "ranger_lb_name" {}
variable "ranger_admin_name" {}
variable "ranger_solr_name" {}
variable "ranger_target_name" {}

variable "db_instance_identifier" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_name" {}
variable "db_user" {}
variable "db_pwd" {}
variable "db_ranger_user" {}
variable "db_ranger_pwd" {}
variable "db_subnet_group_name" {}
variable "db_allocated_storage" {}
variable "db_instance_type" {}

variable "ami" {}
variable "ranger_instance_type" {}
variable "solr_instance_type" {}
variable "key_name" {}
variable "instance_count" {
  default = 1
}

variable "ranger_port" {}
variable "solr_port" {}
variable "rds_port" {}
variable "ssh_port" {}


variable "cookie_duration" {}

variable "solr_download_url" {}

variable "log_location" {}




