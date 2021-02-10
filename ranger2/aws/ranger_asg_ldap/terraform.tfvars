#### Replace xxxx with values as required. 
# Credentials
access_key = "xxxx"
secret_key = "xxxx"
aws_session_token = ""

# VPC Env
region = "us-xxxxt-1"
vpc_id = "vpc-xxxx"
public_subnets = ["subnet-xxxx", "subnet-xxxx"]
private_subnets = ["subnet-xxxx", "subnet-xxxx"]

#IP Access
access_from_ips = ["xx.x.x.x/32"]

#SSH Access
ssh_access = "xxx.x.x.x/32"

#Prefix Names
prefix_name = "xx-xx-"

#RDS properties
rds_port = 3306
db_user = "root"
db_pwd = "xxxx"
db_engine = "mysql"
db_engine_version = "5.7.31"
db_name = "ranger"
db_ranger_user = "rangeradmin"
db_ranger_pwd = "xxxx"
db_host_name = "rngr-db"
rds_sg_name = "ranger-rds-sg"

rds_sg_desc = "Ranger RDS Secuirty Group"
db_subnet_group_name = "db-subnet"
db_allocated_storage = 20
db_instance_type = "db.xx.xxxx"

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
ranger_inst_type = "t2.small"
ranger_alb_sg_name = "ranger-alb-sg"
ranger_alb_sg_desc = "Ranger Application Load Balancer Security Group"
ranger_alb_name_pub = "ranger-alb-pub"
ranger_alb_tg_name_pub = "ranger-alb-tg-pub"
ranger_alb_name_int = "ranger-alb-int"
ranger_alb_tg_name_int = "ranger-alb-tg-int"
ranger_lt_name = "ranger-lt"
ranger_asg_name = "ranger-asg"

ranger_dev_name = "/dev/xvda"
ranger_volume_size = 10

## USERSYNC
sync_interval = 5
sync_ldap_url = "ldap://xx.xx.xx.xx:389"
ssl_enabled = "true"
sync_ldap_bind_dn = "cn=xxxx,dc=xxxx,dc=xxxx"
sync_ldap_bind_password = "xxxx"
sync_ldap_search_base = "dc=xxxx,dc=xxxx"
sync_ldap_user_search_base = "ou=xxxx,dc=xxxx,dc=xxxx"
sync_ldap_user_name_attribute = "cn"
sync_group_search_enabled = "true"
sync_group_user_map_sync_enabled = "true"
sync_group_search_base = "ou=xxxx,dc=xxxx,dc=xxxx"
sync_group_object_class = "groupofnames"
sync_group_name_attribute = "cn"
sync_group_member_attribute_name = "member"

#Solr Properties
solr_port = 6083
solr_alb_port = 80
solr_inst_cnt = 1
solr_inst_name = "solr-inst"
solr_base_inst_name = "solr-base-inst"
solr_ami_name = "solr-ami"
solr_ami_inst_type  = "t2.micro"
solr_inst_type = "xx.xxxx"
solr_alb_sg_name = "solr-alb-sg"
solr_alb_sg_desc = "Solr Application Load Balancer Security Group"
solr_alb_name_pub = "solr-alb-pub"
solr_alb_tg_name_pub = "solr-alb-tg-pub"
solr_alb_name_int = "solr-alb-int"
solr_alb_tg_name_int = "solr-alb-tg-int"
solr_lt_name = "solr-lt"
solr_asg_name = "solr-asg"

solr_mem = "xxxm"
solr_dev_name = "/dev/xvda"
solr_volume_size = 10
solr_audit_ret_days = 90

# Defaults
ssh_port = 22
def_inst_cnt = 1
baseami = "ami-xxxx"
cookie_duration = 3600
solr_version = "8.8.0"
ranger_version = "2.1.0"
java_version = "java-1.8.0"
mysql_version = "mysql-connector-java-5.1.48"
mysql_path = "https://dev.mysql.com/get/Downloads/Connector-J"
solr_download_url = "http://archive.apache.org/dist/lucene/solr"
ranger_admin_path = "https://paid-qubole.s3.amazonaws.com/ranger-2.1.0"
ranger_download_url = "https://dist.apache.org/repos/dist/release/ranger"

# Private key without .pem extension
# This key will be used to ssh into Ranger and Solr Instances
key_name = "xxxx"
key_path = "/xxxx/xxxx"

# Ranger Policy Details
# Default loc without s3 prefix
def_loc = "xxxx-xxxx"
service_name = "xxxx"
qbol_usr_pwd = "xxxx"
