variable "access_key" {}
variable "secret_key" {}
variable "aws_session_token" {}

variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {}
variable "public_subnets" {
 type = list(string)
}
variable "private_subnets" {
 type = list(string)
}
variable "local_ips" {
  type = list(string)
}

variable "rds_sg_name" {}
variable "ranger_solr_sg_name" {}
variable "ranger_alb_sg_name" {}
variable "solr_alb_sg_name" {}

variable "rds_sg_desc" {}
variable "ranger_solr_sg_desc" {}
variable "ranger_alb_sg_desc" {}
variable "solr_alb_sg_desc" {}

variable "ranger_admin_ami_name" {}
variable "ranger_solr_ami_name" {}

variable "ranger_alb_name" {}
variable "ranger_admin_name" {}
variable "ranger_solr_name" {}
variable "ranger_alb_tg_name" {}

variable "solr_alb_name" {}
variable "solr_alb_tg_name" {}


variable "solr_lt_name" {}
variable "solr_asg_name" {}

variable "ranger_lt_name" {}
variable "ranger_asg_name" {}


variable "db_host_name" {}
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

variable "ranger_ami_instance_type" {}
variable "solr_ami_instance_type" {}
variable "ami" {}

variable "ranger_instance_type" {}
variable "solr_instance_type" {}
variable "key_name" {}

variable "def_inst_cnt" {}
variable "ranger_inst_cnt" {}
variable "solr_inst_cnt" {}

variable "ranger_port" {}
variable "solr_port" {}
variable "rds_port" {}
variable "ssh_port" {}
variable "ranger_alb_port" {}
variable "solr_alb_port" {}

variable "cookie_duration" {}

variable "mysql_path" {}
variable "mysql_version" {}
variable "solr_version" {}
variable "ranger_version" {}
variable "solr_download_url" {}
variable "ranger_download_url" {}
variable "ranger_admin_path" {}

variable "java_version" {}

variable "def_loc" {}
variable "service_name" {}

#variable "log_location" {}
