# Credentials
variable "access_key" {}
variable "secret_key" {}
variable "aws_session_token" {}

# VPC Env
variable "region" {}
variable "vpc_id" {}
variable "public_subnets" {
 type = list(string)
}
variable "private_subnets" {
 type = list(string)
}
#IP Access
variable "access_from_ips" {
  type = list(string)
}

#SSH Access
variable "ssh_access" {
  type = list(string)
}

#RDS properties
variable "rds_port" {}
variable "db_user" {}
variable "db_pwd" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_name" {}
variable "db_ranger_user" {}
variable "db_ranger_pwd" {}
variable "db_host_name" {}
variable "rds_sg_name" {}
variable "rds_sg_desc" {}
variable "db_subnet_group_name" {}
variable "db_allocated_storage" {}
variable "db_instance_type" {}

# Security Group for Ranger and Solr
variable "ranger_solr_sg_name" {}
variable "ranger_solr_sg_desc" {}

#Ranger Properties
variable "ranger_port" {}
variable "ranger_alb_port" {}
variable "ranger_inst_cnt" {}
variable "ranger_inst_name" {}
variable "ranger_base_inst_name" {}
variable "ranger_ami_name" {}
variable "ranger_ami_inst_type" {}
variable "ranger_inst_type" {}
variable "ranger_alb_sg_name" {}
variable "ranger_alb_sg_desc" {}
variable "ranger_alb_name_pub" {}
variable "ranger_alb_tg_name_pub" {}
variable "ranger_alb_name_int" {}
variable "ranger_alb_tg_name_int" {}
variable "ranger_lt_name" {}
variable "ranger_asg_name" {}
variable "ranger_dev_name" {}
variable "ranger_volume_size" {}

#Solr Properties
variable "solr_port" {}
variable "solr_alb_port" {}
variable "solr_inst_cnt" {}
variable "solr_inst_name" {}
variable "solr_base_inst_name" {}
variable "solr_ami_name" {}
variable "solr_ami_inst_type" {}
variable "solr_inst_type" {}
variable "solr_alb_sg_name" {}
variable "solr_alb_sg_desc" {}
variable "solr_alb_name_pub" {}
variable "solr_alb_tg_name_pub" {}
variable "solr_alb_name_int" {}
variable "solr_alb_tg_name_int" {}
variable "solr_lt_name" {}
variable "solr_asg_name" {}
variable "solr_mem" {}
variable "solr_dev_name" {}
variable "solr_volume_size" {}
variable "solr_audit_ret_days" {}

# Defaults
variable "ssh_port" {}
variable "def_inst_cnt" {}
variable "baseami" {}
variable "cookie_duration" {}
variable "solr_version" {}
variable "ranger_version" {}
variable "java_version" {}
variable "mysql_version" {}
variable "mysql_path" {}
variable "solr_download_url" {}
variable "ranger_admin_path" {}
variable "ranger_download_url" {}

# Private key without .pem extension
# This key will be used to ssh into Ranger and Solr Instances
variable "key_name" {}

# Ranger Policy Details
# Default loc without s3 prefix
variable "def_loc" {}
variable "service_name" {}
variable "qbol_usr_pwd" {}
