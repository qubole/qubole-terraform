#### Replace xxxx with values as required. 
# Credentials
access_key = ""
secret_key = ""
aws_session_token = ""

# VPC Env
region = "us-xxxx-1"
vpc_id = "vpc-xxxx"
public_subnets = ["subnet-xxxx", "subnet-xxxx"]
private_subnets = ["subnet-xxxx", "subnet-xxxx"]

#IP Access
access_from_ips = ["99.0.0.0/32"]

#SSH Access
ssh_access = "99.0.0.0/32"

#Prefix Names
prefix_name = "ps-tf-"

#RDS properties
rds_port = 3306
db_user = "root"
db_pwd = "xxxx"
db_engine = "mysql"
db_engine_version = "5.7.25"
db_name = "ranger"
db_ranger_user = "rangeradmin"
db_ranger_pwd = "xxxx"
db_host_name = "ranger-db"
rds_sg_name = "ranger-rds-sg"

rds_sg_desc = "Ranger RDS Secuirty Group"
db_subnet_group_name = "db-subnet"
db_allocated_storage = 20
db_instance_type = "db.t2.micro"

# Security Group for Ranger and Solr
ranger_solr_sg_name = "ranger-solr-ec2-sg"
ranger_solr_sg_desc = "Ranger Solr Security Group"

#Ranger Properties
ranger_port = 6080
ranger_alb_port = 80
ranger_inst_cnt = 2
ranger_inst_name = "ranger-inst"
ranger_base_inst_name = "ranger-base-inst"
ranger_ami_name = "ranger-ami"

ranger_ami_inst_type  = "t2.micro"
ranger_inst_type = "t2.micro"
ranger_alb_sg_name = "ranger-alb-sg"
ranger_alb_sg_desc = "Ranger Application Load Balancer Security Group"
ranger_alb_name_pub = "ranger-alb-pub"
ranger_alb_tg_name_pub = "ranger-alb-tg-pub"
ranger_alb_name_int = "ranger-alb-int"
ranger_alb_tg_name_int = "ranger-alb-tg-int"
ranger_lt_name = "ranger-lt"
ranger_asg_name = "ranger-asg"

ranger_dev_name = "/dev/xvda"
ranger_volume_size = 20

#Solr Properties
solr_port = 6083
solr_alb_port = 80
solr_inst_cnt = 1
solr_inst_name = "solr-inst"
solr_base_inst_name = "solr-base-inst"
solr_ami_name = "solr-ami"
solr_ami_inst_type  = "t2.micro"
solr_inst_type = "t2.micro"
solr_alb_sg_name = "solr-alb-sg"
solr_alb_sg_desc = "Solr Application Load Balancer Security Group"
solr_alb_name_pub = "solr-alb-pub"
solr_alb_tg_name_pub = "solr-alb-tg-pub"
solr_alb_name_int = "solr-alb-int"
solr_alb_tg_name_int = "solr-alb-tg-int"
solr_lt_name = "solr-lt"
solr_asg_name = "solr-asg"

solr_mem = "512m"
solr_dev_name = "/dev/xvda"
solr_volume_size = 20
solr_audit_ret_days = 90

# Defaults
ssh_port = 22
def_inst_cnt = 1
baseami = "ami-xxxx"
cookie_duration = 3600
solr_version = "8.6.1"
ranger_version = "2.0.0"
java_version = "java-1.8.0"
mysql_version = "mysql-connector-java-5.1.48"
mysql_path = "https://dev.mysql.com/get/Downloads/Connector-J"
solr_download_url = "http://archive.apache.org/dist/lucene/solr"
ranger_admin_path = "https://paid-qubole.s3.amazonaws.com/ranger-2.0.0"
ranger_download_url = "https://dist.apache.org/repos/dist/release/ranger"

# Private key without .pem extension
# This key will be used to ssh into Ranger and Solr Instances
key_name = "xxxx"
key_path = "/Users/xxxx"

# Ranger Policy Details
# Default loc without s3 prefix
def_loc = "xxxx"
service_name = "xxxx"
qbol_usr_pwd = "xxxx"
